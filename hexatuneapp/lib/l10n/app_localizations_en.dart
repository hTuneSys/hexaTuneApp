// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app => 'hexaTune';

  @override
  String get appName => 'hexaTune App';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get newPassword => 'New Password';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get apple => 'Apple';

  @override
  String get google => 'Google';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get dontHaveAccountPrefix => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get signUpSubtitle => 'Sign up to get started!';

  @override
  String get alreadyHaveAccountPrefix => 'Already have an account? ';

  @override
  String get signInLink => 'Sign In';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a reset code.';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get enterOtpCode => 'Enter OTP Code';

  @override
  String get verificationCodeSentTo => 'We have sent a verification code to:';

  @override
  String get enterDigitCodeBelow => 'Please enter the 8-digit code below.';

  @override
  String get verify => 'Verify';

  @override
  String get didntReceiveCode => 'Didn\'t receive the code?';

  @override
  String resendIn(String time) {
    return 'Resend in $time';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get resetYourPassword => 'Reset Your Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter the code to create a new password.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get passwordStrengthWeak => 'weak';

  @override
  String get passwordStrengthFair => 'fair';

  @override
  String get passwordStrengthGood => 'good';

  @override
  String get passwordStrengthStrong => 'strong';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get emailAndPasswordRequired => 'Email and password are required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get otpRequired => 'Please enter the verification code';

  @override
  String get emailVerifiedSignIn => 'Email verified! Please sign in.';

  @override
  String get passwordResetSuccess => 'Password reset successfully!';

  @override
  String otpSentTo(String email) {
    return 'Reset code sent to $email';
  }

  @override
  String get verificationCodeResent => 'Verification code resent';

  @override
  String get accountCreatedVerifyEmail =>
      'Account created! Please verify your email.';

  @override
  String get newAccountViaGoogle => 'New account created via Google';

  @override
  String get newAccountViaApple => 'New account created via Apple';

  @override
  String get appleSignInNotAvailable =>
      'Apple Sign-In is only available on iOS';

  @override
  String get ambienceBaseForest => 'Forest';

  @override
  String get ambienceBaseOcean => 'Ocean';

  @override
  String get ambienceBaseRain => 'Rain';

  @override
  String get ambienceTextureFire => 'Fire';

  @override
  String get ambienceTextureGrass => 'Grass';

  @override
  String get ambienceTextureLeaf => 'Leaf';

  @override
  String get ambienceTextureNight => 'Night';

  @override
  String get ambienceTextureSnow => 'Snow';

  @override
  String get ambienceTextureSoftWind => 'Soft Wind';

  @override
  String get ambienceTextureStrongWind => 'Strong Wind';

  @override
  String get ambienceTextureWaterDrop => 'Water Drop';

  @override
  String get ambienceTextureWave => 'Wave';

  @override
  String get ambienceEventSeaGull => 'Sea Gull';

  @override
  String get ambienceEventBird => 'Bird';

  @override
  String get ambienceEventBirdWing => 'Bird Wing';

  @override
  String get ambienceEventBush => 'Bush';

  @override
  String get ambienceEventCrumble => 'Crumble';

  @override
  String get ambienceEventFrog => 'Frog';

  @override
  String get ambienceEventInsect => 'Insect';

  @override
  String get ambienceEventOwl => 'Owl';

  @override
  String get ambienceEventStone => 'Stone';

  @override
  String get ambienceEventThunder => 'Thunder';

  @override
  String get ambienceEventTwig => 'Twig';

  @override
  String get ambienceEventWaterDrop => 'Water Drop';

  @override
  String get ambienceEventWaterSplash => 'Water Splash';

  @override
  String get ambienceEventWoodCrack => 'Wood Crack';

  @override
  String get ambienceEventWoodpecker => 'Woodpecker';

  @override
  String get dspPageTitle => 'DSP Audio Engine';

  @override
  String get dspSoundLayers => 'Sound Layers';

  @override
  String get dspGainControls => 'Gain Controls';

  @override
  String get dspBinauralConfig => 'Binaural Configuration';

  @override
  String get dspCycleSteps => 'Frequency Cycle Steps';

  @override
  String get dspSectionBase => 'Base';

  @override
  String get dspSectionTexture => 'Texture';

  @override
  String get dspSectionEvents => 'Events';

  @override
  String dspSelectedCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get dspNoSelection => 'Tap to select';

  @override
  String get dspPlay => 'PLAY';

  @override
  String get dspStop => 'STOP';

  @override
  String get dspGraceful => 'GRACEFUL';

  @override
  String get dspLoading => 'LOADING...';

  @override
  String get dspFinishing => 'FINISHING...';

  @override
  String get dspPlaying => 'Playing...';

  @override
  String get dspStopped => 'Stopped';

  @override
  String get dspGracefullyStopped => 'Gracefully stopped';

  @override
  String get dspFinishingCycle => 'Finishing cycle...';

  @override
  String get dspCarrierFrequency => 'Carrier Frequency (Hz)';

  @override
  String get dspBinauralMode => 'Binaural Mode';

  @override
  String get dspBinauralStereo => 'Stereo binaural beats';

  @override
  String get dspBinauralMono => 'AM mono pulsing';

  @override
  String get dspDeltaHz => 'Delta Hz';

  @override
  String get dspDurationS => 'Duration s';

  @override
  String get dspAddStep => 'Add Step';

  @override
  String dspBaseLoaded(String name) {
    return 'Base loaded: $name';
  }

  @override
  String dspTextureLoaded(int index, String name) {
    return 'Texture $index loaded: $name';
  }

  @override
  String dspEventLoaded(int index, String name) {
    return 'Event $index loaded: $name';
  }

  @override
  String get dspSelectBaseFirst => 'Select a Base layer first';

  @override
  String dspLoadFailed(int code) {
    return 'Load failed (rc=$code)';
  }

  @override
  String get dspAmbienceTitle => 'Ambience Presets';

  @override
  String get dspAmbienceCreate => 'Create Ambience';

  @override
  String get dspAmbienceEdit => 'Edit Ambience';

  @override
  String get dspAmbienceSave => 'Save';

  @override
  String get dspAmbienceUpdate => 'Update';

  @override
  String get dspAmbienceName => 'Ambience Name';

  @override
  String get dspAmbienceEmpty => 'No ambiences yet';

  @override
  String get dspAmbienceEmptyHint => 'Tap + to create your first ambience';

  @override
  String get dspAmbienceDeleteTitle => 'Delete Ambience';

  @override
  String dspAmbienceDeleteConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get dspAmbienceDelete => 'Delete';

  @override
  String get dspAmbienceCancel => 'Cancel';

  @override
  String get dspAmbienceNoBase => 'None';

  @override
  String get dspAmbienceSummary => 'Summary';

  @override
  String get dspAmbienceSelectAmbience => 'Select Ambience';

  @override
  String get dspAmbienceNoneSelected => 'No ambience selected';

  @override
  String dspAmbienceLoaded(String name) {
    return 'Ambience loaded: $name';
  }

  @override
  String get dspAmbienceManage => 'Manage';

  @override
  String get hexagenTitle => 'hexaGen Device';

  @override
  String get hexagenRefresh => 'Refresh';

  @override
  String get hexagenConnection => 'Connection';

  @override
  String get hexagenStatusReady => 'Ready';

  @override
  String get hexagenStatusConnected => 'Connected';

  @override
  String get hexagenStatusDisconnected => 'Disconnected';

  @override
  String get hexagenDevice => 'Device';

  @override
  String get hexagenDeviceId => 'Device ID';

  @override
  String get hexagenFirmware => 'Firmware';

  @override
  String get hexagenInitialized => 'Initialized';

  @override
  String get hexagenYes => 'Yes';

  @override
  String get hexagenNo => 'No';

  @override
  String get hexagenNone => 'None';

  @override
  String get hexagenInit => 'Initialize';

  @override
  String get hexagenReset => 'Reset';

  @override
  String get hexagenInitSuccess => 'HexaGen service initialized';

  @override
  String get hexagenRefreshed => 'Device scan completed';

  @override
  String get hexagenResetSent => 'Reset command sent';

  @override
  String get hexagenRgb => 'RGB LED';

  @override
  String get hexagenRed => 'R';

  @override
  String get hexagenGreen => 'G';

  @override
  String get hexagenBlue => 'B';

  @override
  String get hexagenSendRgb => 'Send RGB';

  @override
  String get hexagenRgbSent => 'RGB command sent';

  @override
  String get hexagenFreqSweep => 'Frequency Sweep';

  @override
  String get hexagenFreqEmpty => 'No frequencies added';

  @override
  String get hexagenFreqHz => 'Freq (Hz)';

  @override
  String get hexagenDurationMs => 'Duration (ms)';

  @override
  String hexagenFreqRun(int count) {
    return 'Run ($count)';
  }

  @override
  String get hexagenFreqStop => 'Stop';

  @override
  String hexagenFreqProgress(int current, int total, int freq) {
    return 'Freq $current/$total: $freq Hz';
  }

  @override
  String hexagenFreqFailed(int freq, String status) {
    return 'Freq $freq Hz failed: $status';
  }

  @override
  String get hexagenFreqListDone => 'Frequency list completed';

  @override
  String get hexagenOpId => 'Operation ID';

  @override
  String get hexagenOpCurrentStatus => 'Status';

  @override
  String get hexagenOpStep => 'Step';

  @override
  String get hexagenOpRunning => 'Running...';

  @override
  String get hexagenOpPreparing => 'Preparing operation...';

  @override
  String hexagenOpPrepareFailed(String status) {
    return 'Prepare failed: $status';
  }

  @override
  String get hexagenOpGenerating => 'Generating...';

  @override
  String hexagenOpStatus(String status, int step) {
    return 'Operation: $status (step $step)';
  }

  @override
  String get harmonizerTitle => 'Harmonizer Player';

  @override
  String get harmonizerSelectFormula => 'Select a formula';

  @override
  String get harmonizerNoFormulas => 'No formulas available';

  @override
  String get harmonizerFormulaLabel => 'Formula';

  @override
  String get harmonizerTypeMonaural => 'Monaural';

  @override
  String get harmonizerTypeBinaural => 'Binaural';

  @override
  String get harmonizerTypeMagnetic => 'Magnetic';

  @override
  String get harmonizerTypePhotonic => 'Photonic';

  @override
  String get harmonizerTypeQuantal => 'Quantal';

  @override
  String get harmonizerComingSoon => 'This feature is coming soon';

  @override
  String get harmonizerHeadsetRequired =>
      'Please connect headphones for binaural mode';

  @override
  String get harmonizerHexagenRequired =>
      'Please connect a hexaGen device for magnetic mode';

  @override
  String get harmonizerSelectAmbience => 'Select ambience (optional)';

  @override
  String get harmonizerNoAmbience => 'No ambience';

  @override
  String get harmonizerPlay => 'Play';

  @override
  String get harmonizerStop => 'Stop';

  @override
  String get harmonizerPreparing => 'Preparing...';

  @override
  String get harmonizerPlaying => 'Playing';

  @override
  String get harmonizerStopping => 'Stopping...';

  @override
  String harmonizerError(String message) {
    return 'Error: $message';
  }

  @override
  String harmonizerCycle(int cycle) {
    return 'Cycle $cycle';
  }

  @override
  String get harmonizerTotalDuration => 'Total';

  @override
  String get harmonizerRemaining => 'Remaining';

  @override
  String harmonizerStep(int index, int value, String duration) {
    return 'Step $index: $value Hz — ${duration}s';
  }

  @override
  String get harmonizerStepOneshot => 'one-shot';

  @override
  String get harmonizerGracefulStopHint => 'Tap to stop after current cycle';

  @override
  String get harmonizerImmediateStopHint => 'Hold 3s to stop immediately';

  @override
  String get harmonizerGenerating => 'Generating sequence...';

  @override
  String get harmonizerNoSequence => 'No formula selected';
}
