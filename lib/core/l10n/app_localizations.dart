import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_vi.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('pt'),
    Locale('vi'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Lingo Snack'**
  String get appName;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @registerTagline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start using Zingo and boost your English skills with bite-size dialogs'**
  String get registerTagline;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started!'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Set your profile to start your English learning journey'**
  String get registrationSuccessDesc;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @welcomeLearnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, learner!'**
  String get welcomeLearnerTitle;

  /// No description provided for @welcomeLearnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Let us know more about you to suggest the best learning route for you'**
  String get welcomeLearnerDesc;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @orGetStartedWith.
  ///
  /// In en, this message translates to:
  /// **'Or get started with'**
  String get orGetStartedWith;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get startNow;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile settings'**
  String get profileSettings;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @displayNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we greet you in the app.'**
  String get displayNameSubtitle;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get displayNameHint;

  /// No description provided for @motherLanguage.
  ///
  /// In en, this message translates to:
  /// **'Mother language'**
  String get motherLanguage;

  /// No description provided for @motherLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The language you use to communicate with the app.'**
  String get motherLanguageSubtitle;

  /// No description provided for @displayLanguage.
  ///
  /// In en, this message translates to:
  /// **'Display language'**
  String get displayLanguage;

  /// No description provided for @displayLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The language you want to see in the app.'**
  String get displayLanguageSubtitle;

  /// No description provided for @practiceGoal.
  ///
  /// In en, this message translates to:
  /// **'Practice goal'**
  String get practiceGoal;

  /// No description provided for @practiceGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many dialogs do you want to practice each day?'**
  String get practiceGoalSubtitle;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notificationTime;

  /// No description provided for @notificationTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When do you want to receive notifications?'**
  String get notificationTimeSubtitle;

  /// No description provided for @favouriteTopics.
  ///
  /// In en, this message translates to:
  /// **'Favourite topics'**
  String get favouriteTopics;

  /// No description provided for @favouriteTopicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick as many as you like; we\'ll personalise your dialogs.'**
  String get favouriteTopicsSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get choosePlan;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpCenter;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @acknowledgements.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgements'**
  String get acknowledgements;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @needProfileToConnect.
  ///
  /// In en, this message translates to:
  /// **'You need a profile to connect with friends'**
  String get needProfileToConnect;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get chooseLanguage;

  /// No description provided for @choosePracticeGoal.
  ///
  /// In en, this message translates to:
  /// **'Choose a practice goal'**
  String get choosePracticeGoal;

  /// No description provided for @pickATime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get pickATime;

  /// No description provided for @pickAGoal.
  ///
  /// In en, this message translates to:
  /// **'Pick a goal'**
  String get pickAGoal;

  /// No description provided for @pickALanguage.
  ///
  /// In en, this message translates to:
  /// **'Pick a language'**
  String get pickALanguage;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lingo Snack'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bite-size English dialogs, every day.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingDisplayNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingDisplayNameTitle;

  /// No description provided for @onboardingDisplayNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a display name — you can change it later.'**
  String get onboardingDisplayNameSubtitle;

  /// No description provided for @onboardingNativeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your native language?'**
  String get onboardingNativeLanguageTitle;

  /// No description provided for @onboardingNativeLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll translate hints and feedback into it.'**
  String get onboardingNativeLanguageSubtitle;

  /// No description provided for @onboardingPracticeGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your daily goal'**
  String get onboardingPracticeGoalTitle;

  /// No description provided for @onboardingPracticeGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many dialogs do you want to complete each day?'**
  String get onboardingPracticeGoalSubtitle;

  /// No description provided for @onboardingReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a daily reminder'**
  String get onboardingReminderTitle;

  /// No description provided for @onboardingReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll nudge you at this time every day.'**
  String get onboardingReminderSubtitle;

  /// No description provided for @onboardingTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your favourite topics'**
  String get onboardingTopicsTitle;

  /// No description provided for @onboardingTopicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll personalise your dialog suggestions.'**
  String get onboardingTopicsSubtitle;

  /// No description provided for @onboardingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Zingo'**
  String get onboardingSuccessTitle;

  /// No description provided for @onboardingSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start using Zingo and boost your English skills with bite-size dialogs'**
  String get onboardingSuccessDesc;

  /// No description provided for @onboardingErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get onboardingErrorDesc;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go! 🚀'**
  String get letsGo;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @enterNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterNameHint;

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @pickDisplayNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick a name that will be used to identify you in the app.'**
  String get pickDisplayNameDesc;

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTimeTitle;

  /// No description provided for @reminderTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll nudge you so you never break your streak'**
  String get reminderTimeSubtitle;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get dailyReminders;

  /// No description provided for @orPickCustomTime.
  ///
  /// In en, this message translates to:
  /// **'Or pick a custom time'**
  String get orPickCustomTime;

  /// No description provided for @browseAllDialogs.
  ///
  /// In en, this message translates to:
  /// **'Browse all dialogs'**
  String get browseAllDialogs;

  /// No description provided for @browseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice freely without any filters'**
  String get browseSubtitle;

  /// No description provided for @continuePracticing.
  ///
  /// In en, this message translates to:
  /// **'Continue practicing'**
  String get continuePracticing;

  /// No description provided for @noSessionsInProgress.
  ///
  /// In en, this message translates to:
  /// **'No sessions in progress'**
  String get noSessionsInProgress;

  /// No description provided for @startNewSession.
  ///
  /// In en, this message translates to:
  /// **'Start a new session to continue practicing'**
  String get startNewSession;

  /// No description provided for @yourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your favorites'**
  String get yourFavorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @addFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite topics to continue practicing'**
  String get addFavoritesHint;

  /// No description provided for @dailyStreak.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get dailyStreak;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @practiceToday.
  ///
  /// In en, this message translates to:
  /// **'Practice today - keep the fire alive!'**
  String get practiceToday;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @recommendedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on your level and recent practice'**
  String get recommendedSubtitle;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @sessionsInProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} in progress'**
  String sessionsInProgress(int count);

  /// No description provided for @practiceStart.
  ///
  /// In en, this message translates to:
  /// **'Start practice'**
  String get practiceStart;

  /// No description provided for @practiceResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get practiceResume;

  /// No description provided for @practiceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get practiceCompleted;

  /// No description provided for @practiceScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get practiceScore;

  /// No description provided for @practiceFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get practiceFeedback;

  /// No description provided for @practiceMode.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE MODE'**
  String get practiceMode;

  /// No description provided for @whatsTheDifference.
  ///
  /// In en, this message translates to:
  /// **'What\'s the difference?'**
  String get whatsTheDifference;

  /// No description provided for @modeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This mode is not available yet'**
  String get modeNotAvailable;

  /// No description provided for @startingPractice.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get startingPractice;

  /// No description provided for @endTurn.
  ///
  /// In en, this message translates to:
  /// **'End Turn'**
  String get endTurn;

  /// No description provided for @turnsProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} turns'**
  String turnsProgress(int current, int total);

  /// No description provided for @dialogCompleted.
  ///
  /// In en, this message translates to:
  /// **'Dialog complete! 🎉'**
  String get dialogCompleted;

  /// No description provided for @dialogCompletedDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished the dialog. Great job!'**
  String get dialogCompletedDesc;

  /// No description provided for @niceKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Nice! Keep going 👍'**
  String get niceKeepGoing;

  /// No description provided for @tapContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap Continue to move to the next turn.'**
  String get tapContinue;

  /// No description provided for @errorNoAudio.
  ///
  /// In en, this message translates to:
  /// **'This turn does not have an audio yet'**
  String get errorNoAudio;

  /// No description provided for @micTransitioning.
  ///
  /// In en, this message translates to:
  /// **'The microphone is transitioning…'**
  String get micTransitioning;

  /// No description provided for @accuracyTooLow.
  ///
  /// In en, this message translates to:
  /// **'Your accuracy is only {percent}%. Please try again.'**
  String accuracyTooLow(int percent);

  /// No description provided for @keepTrying.
  ///
  /// In en, this message translates to:
  /// **'Keep trying!'**
  String get keepTrying;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'HOW IT WORKS'**
  String get howItWorks;

  /// No description provided for @howItWorksStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Listen & see the sample'**
  String get howItWorksStep1Title;

  /// No description provided for @howItWorksStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'AI speaks. A scene image and sample reply appear.'**
  String get howItWorksStep1Desc;

  /// No description provided for @howItWorksStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Say it your way — or read it'**
  String get howItWorksStep2Title;

  /// No description provided for @howItWorksStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap mic, speak, tap again to stop.'**
  String get howItWorksStep2Desc;

  /// No description provided for @howItWorksStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Get instant feedback'**
  String get howItWorksStep3Title;

  /// No description provided for @howItWorksStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Scored on 3 dimensions. Re-record any turn.'**
  String get howItWorksStep3Desc;

  /// No description provided for @youllBeScoredOn.
  ///
  /// In en, this message translates to:
  /// **'YOU\'LL BE SCORED ON'**
  String get youllBeScoredOn;

  /// No description provided for @scoreRanges.
  ///
  /// In en, this message translates to:
  /// **'Score ranges:'**
  String get scoreRanges;

  /// No description provided for @scoreDimGrammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get scoreDimGrammar;

  /// No description provided for @scoreDimGrammarTag.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get scoreDimGrammarTag;

  /// No description provided for @scoreDimGrammarDesc.
  ///
  /// In en, this message translates to:
  /// **'Correct tense, agreement, word order, prepositions.'**
  String get scoreDimGrammarDesc;

  /// No description provided for @scoreDimGrammarExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Try \'could I have\' — more polite here.\"'**
  String get scoreDimGrammarExample;

  /// No description provided for @scoreDimNaturalness.
  ///
  /// In en, this message translates to:
  /// **'Naturalness'**
  String get scoreDimNaturalness;

  /// No description provided for @scoreDimNaturalnessTag.
  ///
  /// In en, this message translates to:
  /// **'Native-like'**
  String get scoreDimNaturalnessTag;

  /// No description provided for @scoreDimNaturalnessDesc.
  ///
  /// In en, this message translates to:
  /// **'How fluent and idiomatic your phrasing sounds.'**
  String get scoreDimNaturalnessDesc;

  /// No description provided for @scoreDimNaturalnessExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Skip \'please\' mid-sentence — feels more casual.\"'**
  String get scoreDimNaturalnessExample;

  /// No description provided for @scoreDimCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Completeness'**
  String get scoreDimCompleteness;

  /// No description provided for @scoreDimCompletenessTag.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get scoreDimCompletenessTag;

  /// No description provided for @scoreDimCompletenessDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether you addressed everything the AI asked.'**
  String get scoreDimCompletenessDesc;

  /// No description provided for @scoreDimCompletenessExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Answered both questions clearly — great.\"'**
  String get scoreDimCompletenessExample;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP earned'**
  String get xpEarned;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreak;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get thisWeek;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @bestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'BEST'**
  String get bestStreakLabel;

  /// No description provided for @noJourneyYet.
  ///
  /// In en, this message translates to:
  /// **'No journey yet'**
  String get noJourneyYet;

  /// No description provided for @noJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete onboarding to get your personalised path.'**
  String get noJourneySubtitle;

  /// No description provided for @journeyComplete.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end of your journey'**
  String get journeyComplete;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {number} · {topic}'**
  String chapterLabel(int number, String topic);

  /// No description provided for @lessonLabel.
  ///
  /// In en, this message translates to:
  /// **'LESSON {number}'**
  String lessonLabel(int number);

  /// No description provided for @lessonNextUpLabel.
  ///
  /// In en, this message translates to:
  /// **'LESSON {number} · NEXT UP'**
  String lessonNextUpLabel(int number);

  /// No description provided for @completedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total}'**
  String completedOfTotal(int completed, int total);

  /// No description provided for @streakDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String streakDaysCount(int count);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(int count);

  /// No description provided for @xpPoints.
  ///
  /// In en, this message translates to:
  /// **'{count} XP'**
  String xpPoints(int count);
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
      <String>['en', 'pt', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
