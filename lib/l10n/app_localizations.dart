import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Shell'**
  String get appTitle;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @readyToPlay.
  ///
  /// In en, this message translates to:
  /// **'Ready to play'**
  String get readyToPlay;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @checkLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Check Leaderboard'**
  String get checkLeaderboard;

  /// No description provided for @adminOptions.
  ///
  /// In en, this message translates to:
  /// **'Admin Options'**
  String get adminOptions;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed!'**
  String get quizCompleted;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job! You have done well'**
  String get greatJob;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @switchTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchTheme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get bangla;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @incorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Answer'**
  String get incorrectAnswer;

  /// No description provided for @quizNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Quiz is not available right now!'**
  String get quizNotAvailable;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @yourRank.
  ///
  /// In en, this message translates to:
  /// **'Your Rank'**
  String get yourRank;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get signInFailed;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signUpToProtect.
  ///
  /// In en, this message translates to:
  /// **'Sign up to protect your device'**
  String get signUpToProtect;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInAction;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have any Account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @manageCategoriesAndQuestions.
  ///
  /// In en, this message translates to:
  /// **'MANAGE CATEGORIES & QUESTIONS'**
  String get manageCategoriesAndQuestions;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @editQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get editQuestion;

  /// No description provided for @theQuestion.
  ///
  /// In en, this message translates to:
  /// **'The Question'**
  String get theQuestion;

  /// No description provided for @enterQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter question title'**
  String get enterQuestionTitle;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question'**
  String get enterQuestion;

  /// No description provided for @answerOptions.
  ///
  /// In en, this message translates to:
  /// **'Answer Options'**
  String get answerOptions;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get option;

  /// No description provided for @addMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'Add More Options'**
  String get addMoreOptions;

  /// No description provided for @misc.
  ///
  /// In en, this message translates to:
  /// **'Misc.'**
  String get misc;

  /// No description provided for @markForThisQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mark for this question'**
  String get markForThisQuestion;

  /// No description provided for @enterMark.
  ///
  /// In en, this message translates to:
  /// **'Enter mark'**
  String get enterMark;

  /// No description provided for @submitQuestion.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT QUESTION'**
  String get submitQuestion;

  /// No description provided for @updateQuestion.
  ///
  /// In en, this message translates to:
  /// **'UPDATE QUESTION'**
  String get updateQuestion;

  /// No description provided for @maxOptionsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 options allowed'**
  String get maxOptionsAllowed;

  /// No description provided for @pleaseSelectCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please select the correct answer'**
  String get pleaseSelectCorrectAnswer;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToLoadQuestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get failedToLoadQuestions;

  /// No description provided for @locallyAddedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Locally Added Questions'**
  String get locallyAddedQuestions;

  /// No description provided for @brainstormWithAi.
  ///
  /// In en, this message translates to:
  /// **'Brainstorm with AI'**
  String get brainstormWithAi;

  /// No description provided for @noQuizPlayedYet.
  ///
  /// In en, this message translates to:
  /// **'No Quiz Played Yet'**
  String get noQuizPlayedYet;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Not available yet, coming soon'**
  String get comingSoon;

  /// No description provided for @aiPoweredQuizShell.
  ///
  /// In en, this message translates to:
  /// **'AI Powered Quiz Shell'**
  String get aiPoweredQuizShell;

  /// No description provided for @noNeedToSignUp.
  ///
  /// In en, this message translates to:
  /// **'No need to sign up.\nJust sign in with Google'**
  String get noNeedToSignUp;

  /// No description provided for @chatWithAi.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chatWithAi;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @quizCategories.
  ///
  /// In en, this message translates to:
  /// **'Quiz Categories'**
  String get quizCategories;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @tapToAddNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new category'**
  String get tapToAddNewCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category?'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete all questions in this category. This action cannot be undone.'**
  String get deleteCategoryWarning;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @deleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Question?'**
  String get deleteQuestion;

  /// No description provided for @deleteQuestionWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone and the question will be permanently removed.'**
  String get deleteQuestionWarning;

  /// No description provided for @noQuestionsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No questions in this category'**
  String get noQuestionsInCategory;

  /// No description provided for @tapToAddFirstQuestion.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first question'**
  String get tapToAddFirstQuestion;

  /// No description provided for @aiQuiz.
  ///
  /// In en, this message translates to:
  /// **'AI Quiz'**
  String get aiQuiz;

  /// No description provided for @anyTopic.
  ///
  /// In en, this message translates to:
  /// **'Any topic'**
  String get anyTopic;

  /// No description provided for @generateAiQuiz.
  ///
  /// In en, this message translates to:
  /// **'Generate AI Quiz'**
  String get generateAiQuiz;

  /// No description provided for @aiQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Write any topic or subject and the AI will craft a quiz for you.'**
  String get aiQuizDescription;

  /// No description provided for @aiQuizTopicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. World History, JavaScript Basics…'**
  String get aiQuizTopicHint;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @pleaseEnterTopic.
  ///
  /// In en, this message translates to:
  /// **'Please enter a topic'**
  String get pleaseEnterTopic;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get messageHint;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @playAndWin.
  ///
  /// In en, this message translates to:
  /// **'Play and Win'**
  String get playAndWin;

  /// No description provided for @startQuizNow.
  ///
  /// In en, this message translates to:
  /// **'Start a quiz now and enjoy'**
  String get startQuizNow;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @playedOn.
  ///
  /// In en, this message translates to:
  /// **'Played on'**
  String get playedOn;

  /// No description provided for @craftingQuiz.
  ///
  /// In en, this message translates to:
  /// **'Crafting quiz for \"{topic}\"…'**
  String craftingQuiz(Object topic);

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @addNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add New Question'**
  String get addNewQuestion;

  /// No description provided for @resetForm.
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get resetForm;

  /// No description provided for @pleaseSelectCorrectAnswerLong.
  ///
  /// In en, this message translates to:
  /// **'Please select the correct answer by tapping the radio button next to it'**
  String get pleaseSelectCorrectAnswerLong;

  /// No description provided for @questionSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Question saved successfully!'**
  String get questionSavedSuccessfully;

  /// No description provided for @errorSavingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Error saving question: {error}'**
  String errorSavingQuestion(Object error);

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. +8801712345678'**
  String get mobileNumberHint;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @pleaseEnterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get pleaseEnterValidMobile;

  /// No description provided for @provideMobileNumberGreeting.
  ///
  /// In en, this message translates to:
  /// **'One more step'**
  String get provideMobileNumberGreeting;

  /// No description provided for @provideMobileNumberDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide your mobile number to complete your profile and continue.'**
  String get provideMobileNumberDescription;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @mobileSaved.
  ///
  /// In en, this message translates to:
  /// **'Mobile number saved'**
  String get mobileSaved;

  /// No description provided for @mobileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save mobile number'**
  String get mobileSaveFailed;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @subscriptionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription required'**
  String get subscriptionRequiredTitle;

  /// No description provided for @subscriptionRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account is not currently subscribed. Please subscribe to this service to continue using the app.'**
  String get subscriptionRequiredDescription;

  /// No description provided for @subscriptionNotActive.
  ///
  /// In en, this message translates to:
  /// **'Subscription is not active yet'**
  String get subscriptionNotActive;

  /// No description provided for @reCheckSubscription.
  ///
  /// In en, this message translates to:
  /// **'Recheck subscription'**
  String get reCheckSubscription;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP to Subscribe'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// No description provided for @unsubscribeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unsubscribe?'**
  String get unsubscribeConfirm;

  /// No description provided for @unsubscribed.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribed successfully'**
  String get unsubscribed;

  /// No description provided for @unsubscribeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to unsubscribe'**
  String get unsubscribeFailed;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @referenceNo.
  ///
  /// In en, this message translates to:
  /// **'Reference No'**
  String get referenceNo;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent'**
  String get otpSent;

  /// No description provided for @otpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get otpSendFailed;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP verified'**
  String get otpVerified;

  /// No description provided for @otpVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'OTP verification failed'**
  String get otpVerificationFailed;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @notSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Not subscribed'**
  String get notSubscribed;

  /// No description provided for @editPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit phone number'**
  String get editPhoneNumber;

  /// No description provided for @updatePhoneNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Update phone number'**
  String get updatePhoneNumberTitle;

  /// No description provided for @updatePhoneNumberDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a new mobile number. Your subscription will be re-verified against this number.'**
  String get updatePhoneNumberDescription;

  /// No description provided for @phoneNumberUpdated.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated'**
  String get phoneNumberUpdated;

  /// No description provided for @phoneNumberUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update phone number'**
  String get phoneNumberUpdateFailed;

  /// No description provided for @subscriptionRequiredToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription required'**
  String get subscriptionRequiredToPlayTitle;

  /// No description provided for @subscriptionRequiredToPlayDescription.
  ///
  /// In en, this message translates to:
  /// **'You need an active subscription to start a quiz. Please subscribe from your profile to continue.'**
  String get subscriptionRequiredToPlayDescription;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now!'**
  String get subscribeNow;

  /// No description provided for @enterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterOtpTitle;

  /// No description provided for @enterOtpDescription.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to your mobile number. Enter it below to verify.'**
  String get enterOtpDescription;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpCode;

  /// No description provided for @pleaseEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code'**
  String get pleaseEnterOtp;

  /// No description provided for @otpMustBeSixDigits.
  ///
  /// In en, this message translates to:
  /// **'The code must be exactly 6 digits'**
  String get otpMustBeSixDigits;

  /// No description provided for @otpAutoFillHint.
  ///
  /// In en, this message translates to:
  /// **'Waiting for SMS…'**
  String get otpAutoFillHint;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @otpPageHint.
  ///
  /// In en, this message translates to:
  /// **'OTP not received? You can edit your phone number or try again.'**
  String get otpPageHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
