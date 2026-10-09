import 'package:quiz_shell/service/auth_service.dart';

class UserData {
  static const String placeholderImageUrl = 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

  static String get userImageUrl => AuthService().currentUser?.photoURL ?? placeholderImageUrl;
  static String get userName => AuthService().currentUser?.displayName ?? '--';
  static String get userEmail => AuthService().currentUser?.email ?? '--';
  static String get userJoined => AuthService().currentUser?.metadata.creationTime?.toString().split(" ").first ?? '--';
}
