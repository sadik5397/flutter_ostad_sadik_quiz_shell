import 'package:flutter/material.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/theme/theme_padding.dart';
import 'package:quiz_shell/widgets/quiz_loading_shimmer.dart';

import '../model/quiz_category_model.dart';
import '../service/api_service.dart';
import 'manage_questions.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  late Future<List<QuizCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  void _refreshCategories() {
    setState(() {
      _categoriesFuture = ApiService.getCategories();
    });
  }

  Future<void> _handleRefresh() async {
    _refreshCategories();
    await _categoriesFuture;
  }

  void _showCategoryDialog({QuizCategory? category}) {
    final nameController = TextEditingController(text: category?.name);
    final descController = TextEditingController(text: category?.description);
    final formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? l10n.newCategory : l10n.editCategory),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.categoryName,
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.required : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                if (category == null) {
                  await ApiService.createCategory(nameController.text, descController.text);
                } else {
                  await ApiService.updateCategory(category.id, nameController.text, descController.text);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshCategories();
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageCategories)),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<QuizCategory>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const QuizLoadingShimmer();
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text("${l10n.error}: ${snapshot.error}"),
                    TextButton(onPressed: _refreshCategories, child: Text(l10n.retry)),
                  ],
                ),
              );
            }
            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined, size: 80, color: colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noCategoriesFound,
                      style: TextStyle(fontSize: 18, color: colorScheme.outline, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.tapToAddNewCategory),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: ThemePadding.horizontal + ThemePadding.bottom * 12,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageQuestions(category: cat))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              cat.name[0].toUpperCase(),
                              style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                if (cat.description.isNotEmpty)
                                  Text(
                                    cat.description,
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                            onPressed: () => _showCategoryDialog(category: cat),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: colorScheme.error),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deleteCategory),
                                  content: Text(l10n.deleteCategoryWarning),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
                                    FilledButton(
                                      style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text(l10n.delete),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                try {
                                  await ApiService.deleteCategory(cat.id);
                                  _refreshCategories();
                                } catch (e) {
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showCategoryDialog(), icon: const Icon(Icons.add), label: Text(l10n.addCategory)),
    );
  }
}
