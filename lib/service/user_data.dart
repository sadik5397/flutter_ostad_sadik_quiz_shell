import 'package:quiz_shell/service/auth_service.dart';

class UserData {
  static String placeholderImageUrl = 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';
  static String userImageUrl = AuthService().currentUser?.photoURL ?? placeholderImageUrl;
  static String userName = AuthService().currentUser?.displayName ?? '--';
  static String userEmail = AuthService().currentUser?.email ?? '--';
  static String userMobileNumber = '--';
  static bool isSubscribed = false;
  static String userJoined = AuthService().currentUser?.metadata.creationTime.toString().split(" ").first ?? '--';
}
