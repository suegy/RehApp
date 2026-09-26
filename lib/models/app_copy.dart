import 'app_content.dart';

class AppCopy {
  const AppCopy(this.locale, this.strings);

  final String locale;
  final AppStrings strings;

  String get tagline => strings['tagline'];
  String get loginWelcome => strings['login_welcome'];
  String get email => strings['email'];
  String get password => strings['password'];
  String get login => strings['login'];
  String get about => strings['about'];
  String get logout => strings['logout'];
  String get noticeTitle => strings['notice_title'];
  String get noticeBody => strings['notice_body'];
  String get pathNow => strings['path_now'];
  String get welcomeBack => strings['welcome_back'];
  String get pathIntro => strings['path_intro'];
  String get core => strings['module_core'];
  String get inProgress => strings['in_progress'];
  String get continueText => strings['continue'];
  String get later => strings['available_later'];
  String get locked => strings['locked'];
  String get back => strings['back'];
  String get moduleSummary => strings['module_summary'];
  String get activity => strings['activity'];
}
