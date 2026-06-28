import 'package:flutter/material.dart';
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

  void _showCategoryDialog({QuizCategory? category}) {
    final nameController = TextEditingController(text: category?.name);
    final descController = TextEditingController(text: category?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? "Add Category" : "Edit Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                if (category == null) {
                  await ApiService.createCategory(nameController.text, descController.text);
                } else {
                  await ApiService.updateCategory(category.id, nameController.text, descController.text);
                }
                if (mounted) {
                  Navigator.pop(context);
                  _refreshCategories();
                }
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),
      body: FutureBuilder<List<QuizCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          final categories = snapshot.data ?? [];

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(cat.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showCategoryDialog(category: cat)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Category?"),
                            content: const Text("This will delete all questions in this category."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ApiService.deleteCategory(cat.id);
                          _refreshCategories();
                        }
                      },
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageQuestions(category: cat))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
