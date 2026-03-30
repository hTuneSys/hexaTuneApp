import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'hexaTune'**
  String get app;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'hexaTune App'**
  String get appName;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @dontHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccountPrefix;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started!'**
  String get signUpSubtitle;

  /// No description provided for @alreadyHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountPrefix;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset code.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get sendResetCode;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get enterOtpCode;

  /// No description provided for @verificationCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to:'**
  String get verificationCodeSentTo;

  /// No description provided for @enterDigitCodeBelow.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code below.'**
  String get enterDigitCodeBelow;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendIn(String time);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code to create a new password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'strong'**
  String get passwordStrengthStrong;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @emailAndPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required'**
  String get emailAndPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get otpRequired;

  /// No description provided for @emailVerifiedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Email verified! Please sign in.'**
  String get emailVerifiedSignIn;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Reset code sent to {email}'**
  String otpSentTo(String email);

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent'**
  String get verificationCodeResent;

  /// No description provided for @accountCreatedVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please verify your email.'**
  String get accountCreatedVerifyEmail;

  /// No description provided for @newAccountViaGoogle.
  ///
  /// In en, this message translates to:
  /// **'New account created via Google'**
  String get newAccountViaGoogle;

  /// No description provided for @newAccountViaApple.
  ///
  /// In en, this message translates to:
  /// **'New account created via Apple'**
  String get newAccountViaApple;

  /// No description provided for @appleSignInNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In is only available on iOS'**
  String get appleSignInNotAvailable;

  /// No description provided for @ambienceBaseForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get ambienceBaseForest;

  /// No description provided for @ambienceBaseOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ambienceBaseOcean;

  /// No description provided for @ambienceBaseRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get ambienceBaseRain;

  /// No description provided for @ambienceTextureFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get ambienceTextureFire;

  /// No description provided for @ambienceTextureGrass.
  ///
  /// In en, this message translates to:
  /// **'Grass'**
  String get ambienceTextureGrass;

  /// No description provided for @ambienceTextureLeaf.
  ///
  /// In en, this message translates to:
  /// **'Leaf'**
  String get ambienceTextureLeaf;

  /// No description provided for @ambienceTextureNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get ambienceTextureNight;

  /// No description provided for @ambienceTextureSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get ambienceTextureSnow;

  /// No description provided for @ambienceTextureSoftWind.
  ///
  /// In en, this message translates to:
  /// **'Soft Wind'**
  String get ambienceTextureSoftWind;

  /// No description provided for @ambienceTextureStrongWind.
  ///
  /// In en, this message translates to:
  /// **'Strong Wind'**
  String get ambienceTextureStrongWind;

  /// No description provided for @ambienceTextureWaterDrop.
  ///
  /// In en, this message translates to:
  /// **'Water Drop'**
  String get ambienceTextureWaterDrop;

  /// No description provided for @ambienceTextureWave.
  ///
  /// In en, this message translates to:
  /// **'Wave'**
  String get ambienceTextureWave;

  /// No description provided for @ambienceEventSeaGull.
  ///
  /// In en, this message translates to:
  /// **'Sea Gull'**
  String get ambienceEventSeaGull;

  /// No description provided for @ambienceEventBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get ambienceEventBird;

  /// No description provided for @ambienceEventBirdWing.
  ///
  /// In en, this message translates to:
  /// **'Bird Wing'**
  String get ambienceEventBirdWing;

  /// No description provided for @ambienceEventBush.
  ///
  /// In en, this message translates to:
  /// **'Bush'**
  String get ambienceEventBush;

  /// No description provided for @ambienceEventCrumble.
  ///
  /// In en, this message translates to:
  /// **'Crumble'**
  String get ambienceEventCrumble;

  /// No description provided for @ambienceEventFrog.
  ///
  /// In en, this message translates to:
  /// **'Frog'**
  String get ambienceEventFrog;

  /// No description provided for @ambienceEventInsect.
  ///
  /// In en, this message translates to:
  /// **'Insect'**
  String get ambienceEventInsect;

  /// No description provided for @ambienceEventOwl.
  ///
  /// In en, this message translates to:
  /// **'Owl'**
  String get ambienceEventOwl;

  /// No description provided for @ambienceEventStone.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get ambienceEventStone;

  /// No description provided for @ambienceEventThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunder'**
  String get ambienceEventThunder;

  /// No description provided for @ambienceEventTwig.
  ///
  /// In en, this message translates to:
  /// **'Twig'**
  String get ambienceEventTwig;

  /// No description provided for @ambienceEventWaterDrop.
  ///
  /// In en, this message translates to:
  /// **'Water Drop'**
  String get ambienceEventWaterDrop;

  /// No description provided for @ambienceEventWaterSplash.
  ///
  /// In en, this message translates to:
  /// **'Water Splash'**
  String get ambienceEventWaterSplash;

  /// No description provided for @ambienceEventWoodCrack.
  ///
  /// In en, this message translates to:
  /// **'Wood Crack'**
  String get ambienceEventWoodCrack;

  /// No description provided for @ambienceEventWoodpecker.
  ///
  /// In en, this message translates to:
  /// **'Woodpecker'**
  String get ambienceEventWoodpecker;

  /// No description provided for @dspPageTitle.
  ///
  /// In en, this message translates to:
  /// **'DSP Audio Engine'**
  String get dspPageTitle;

  /// No description provided for @dspSoundLayers.
  ///
  /// In en, this message translates to:
  /// **'Sound Layers'**
  String get dspSoundLayers;

  /// No description provided for @dspGainControls.
  ///
  /// In en, this message translates to:
  /// **'Gain Controls'**
  String get dspGainControls;

  /// No description provided for @dspBinauralConfig.
  ///
  /// In en, this message translates to:
  /// **'Binaural Configuration'**
  String get dspBinauralConfig;

  /// No description provided for @dspCycleSteps.
  ///
  /// In en, this message translates to:
  /// **'Frequency Cycle Steps'**
  String get dspCycleSteps;

  /// No description provided for @dspSectionBase.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get dspSectionBase;

  /// No description provided for @dspSectionTexture.
  ///
  /// In en, this message translates to:
  /// **'Texture'**
  String get dspSectionTexture;

  /// No description provided for @dspSectionEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get dspSectionEvents;

  /// No description provided for @dspSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max}'**
  String dspSelectedCount(int count, int max);

  /// No description provided for @dspNoSelection.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get dspNoSelection;

  /// No description provided for @dspHarmonize.
  ///
  /// In en, this message translates to:
  /// **'HARMONIZE'**
  String get dspHarmonize;

  /// No description provided for @dspStop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get dspStop;

  /// No description provided for @dspGraceful.
  ///
  /// In en, this message translates to:
  /// **'GRACEFUL'**
  String get dspGraceful;

  /// No description provided for @dspLoading.
  ///
  /// In en, this message translates to:
  /// **'LOADING...'**
  String get dspLoading;

  /// No description provided for @dspFinishing.
  ///
  /// In en, this message translates to:
  /// **'FINISHING...'**
  String get dspFinishing;

  /// No description provided for @dspHarmonizing.
  ///
  /// In en, this message translates to:
  /// **'Harmonizing...'**
  String get dspHarmonizing;

  /// No description provided for @dspStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get dspStopped;

  /// No description provided for @dspGracefullyStopped.
  ///
  /// In en, this message translates to:
  /// **'Gracefully stopped'**
  String get dspGracefullyStopped;

  /// No description provided for @dspFinishingCycle.
  ///
  /// In en, this message translates to:
  /// **'Finishing cycle...'**
  String get dspFinishingCycle;

  /// No description provided for @dspCarrierFrequency.
  ///
  /// In en, this message translates to:
  /// **'Carrier Frequency (Hz)'**
  String get dspCarrierFrequency;

  /// No description provided for @dspBinauralMode.
  ///
  /// In en, this message translates to:
  /// **'Binaural Mode'**
  String get dspBinauralMode;

  /// No description provided for @dspBinauralStereo.
  ///
  /// In en, this message translates to:
  /// **'Stereo binaural beats'**
  String get dspBinauralStereo;

  /// No description provided for @dspBinauralMono.
  ///
  /// In en, this message translates to:
  /// **'AM mono pulsing'**
  String get dspBinauralMono;

  /// No description provided for @dspDeltaHz.
  ///
  /// In en, this message translates to:
  /// **'Delta Hz'**
  String get dspDeltaHz;

  /// No description provided for @dspDurationS.
  ///
  /// In en, this message translates to:
  /// **'Duration s'**
  String get dspDurationS;

  /// No description provided for @dspAddStep.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get dspAddStep;

  /// No description provided for @dspBaseLoaded.
  ///
  /// In en, this message translates to:
  /// **'Base loaded: {name}'**
  String dspBaseLoaded(String name);

  /// No description provided for @dspTextureLoaded.
  ///
  /// In en, this message translates to:
  /// **'Texture {index} loaded: {name}'**
  String dspTextureLoaded(int index, String name);

  /// No description provided for @dspEventLoaded.
  ///
  /// In en, this message translates to:
  /// **'Event {index} loaded: {name}'**
  String dspEventLoaded(int index, String name);

  /// No description provided for @dspSelectBaseFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a Base layer first'**
  String get dspSelectBaseFirst;

  /// No description provided for @dspLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed (rc={code})'**
  String dspLoadFailed(int code);

  /// No description provided for @dspAmbienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Ambience Presets'**
  String get dspAmbienceTitle;

  /// No description provided for @dspAmbienceCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Ambience'**
  String get dspAmbienceCreate;

  /// No description provided for @dspAmbienceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Ambience'**
  String get dspAmbienceEdit;

  /// No description provided for @dspAmbienceSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dspAmbienceSave;

  /// No description provided for @dspAmbienceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get dspAmbienceUpdate;

  /// No description provided for @dspAmbienceName.
  ///
  /// In en, this message translates to:
  /// **'Ambience Name'**
  String get dspAmbienceName;

  /// No description provided for @dspAmbienceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ambiences yet'**
  String get dspAmbienceEmpty;

  /// No description provided for @dspAmbienceEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first ambience'**
  String get dspAmbienceEmptyHint;

  /// No description provided for @dspAmbienceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Ambience'**
  String get dspAmbienceDeleteTitle;

  /// No description provided for @dspAmbienceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String dspAmbienceDeleteConfirm(String name);

  /// No description provided for @dspAmbienceDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dspAmbienceDelete;

  /// No description provided for @dspAmbienceCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dspAmbienceCancel;

  /// No description provided for @dspAmbienceNoBase.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get dspAmbienceNoBase;

  /// No description provided for @dspAmbienceSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get dspAmbienceSummary;

  /// No description provided for @dspAmbienceSelectAmbience.
  ///
  /// In en, this message translates to:
  /// **'Select Ambience'**
  String get dspAmbienceSelectAmbience;

  /// No description provided for @dspAmbienceNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'No ambience selected'**
  String get dspAmbienceNoneSelected;

  /// No description provided for @dspAmbienceLoaded.
  ///
  /// In en, this message translates to:
  /// **'Ambience loaded: {name}'**
  String dspAmbienceLoaded(String name);

  /// No description provided for @dspAmbienceManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get dspAmbienceManage;

  /// No description provided for @ambienceManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Ambience Management'**
  String get ambienceManagementTitle;

  /// No description provided for @ambienceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Ambience'**
  String get ambienceCreateTitle;

  /// No description provided for @ambienceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Ambience'**
  String get ambienceEditTitle;

  /// No description provided for @ambienceViewTitle.
  ///
  /// In en, this message translates to:
  /// **'View Ambience'**
  String get ambienceViewTitle;

  /// No description provided for @ambienceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No ambience yet.'**
  String get ambienceEmptyTitle;

  /// No description provided for @ambienceEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Press the + button to add your first item.'**
  String get ambienceEmptySubtitle;

  /// No description provided for @ambienceDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Ambience'**
  String get ambienceDeleteConfirmTitle;

  /// No description provided for @ambienceDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String ambienceDeleteConfirmMessage(String name);

  /// No description provided for @ambienceSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ambienceSortByName;

  /// No description provided for @ambienceSortByNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get ambienceSortByNewest;

  /// No description provided for @ambienceSortByOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get ambienceSortByOldest;

  /// No description provided for @ambienceSoundLayers.
  ///
  /// In en, this message translates to:
  /// **'Sound Layers'**
  String get ambienceSoundLayers;

  /// No description provided for @ambienceSoundSettings.
  ///
  /// In en, this message translates to:
  /// **'Sound Settings'**
  String get ambienceSoundSettings;

  /// No description provided for @ambienceMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get ambienceMaster;

  /// No description provided for @ambienceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ambienceNameLabel;

  /// No description provided for @ambienceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter ambience name'**
  String get ambienceNameHint;

  /// No description provided for @ambienceNoBase.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get ambienceNoBase;

  /// No description provided for @ambienceCreated.
  ///
  /// In en, this message translates to:
  /// **'Ambience created successfully.'**
  String get ambienceCreated;

  /// No description provided for @ambienceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Ambience updated successfully.'**
  String get ambienceUpdated;

  /// No description provided for @ambienceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Ambience deleted.'**
  String get ambienceDeleted;

  /// No description provided for @ambienceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get ambienceNameRequired;

  /// No description provided for @ambienceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search ambiences...'**
  String get ambienceSearchHint;

  /// No description provided for @ambienceSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get ambienceSortTitle;

  /// No description provided for @ambienceFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get ambienceFilterTitle;

  /// No description provided for @ambienceFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ambienceFilterAll;

  /// No description provided for @ambienceViewMenuItem.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get ambienceViewMenuItem;

  /// No description provided for @ambienceEditMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get ambienceEditMenuItem;

  /// No description provided for @ambienceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ambience not found.'**
  String get ambienceNotFound;

  /// No description provided for @hexagenTitle.
  ///
  /// In en, this message translates to:
  /// **'hexaGen Device'**
  String get hexagenTitle;

  /// No description provided for @hexagenRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get hexagenRefresh;

  /// No description provided for @hexagenConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get hexagenConnection;

  /// No description provided for @hexagenStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get hexagenStatusReady;

  /// No description provided for @hexagenStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get hexagenStatusConnected;

  /// No description provided for @hexagenStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get hexagenStatusDisconnected;

  /// No description provided for @hexagenDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get hexagenDevice;

  /// No description provided for @hexagenDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get hexagenDeviceId;

  /// No description provided for @hexagenFirmware.
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get hexagenFirmware;

  /// No description provided for @hexagenInitialized.
  ///
  /// In en, this message translates to:
  /// **'Initialized'**
  String get hexagenInitialized;

  /// No description provided for @hexagenYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get hexagenYes;

  /// No description provided for @hexagenNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get hexagenNo;

  /// No description provided for @hexagenNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hexagenNone;

  /// No description provided for @hexagenInit.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get hexagenInit;

  /// No description provided for @hexagenReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get hexagenReset;

  /// No description provided for @hexagenInitSuccess.
  ///
  /// In en, this message translates to:
  /// **'HexaGen service initialized'**
  String get hexagenInitSuccess;

  /// No description provided for @hexagenRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Device scan completed'**
  String get hexagenRefreshed;

  /// No description provided for @hexagenResetSent.
  ///
  /// In en, this message translates to:
  /// **'Reset command sent'**
  String get hexagenResetSent;

  /// No description provided for @hexagenRgb.
  ///
  /// In en, this message translates to:
  /// **'RGB LED'**
  String get hexagenRgb;

  /// No description provided for @hexagenRed.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get hexagenRed;

  /// No description provided for @hexagenGreen.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get hexagenGreen;

  /// No description provided for @hexagenBlue.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get hexagenBlue;

  /// No description provided for @hexagenSendRgb.
  ///
  /// In en, this message translates to:
  /// **'Send RGB'**
  String get hexagenSendRgb;

  /// No description provided for @hexagenRgbSent.
  ///
  /// In en, this message translates to:
  /// **'RGB command sent'**
  String get hexagenRgbSent;

  /// No description provided for @hexagenFreqSweep.
  ///
  /// In en, this message translates to:
  /// **'Frequency Sweep'**
  String get hexagenFreqSweep;

  /// No description provided for @hexagenFreqEmpty.
  ///
  /// In en, this message translates to:
  /// **'No frequencies added'**
  String get hexagenFreqEmpty;

  /// No description provided for @hexagenFreqHz.
  ///
  /// In en, this message translates to:
  /// **'Freq (Hz)'**
  String get hexagenFreqHz;

  /// No description provided for @hexagenDurationMs.
  ///
  /// In en, this message translates to:
  /// **'Duration (ms)'**
  String get hexagenDurationMs;

  /// No description provided for @hexagenFreqRun.
  ///
  /// In en, this message translates to:
  /// **'Run ({count})'**
  String hexagenFreqRun(int count);

  /// No description provided for @hexagenFreqStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get hexagenFreqStop;

  /// No description provided for @hexagenFreqProgress.
  ///
  /// In en, this message translates to:
  /// **'Freq {current}/{total}: {freq} Hz'**
  String hexagenFreqProgress(int current, int total, int freq);

  /// No description provided for @hexagenFreqFailed.
  ///
  /// In en, this message translates to:
  /// **'Freq {freq} Hz failed: {status}'**
  String hexagenFreqFailed(int freq, String status);

  /// No description provided for @hexagenFreqListDone.
  ///
  /// In en, this message translates to:
  /// **'Frequency list completed'**
  String get hexagenFreqListDone;

  /// No description provided for @hexagenOpId.
  ///
  /// In en, this message translates to:
  /// **'Operation ID'**
  String get hexagenOpId;

  /// No description provided for @hexagenOpCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get hexagenOpCurrentStatus;

  /// No description provided for @hexagenOpStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get hexagenOpStep;

  /// No description provided for @hexagenOpRunning.
  ///
  /// In en, this message translates to:
  /// **'Running...'**
  String get hexagenOpRunning;

  /// No description provided for @hexagenOpPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing operation...'**
  String get hexagenOpPreparing;

  /// No description provided for @hexagenOpPrepareFailed.
  ///
  /// In en, this message translates to:
  /// **'Prepare failed: {status}'**
  String hexagenOpPrepareFailed(String status);

  /// No description provided for @hexagenOpGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get hexagenOpGenerating;

  /// No description provided for @hexagenOpStatus.
  ///
  /// In en, this message translates to:
  /// **'Operation: {status} (step {step})'**
  String hexagenOpStatus(String status, int step);

  /// No description provided for @harmonizerTitle.
  ///
  /// In en, this message translates to:
  /// **'Harmonizer'**
  String get harmonizerTitle;

  /// No description provided for @harmonizerSelectFormula.
  ///
  /// In en, this message translates to:
  /// **'Select a formula'**
  String get harmonizerSelectFormula;

  /// No description provided for @harmonizerNoFormulas.
  ///
  /// In en, this message translates to:
  /// **'No formulas available'**
  String get harmonizerNoFormulas;

  /// No description provided for @harmonizerFormulaLabel.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get harmonizerFormulaLabel;

  /// No description provided for @harmonizerTypeMonaural.
  ///
  /// In en, this message translates to:
  /// **'Monaural'**
  String get harmonizerTypeMonaural;

  /// No description provided for @harmonizerTypeBinaural.
  ///
  /// In en, this message translates to:
  /// **'Binaural'**
  String get harmonizerTypeBinaural;

  /// No description provided for @harmonizerTypeMagnetic.
  ///
  /// In en, this message translates to:
  /// **'Magnetic'**
  String get harmonizerTypeMagnetic;

  /// No description provided for @harmonizerTypePhotonic.
  ///
  /// In en, this message translates to:
  /// **'Photonic'**
  String get harmonizerTypePhotonic;

  /// No description provided for @harmonizerTypeQuantal.
  ///
  /// In en, this message translates to:
  /// **'Quantal'**
  String get harmonizerTypeQuantal;

  /// No description provided for @harmonizerComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon'**
  String get harmonizerComingSoon;

  /// No description provided for @harmonizerHeadsetRequired.
  ///
  /// In en, this message translates to:
  /// **'Please connect headphones for binaural mode'**
  String get harmonizerHeadsetRequired;

  /// No description provided for @harmonizerHexagenRequired.
  ///
  /// In en, this message translates to:
  /// **'Please connect a hexaGen device for magnetic mode'**
  String get harmonizerHexagenRequired;

  /// No description provided for @harmonizerSelectAmbience.
  ///
  /// In en, this message translates to:
  /// **'Select ambience (optional)'**
  String get harmonizerSelectAmbience;

  /// No description provided for @harmonizerNoAmbience.
  ///
  /// In en, this message translates to:
  /// **'No ambience'**
  String get harmonizerNoAmbience;

  /// No description provided for @harmonizerHarmonize.
  ///
  /// In en, this message translates to:
  /// **'Harmonize'**
  String get harmonizerHarmonize;

  /// No description provided for @harmonizerStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get harmonizerStop;

  /// No description provided for @harmonizerPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get harmonizerPreparing;

  /// No description provided for @harmonizerHarmonizing.
  ///
  /// In en, this message translates to:
  /// **'Harmonizing'**
  String get harmonizerHarmonizing;

  /// No description provided for @harmonizerStopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping...'**
  String get harmonizerStopping;

  /// No description provided for @harmonizerError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String harmonizerError(String message);

  /// No description provided for @harmonizerCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle {cycle}'**
  String harmonizerCycle(int cycle);

  /// No description provided for @harmonizerTotalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get harmonizerTotalDuration;

  /// No description provided for @harmonizerRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get harmonizerRemaining;

  /// No description provided for @harmonizerCycleRemaining.
  ///
  /// In en, this message translates to:
  /// **'Cycle Remaining'**
  String get harmonizerCycleRemaining;

  /// No description provided for @harmonizerStep.
  ///
  /// In en, this message translates to:
  /// **'Step {index}: {value} Hz — {duration}s'**
  String harmonizerStep(int index, int value, String duration);

  /// No description provided for @harmonizerStepOneshot.
  ///
  /// In en, this message translates to:
  /// **'one-shot'**
  String get harmonizerStepOneshot;

  /// No description provided for @harmonizerGracefulStopHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop after current cycle'**
  String get harmonizerGracefulStopHint;

  /// No description provided for @harmonizerImmediateStopHint.
  ///
  /// In en, this message translates to:
  /// **'Hold 3s to stop immediately'**
  String get harmonizerImmediateStopHint;

  /// No description provided for @harmonizerGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating sequence...'**
  String get harmonizerGenerating;

  /// No description provided for @harmonizerNoSequence.
  ///
  /// In en, this message translates to:
  /// **'No formula selected'**
  String get harmonizerNoSequence;

  /// No description provided for @harmonizerSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Please select a source from formula or inventory pages'**
  String get harmonizerSelectSource;

  /// No description provided for @harmonizerRepeatOnce.
  ///
  /// In en, this message translates to:
  /// **'x1'**
  String get harmonizerRepeatOnce;

  /// No description provided for @harmonizerRepeatThrice.
  ///
  /// In en, this message translates to:
  /// **'x3'**
  String get harmonizerRepeatThrice;

  /// No description provided for @harmonizerRepeatTen.
  ///
  /// In en, this message translates to:
  /// **'x10'**
  String get harmonizerRepeatTen;

  /// No description provided for @harmonizerAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'Harmonization is already in progress'**
  String get harmonizerAlreadyActive;

  /// No description provided for @harmonizeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Harmonization completed successfully'**
  String get harmonizeCompleted;

  /// No description provided for @harmonizeDeviceTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device did not respond in time. The session was forcefully reset.'**
  String get harmonizeDeviceTimeout;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// No description provided for @categoryCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get categoryCreate;

  /// No description provided for @categoryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoryEdit;

  /// No description provided for @categoryView.
  ///
  /// In en, this message translates to:
  /// **'View Category'**
  String get categoryView;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get categoryNameHint;

  /// No description provided for @categoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get categoryDescription;

  /// No description provided for @categoryDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category description'**
  String get categoryDescriptionHint;

  /// No description provided for @categoryLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get categoryLabels;

  /// No description provided for @categoryAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get categoryAddLabel;

  /// No description provided for @categoryInventoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Inventory'**
  String categoryInventoryCount(int count);

  /// No description provided for @categorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get categorySearchHint;

  /// No description provided for @categorySortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get categorySortTitle;

  /// No description provided for @categoryFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get categoryFilterTitle;

  /// No description provided for @categorySortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get categorySortDefault;

  /// No description provided for @categorySortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A→Z)'**
  String get categorySortNameAsc;

  /// No description provided for @categorySortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z→A)'**
  String get categorySortNameDesc;

  /// No description provided for @categorySortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get categorySortNewest;

  /// No description provided for @categorySortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get categorySortOldest;

  /// No description provided for @categoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No categories yet.'**
  String get categoryEmptyTitle;

  /// No description provided for @categoryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Press the + button to add your first item.'**
  String get categoryEmptyHint;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get categoryCreated;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryUpdated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get categoryDeleted;

  /// No description provided for @categoryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String categoryDeleteConfirm(String name);

  /// No description provided for @categoryNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels'**
  String get categoryNoLabels;

  /// No description provided for @categoryEdit_menuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get categoryEdit_menuItem;

  /// No description provided for @categoryView_menuItem.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get categoryView_menuItem;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @inventoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management'**
  String get inventoryManagement;

  /// No description provided for @inventoryCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Inventory'**
  String get inventoryCreate;

  /// No description provided for @inventoryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Inventory'**
  String get inventoryEdit;

  /// No description provided for @inventoryView.
  ///
  /// In en, this message translates to:
  /// **'View Inventory'**
  String get inventoryView;

  /// No description provided for @inventoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryName;

  /// No description provided for @inventoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter inventory name'**
  String get inventoryNameHint;

  /// No description provided for @inventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get inventoryDescription;

  /// No description provided for @inventoryDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a short description'**
  String get inventoryDescriptionHint;

  /// No description provided for @inventoryCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get inventoryCategory;

  /// No description provided for @inventoryCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get inventoryCategoryHint;

  /// No description provided for @inventoryLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get inventoryLabels;

  /// No description provided for @inventoryAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add labels'**
  String get inventoryAddLabel;

  /// No description provided for @inventoryAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get inventoryAddImage;

  /// No description provided for @inventorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search inventories...'**
  String get inventorySearchHint;

  /// No description provided for @inventorySortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get inventorySortTitle;

  /// No description provided for @inventoryFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get inventoryFilterTitle;

  /// No description provided for @inventorySortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get inventorySortDefault;

  /// No description provided for @inventorySortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A→Z)'**
  String get inventorySortNameAsc;

  /// No description provided for @inventorySortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z→A)'**
  String get inventorySortNameDesc;

  /// No description provided for @inventorySortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get inventorySortNewest;

  /// No description provided for @inventorySortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get inventorySortOldest;

  /// No description provided for @inventoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is empty.'**
  String get inventoryEmptyTitle;

  /// No description provided for @inventoryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Press the + button to add your first item.'**
  String get inventoryEmptyHint;

  /// No description provided for @inventoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Inventory created'**
  String get inventoryCreated;

  /// No description provided for @inventoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Inventory updated'**
  String get inventoryUpdated;

  /// No description provided for @inventoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Inventory deleted'**
  String get inventoryDeleted;

  /// No description provided for @inventoryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String inventoryDeleteConfirm(String name);

  /// No description provided for @inventoryNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels'**
  String get inventoryNoLabels;

  /// No description provided for @inventoryEdit_menuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get inventoryEdit_menuItem;

  /// No description provided for @inventoryView_menuItem.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get inventoryView_menuItem;

  /// No description provided for @inventoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Inventory'**
  String inventoryCount(int count);

  /// No description provided for @inventorySelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected Inventories'**
  String get inventorySelectedTitle;

  /// No description provided for @inventoryCategoryAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get inventoryCategoryAddNew;

  /// No description provided for @inventoryCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get inventoryCategoryRequired;

  /// No description provided for @inventoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get inventoryNameRequired;

  /// No description provided for @inventoryImageCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get inventoryImageCamera;

  /// No description provided for @inventoryImageGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get inventoryImageGallery;

  /// No description provided for @formulaManagement.
  ///
  /// In en, this message translates to:
  /// **'Formula Management'**
  String get formulaManagement;

  /// No description provided for @formulaCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Formula'**
  String get formulaCreate;

  /// No description provided for @formulaEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Formula'**
  String get formulaEdit;

  /// No description provided for @formulaView.
  ///
  /// In en, this message translates to:
  /// **'View Formula'**
  String get formulaView;

  /// No description provided for @formulaName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get formulaName;

  /// No description provided for @formulaNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter formula name'**
  String get formulaNameHint;

  /// No description provided for @formulaDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get formulaDescription;

  /// No description provided for @formulaDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a short description'**
  String get formulaDescriptionHint;

  /// No description provided for @formulaLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get formulaLabels;

  /// No description provided for @formulaAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add labels'**
  String get formulaAddLabel;

  /// No description provided for @formulaAddInventory.
  ///
  /// In en, this message translates to:
  /// **'Add Inventory'**
  String get formulaAddInventory;

  /// No description provided for @formulaSearchInventory.
  ///
  /// In en, this message translates to:
  /// **'Search inventory to add'**
  String get formulaSearchInventory;

  /// No description provided for @formulaItemCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get formulaItemCount;

  /// No description provided for @formulaInventoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Inventory'**
  String formulaInventoryCount(int count);

  /// No description provided for @formulaSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search formulas...'**
  String get formulaSearchHint;

  /// No description provided for @formulaSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get formulaSortTitle;

  /// No description provided for @formulaFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get formulaFilterTitle;

  /// No description provided for @formulaSortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get formulaSortDefault;

  /// No description provided for @formulaSortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A→Z)'**
  String get formulaSortNameAsc;

  /// No description provided for @formulaSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z→A)'**
  String get formulaSortNameDesc;

  /// No description provided for @formulaSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get formulaSortNewest;

  /// No description provided for @formulaSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get formulaSortOldest;

  /// No description provided for @formulaEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No formulas yet.'**
  String get formulaEmptyTitle;

  /// No description provided for @formulaEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Press the + button to add your first item.'**
  String get formulaEmptyHint;

  /// No description provided for @formulaCreated.
  ///
  /// In en, this message translates to:
  /// **'Formula created'**
  String get formulaCreated;

  /// No description provided for @formulaUpdated.
  ///
  /// In en, this message translates to:
  /// **'Formula saved'**
  String get formulaUpdated;

  /// No description provided for @formulaDeleted.
  ///
  /// In en, this message translates to:
  /// **'Formula deleted'**
  String get formulaDeleted;

  /// No description provided for @formulaDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String formulaDeleteConfirm(String name);

  /// No description provided for @formulaNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels'**
  String get formulaNoLabels;

  /// No description provided for @formulaEditMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get formulaEditMenuItem;

  /// No description provided for @formulaViewMenuItem.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get formulaViewMenuItem;

  /// No description provided for @formulaNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get formulaNameRequired;

  /// No description provided for @formulaAddedInventory.
  ///
  /// In en, this message translates to:
  /// **'Added inventory'**
  String get formulaAddedInventory;

  /// No description provided for @formulaItemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed'**
  String get formulaItemRemoved;

  /// No description provided for @formulaItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get formulaItemAdded;

  /// No description provided for @formulaQuantityMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum total quantity reached ({max})'**
  String formulaQuantityMax(int max);

  /// No description provided for @formulaInventoryDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This inventory is already added'**
  String get formulaInventoryDuplicate;

  /// No description provided for @formulaUniqueItemLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of unique items reached ({max})'**
  String formulaUniqueItemLimit(int max);

  /// No description provided for @inventorySelectionLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of inventories reached ({max})'**
  String inventorySelectionLimit(int max);

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this action.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorNotFound;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your input.'**
  String get errorBadRequest;

  /// No description provided for @errorValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please check the form and try again.'**
  String get errorValidationFailed;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'This resource already exists or conflicts with another.'**
  String get errorConflict;

  /// No description provided for @errorInternalError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get errorInternalError;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorAccountLocked.
  ///
  /// In en, this message translates to:
  /// **'Your account has been locked.'**
  String get errorAccountLocked;

  /// No description provided for @errorAccountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Your account has been suspended.'**
  String get errorAccountSuspended;

  /// No description provided for @errorEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address.'**
  String get errorEmailNotVerified;

  /// No description provided for @errorEmailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailAlreadyExists;

  /// No description provided for @errorEmailAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'This email is already verified.'**
  String get errorEmailAlreadyVerified;

  /// No description provided for @errorProviderAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This provider is already linked to your account.'**
  String get errorProviderAlreadyLinked;

  /// No description provided for @errorPasswordResetInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired reset code.'**
  String get errorPasswordResetInvalid;

  /// No description provided for @errorPasswordResetMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Maximum reset attempts exceeded. Please request a new code.'**
  String get errorPasswordResetMaxAttempts;

  /// No description provided for @errorVerificationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired verification code.'**
  String get errorVerificationInvalid;

  /// No description provided for @errorVerificationMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Maximum verification attempts exceeded. Please request a new code.'**
  String get errorVerificationMaxAttempts;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please slow down.'**
  String get errorRateLimited;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired. Tap resend to get a new code.'**
  String get otpExpired;

  /// No description provided for @otpExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {time}'**
  String otpExpiresIn(String time);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLinkedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get settingsLinkedAccounts;

  /// No description provided for @settingsLinkedAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your authentication providers'**
  String get settingsLinkedAccountsSubtitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account info and profile settings'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get settingsWallet;

  /// No description provided for @settingsWalletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Balance and transactions'**
  String get settingsWalletSubtitle;

  /// No description provided for @settingsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get settingsSessions;

  /// No description provided for @settingsSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage active sessions'**
  String get settingsSessionsSubtitle;

  /// No description provided for @settingsDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get settingsDevices;

  /// No description provided for @settingsDevicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage registered devices'**
  String get settingsDevicesSubtitle;

  /// No description provided for @settingsLogMonitor.
  ///
  /// In en, this message translates to:
  /// **'Log Monitor'**
  String get settingsLogMonitor;

  /// No description provided for @settingsLogMonitorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time debug logs and diagnostics'**
  String get settingsLogMonitorSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSection;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @profileUpdateSection.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profileUpdateSection;

  /// No description provided for @profileAccountId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get profileAccountId;

  /// No description provided for @profileAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profileAccountStatus;

  /// No description provided for @profileAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get profileAccountCreated;

  /// No description provided for @profileAccountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get profileAccountUpdated;

  /// No description provided for @profileAccountLockedAt.
  ///
  /// In en, this message translates to:
  /// **'Locked At'**
  String get profileAccountLockedAt;

  /// No description provided for @profileAccountSuspendedAt.
  ///
  /// In en, this message translates to:
  /// **'Suspended At'**
  String get profileAccountSuspendedAt;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileDisplayName;

  /// No description provided for @profileAvatarUrl.
  ///
  /// In en, this message translates to:
  /// **'Avatar URL'**
  String get profileAvatarUrl;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get profileSave;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileNoData.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get profileNoData;

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetry;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletBalanceSection.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalanceSection;

  /// No description provided for @walletGetBalance.
  ///
  /// In en, this message translates to:
  /// **'Get Balance'**
  String get walletGetBalance;

  /// No description provided for @walletTransactionsSection.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactionsSection;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get walletNoTransactions;

  /// No description provided for @walletTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String walletTransactionCount(int count);

  /// No description provided for @walletHasMore.
  ///
  /// In en, this message translates to:
  /// **'Has more: {value}'**
  String walletHasMore(String value);

  /// No description provided for @walletBalanceCoins.
  ///
  /// In en, this message translates to:
  /// **'{count} coins'**
  String walletBalanceCoins(int count);

  /// No description provided for @walletPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get walletPurchased;

  /// No description provided for @walletSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get walletSpent;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalance;

  /// No description provided for @walletBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after: {count}'**
  String walletBalanceAfter(int count);

  /// No description provided for @walletStoreSection.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get walletStoreSection;

  /// No description provided for @walletLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Load Products'**
  String get walletLoadProducts;

  /// No description provided for @walletNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get walletNoProducts;

  /// No description provided for @walletPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get walletPurchase;

  /// No description provided for @walletPurchaseInitiated.
  ///
  /// In en, this message translates to:
  /// **'Purchase initiated'**
  String get walletPurchaseInitiated;

  /// No description provided for @walletLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get walletLoadMore;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @sessionsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sessionsSearch;

  /// No description provided for @sessionsSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sessionsSort;

  /// No description provided for @sessionsSortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sessionsSortDefault;

  /// No description provided for @sessionsSortRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get sessionsSortRecentActivity;

  /// No description provided for @sessionsSortOldestActivity.
  ///
  /// In en, this message translates to:
  /// **'Oldest activity'**
  String get sessionsSortOldestActivity;

  /// No description provided for @sessionsSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sessionsSortNewest;

  /// No description provided for @sessionsSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sessionsSortOldest;

  /// No description provided for @sessionsRevokeOthers.
  ///
  /// In en, this message translates to:
  /// **'Revoke Others'**
  String get sessionsRevokeOthers;

  /// No description provided for @sessionsRevokeAll.
  ///
  /// In en, this message translates to:
  /// **'Revoke All'**
  String get sessionsRevokeAll;

  /// No description provided for @sessionsRevokeOthersTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke Other Sessions'**
  String get sessionsRevokeOthersTitle;

  /// No description provided for @sessionsRevokeOthersMessage.
  ///
  /// In en, this message translates to:
  /// **'This will terminate all sessions except the current one.'**
  String get sessionsRevokeOthersMessage;

  /// No description provided for @sessionsRevokeAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke All Sessions'**
  String get sessionsRevokeAllTitle;

  /// No description provided for @sessionsRevokeAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This will terminate ALL sessions including the current one. You will be logged out.'**
  String get sessionsRevokeAllMessage;

  /// No description provided for @sessionsRevokedCount.
  ///
  /// In en, this message translates to:
  /// **'Revoked {count} sessions'**
  String sessionsRevokedCount(int count);

  /// No description provided for @sessionsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sessionsCancel;

  /// No description provided for @sessionsRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get sessionsRevoke;

  /// No description provided for @sessionsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get sessionsLoadMore;

  /// No description provided for @sessionsDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get sessionsDevice;

  /// No description provided for @sessionsCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sessionsCreated;

  /// No description provided for @sessionsExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get sessionsExpires;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// No description provided for @devicesTrusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get devicesTrusted;

  /// No description provided for @devicesNotTrusted.
  ///
  /// In en, this message translates to:
  /// **'Not trusted'**
  String get devicesNotTrusted;

  /// No description provided for @devicesUserAgent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get devicesUserAgent;

  /// No description provided for @devicesIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get devicesIpAddress;

  /// No description provided for @devicesFirstSeen.
  ///
  /// In en, this message translates to:
  /// **'First seen'**
  String get devicesFirstSeen;

  /// No description provided for @devicesLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get devicesLastSeen;

  /// No description provided for @devicesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get devicesDelete;

  /// No description provided for @devicesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this device?'**
  String get devicesDeleteConfirm;

  /// No description provided for @devicesDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get devicesDeleteCancel;

  /// No description provided for @devicesDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get devicesDeleteConfirmAction;

  /// No description provided for @devicesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Device deleted'**
  String get devicesDeleted;

  /// No description provided for @devicesNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No registered devices'**
  String get devicesNoDevices;

  /// No description provided for @devicesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get devicesRetry;

  /// No description provided for @providerTitle.
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get providerTitle;

  /// No description provided for @providerEmailSection.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get providerEmailSection;

  /// No description provided for @providerGoogleSection.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get providerGoogleSection;

  /// No description provided for @providerAppleSection.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get providerAppleSection;

  /// No description provided for @providerLinkedAt.
  ///
  /// In en, this message translates to:
  /// **'Linked {date}'**
  String providerLinkedAt(String date);

  /// No description provided for @providerLinkWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Link with Email'**
  String get providerLinkWithEmail;

  /// No description provided for @providerLinkWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link with Google'**
  String get providerLinkWithGoogle;

  /// No description provided for @providerLinkWithApple.
  ///
  /// In en, this message translates to:
  /// **'Link with Apple'**
  String get providerLinkWithApple;

  /// No description provided for @providerUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get providerUnlink;

  /// No description provided for @providerResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get providerResetPassword;

  /// No description provided for @providerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get providerEmailHint;

  /// No description provided for @providerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get providerPasswordHint;

  /// No description provided for @providerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get providerEmailRequired;

  /// No description provided for @providerPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get providerPasswordRequired;

  /// No description provided for @providerEmailLinked.
  ///
  /// In en, this message translates to:
  /// **'Email provider linked'**
  String get providerEmailLinked;

  /// No description provided for @providerGoogleLinked.
  ///
  /// In en, this message translates to:
  /// **'Google account linked'**
  String get providerGoogleLinked;

  /// No description provided for @providerAppleLinked.
  ///
  /// In en, this message translates to:
  /// **'Apple account linked'**
  String get providerAppleLinked;

  /// No description provided for @providerUnlinked.
  ///
  /// In en, this message translates to:
  /// **'Provider unlinked'**
  String get providerUnlinked;

  /// No description provided for @providerUnlinkConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink this provider?'**
  String get providerUnlinkConfirm;

  /// No description provided for @providerUnlinkCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get providerUnlinkCancel;

  /// No description provided for @providerUnlinkConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get providerUnlinkConfirmAction;

  /// No description provided for @providerVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get providerVerifyEmail;

  /// No description provided for @providerVerifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your email'**
  String get providerVerifyEmailSubtitle;

  /// No description provided for @providerResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get providerResetPasswordTitle;

  /// No description provided for @providerResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email and set a new password'**
  String get providerResetPasswordSubtitle;

  /// No description provided for @providerPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get providerPasswordResetSuccess;

  /// No description provided for @providerOAuthCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled'**
  String get providerOAuthCancelled;

  /// No description provided for @providerOAuthNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In is only available on iOS and macOS'**
  String get providerOAuthNotAvailable;

  /// No description provided for @providerNotLinked.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get providerNotLinked;

  /// No description provided for @providerEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get providerEmailVerified;

  /// No description provided for @providerEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get providerEmailNotVerified;

  /// No description provided for @workspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Workspace'**
  String get workspaceTitle;

  /// No description provided for @workspacePinnedFormulas.
  ///
  /// In en, this message translates to:
  /// **'Pinned Formulas'**
  String get workspacePinnedFormulas;

  /// No description provided for @workspacePinnedEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get workspacePinnedEdit;

  /// No description provided for @workspaceQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get workspaceQuickAdd;

  /// No description provided for @workspaceStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get workspaceStats;

  /// No description provided for @workspaceInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get workspaceInventory;

  /// No description provided for @workspaceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get workspaceCategory;

  /// No description provided for @workspaceFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get workspaceFormula;

  /// No description provided for @workspaceAmbience.
  ///
  /// In en, this message translates to:
  /// **'Ambience'**
  String get workspaceAmbience;

  /// No description provided for @workspaceRecentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently Used'**
  String get workspaceRecentlyUsed;

  /// No description provided for @workspaceSearchToPin.
  ///
  /// In en, this message translates to:
  /// **'Search to pin'**
  String get workspaceSearchToPin;

  /// No description provided for @workspaceNoPinnedFormulas.
  ///
  /// In en, this message translates to:
  /// **'No pinned formulas'**
  String get workspaceNoPinnedFormulas;

  /// No description provided for @workspaceNoRecentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'No recent harmonizations'**
  String get workspaceNoRecentlyUsed;

  /// No description provided for @workspaceRepeatInfinite.
  ///
  /// In en, this message translates to:
  /// **'∞'**
  String get workspaceRepeatInfinite;

  /// No description provided for @workspaceRepeatCount.
  ///
  /// In en, this message translates to:
  /// **'x{count}'**
  String workspaceRepeatCount(int count);
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
