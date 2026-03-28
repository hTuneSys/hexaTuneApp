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
  String get enterDigitCodeBelow => 'Please enter the 6-digit code below.';

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
  String get dspHarmonize => 'HARMONIZE';

  @override
  String get dspStop => 'STOP';

  @override
  String get dspGraceful => 'GRACEFUL';

  @override
  String get dspLoading => 'LOADING...';

  @override
  String get dspFinishing => 'FINISHING...';

  @override
  String get dspHarmonizing => 'Harmonizing...';

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
  String get ambienceManagementTitle => 'Ambience Management';

  @override
  String get ambienceCreateTitle => 'Create Ambience';

  @override
  String get ambienceEditTitle => 'Edit Ambience';

  @override
  String get ambienceViewTitle => 'View Ambience';

  @override
  String get ambienceEmptyTitle => 'No ambience yet.';

  @override
  String get ambienceEmptySubtitle =>
      'Press the + button to add your first item.';

  @override
  String get ambienceDeleteConfirmTitle => 'Delete Ambience';

  @override
  String ambienceDeleteConfirmMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get ambienceSortByName => 'Name';

  @override
  String get ambienceSortByNewest => 'Newest';

  @override
  String get ambienceSortByOldest => 'Oldest';

  @override
  String get ambienceSoundLayers => 'Sound Layers';

  @override
  String get ambienceSoundSettings => 'Sound Settings';

  @override
  String get ambienceMaster => 'Master';

  @override
  String get ambienceNameLabel => 'Name';

  @override
  String get ambienceNameHint => 'Enter ambience name';

  @override
  String get ambienceNoBase => 'None';

  @override
  String get ambienceCreated => 'Ambience created successfully.';

  @override
  String get ambienceUpdated => 'Ambience updated successfully.';

  @override
  String get ambienceDeleted => 'Ambience deleted.';

  @override
  String get ambienceNameRequired => 'Name is required.';

  @override
  String get ambienceSearchHint => 'Search ambiences...';

  @override
  String get ambienceSortTitle => 'Sort';

  @override
  String get ambienceFilterTitle => 'Filter';

  @override
  String get ambienceFilterAll => 'All';

  @override
  String get ambienceViewMenuItem => 'View';

  @override
  String get ambienceEditMenuItem => 'Edit';

  @override
  String get ambienceNotFound => 'Ambience not found.';

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
  String get harmonizerTitle => 'Harmonizer';

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
  String get harmonizerHarmonize => 'Harmonize';

  @override
  String get harmonizerStop => 'Stop';

  @override
  String get harmonizerPreparing => 'Preparing...';

  @override
  String get harmonizerHarmonizing => 'Harmonizing';

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

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get categoryCreate => 'Create Category';

  @override
  String get categoryEdit => 'Edit Category';

  @override
  String get categoryView => 'View Category';

  @override
  String get categoryName => 'Name';

  @override
  String get categoryNameHint => 'Enter category name';

  @override
  String get categoryDescription => 'Description';

  @override
  String get categoryDescriptionHint => 'Enter category description';

  @override
  String get categoryLabels => 'Labels';

  @override
  String get categoryAddLabel => 'Add label';

  @override
  String categoryInventoryCount(int count) {
    return '$count Inventory';
  }

  @override
  String get categorySearchHint => 'Search categories...';

  @override
  String get categorySortTitle => 'Sort';

  @override
  String get categoryFilterTitle => 'Filter';

  @override
  String get categorySortDefault => 'Default';

  @override
  String get categorySortNameAsc => 'Name (A→Z)';

  @override
  String get categorySortNameDesc => 'Name (Z→A)';

  @override
  String get categorySortNewest => 'Newest first';

  @override
  String get categorySortOldest => 'Oldest first';

  @override
  String get categoryEmptyTitle => 'No categories yet.';

  @override
  String get categoryEmptyHint => 'Press the + button to add your first item.';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get categoryUpdated => 'Category updated';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String categoryDeleteConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get categoryNoLabels => 'No labels';

  @override
  String get categoryEdit_menuItem => 'Edit';

  @override
  String get categoryView_menuItem => 'View';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get create => 'Create';

  @override
  String get cancel => 'Cancel';

  @override
  String get loadMore => 'Load More';

  @override
  String get inventoryManagement => 'Inventory Management';

  @override
  String get inventoryCreate => 'Create Inventory';

  @override
  String get inventoryEdit => 'Edit Inventory';

  @override
  String get inventoryView => 'View Inventory';

  @override
  String get inventoryName => 'Name';

  @override
  String get inventoryNameHint => 'Enter inventory name';

  @override
  String get inventoryDescription => 'Description';

  @override
  String get inventoryDescriptionHint => 'Enter a short description';

  @override
  String get inventoryCategory => 'Category';

  @override
  String get inventoryCategoryHint => 'Select category';

  @override
  String get inventoryLabels => 'Labels';

  @override
  String get inventoryAddLabel => 'Add labels';

  @override
  String get inventoryAddImage => 'Add Image';

  @override
  String get inventorySearchHint => 'Search inventories...';

  @override
  String get inventorySortTitle => 'Sort';

  @override
  String get inventoryFilterTitle => 'Filter';

  @override
  String get inventorySortDefault => 'Default';

  @override
  String get inventorySortNameAsc => 'Name (A→Z)';

  @override
  String get inventorySortNameDesc => 'Name (Z→A)';

  @override
  String get inventorySortNewest => 'Newest first';

  @override
  String get inventorySortOldest => 'Oldest first';

  @override
  String get inventoryEmptyTitle => 'Your inventory is empty.';

  @override
  String get inventoryEmptyHint => 'Press the + button to add your first item.';

  @override
  String get inventoryCreated => 'Inventory created';

  @override
  String get inventoryUpdated => 'Inventory updated';

  @override
  String get inventoryDeleted => 'Inventory deleted';

  @override
  String inventoryDeleteConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get inventoryNoLabels => 'No labels';

  @override
  String get inventoryEdit_menuItem => 'Edit';

  @override
  String get inventoryView_menuItem => 'View';

  @override
  String inventoryCount(int count) {
    return '$count Inventory';
  }

  @override
  String get inventoryCategoryAddNew => 'Add New';

  @override
  String get inventoryCategoryRequired => 'Category is required';

  @override
  String get inventoryNameRequired => 'Name is required';

  @override
  String get inventoryImageCamera => 'Camera';

  @override
  String get inventoryImageGallery => 'Gallery';

  @override
  String get formulaManagement => 'Formula Management';

  @override
  String get formulaCreate => 'Create Formula';

  @override
  String get formulaEdit => 'Edit Formula';

  @override
  String get formulaView => 'View Formula';

  @override
  String get formulaName => 'Name';

  @override
  String get formulaNameHint => 'Enter formula name';

  @override
  String get formulaDescription => 'Description';

  @override
  String get formulaDescriptionHint => 'Enter a short description';

  @override
  String get formulaLabels => 'Labels';

  @override
  String get formulaAddLabel => 'Add labels';

  @override
  String get formulaAddInventory => 'Add Inventory';

  @override
  String get formulaSearchInventory => 'Search inventory to add';

  @override
  String get formulaItemCount => 'Count';

  @override
  String formulaInventoryCount(int count) {
    return '$count Inventory';
  }

  @override
  String get formulaSearchHint => 'Search formulas...';

  @override
  String get formulaSortTitle => 'Sort';

  @override
  String get formulaFilterTitle => 'Filter';

  @override
  String get formulaSortDefault => 'Default';

  @override
  String get formulaSortNameAsc => 'Name (A→Z)';

  @override
  String get formulaSortNameDesc => 'Name (Z→A)';

  @override
  String get formulaSortNewest => 'Newest first';

  @override
  String get formulaSortOldest => 'Oldest first';

  @override
  String get formulaEmptyTitle => 'No formulas yet.';

  @override
  String get formulaEmptyHint => 'Press the + button to add your first item.';

  @override
  String get formulaCreated => 'Formula created';

  @override
  String get formulaUpdated => 'Formula saved';

  @override
  String get formulaDeleted => 'Formula deleted';

  @override
  String formulaDeleteConfirm(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get formulaNoLabels => 'No labels';

  @override
  String get formulaEditMenuItem => 'Edit';

  @override
  String get formulaViewMenuItem => 'View';

  @override
  String get formulaNameRequired => 'Name is required';

  @override
  String get formulaAddedInventory => 'Added inventory';

  @override
  String get formulaItemRemoved => 'Item removed';

  @override
  String get formulaItemAdded => 'Item added';

  @override
  String formulaQuantityMax(int max) {
    return 'Maximum total quantity reached ($max)';
  }

  @override
  String get formulaInventoryDuplicate => 'This inventory is already added';

  @override
  String get errorUnauthorized => 'Session expired. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have permission for this action.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorBadRequest => 'Invalid request. Please check your input.';

  @override
  String get errorValidationFailed => 'Please check the form and try again.';

  @override
  String get errorConflict =>
      'This resource already exists or conflicts with another.';

  @override
  String get errorInternalError =>
      'Something went wrong. Please try again later.';

  @override
  String get errorTooManyAttempts =>
      'Too many attempts. Please wait and try again.';

  @override
  String get errorAccountLocked => 'Your account has been locked.';

  @override
  String get errorAccountSuspended => 'Your account has been suspended.';

  @override
  String get errorEmailNotVerified => 'Please verify your email address.';

  @override
  String get errorEmailAlreadyExists => 'This email is already registered.';

  @override
  String get errorEmailAlreadyVerified => 'This email is already verified.';

  @override
  String get errorProviderAlreadyLinked =>
      'This provider is already linked to your account.';

  @override
  String get errorPasswordResetInvalid => 'Invalid or expired reset code.';

  @override
  String get errorPasswordResetMaxAttempts =>
      'Maximum reset attempts exceeded. Please request a new code.';

  @override
  String get errorVerificationInvalid =>
      'Invalid or expired verification code.';

  @override
  String get errorVerificationMaxAttempts =>
      'Maximum verification attempts exceeded. Please request a new code.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorRateLimited => 'Too many requests. Please slow down.';

  @override
  String get otpExpired => 'Code expired. Tap resend to get a new code.';

  @override
  String otpExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLinkedAccounts => 'Linked Accounts';

  @override
  String get settingsLinkedAccountsSubtitle =>
      'Manage your authentication providers';

  @override
  String get providerTitle => 'Linked Accounts';

  @override
  String get providerEmailSection => 'Email';

  @override
  String get providerGoogleSection => 'Google';

  @override
  String get providerAppleSection => 'Apple';

  @override
  String providerLinkedAt(String date) {
    return 'Linked $date';
  }

  @override
  String get providerLinkWithEmail => 'Link with Email';

  @override
  String get providerLinkWithGoogle => 'Link with Google';

  @override
  String get providerLinkWithApple => 'Link with Apple';

  @override
  String get providerUnlink => 'Unlink';

  @override
  String get providerResetPassword => 'Reset Password';

  @override
  String get providerEmailHint => 'Email address';

  @override
  String get providerPasswordHint => 'Password';

  @override
  String get providerEmailRequired => 'Email is required';

  @override
  String get providerPasswordRequired => 'Password is required';

  @override
  String get providerEmailLinked => 'Email provider linked';

  @override
  String get providerGoogleLinked => 'Google account linked';

  @override
  String get providerAppleLinked => 'Apple account linked';

  @override
  String get providerUnlinked => 'Provider unlinked';

  @override
  String get providerUnlinkConfirm =>
      'Are you sure you want to unlink this provider?';

  @override
  String get providerUnlinkCancel => 'Cancel';

  @override
  String get providerUnlinkConfirmAction => 'Unlink';

  @override
  String get providerVerifyEmail => 'Verify your email';

  @override
  String get providerVerifyEmailSubtitle =>
      'Enter the verification code sent to your email';

  @override
  String get providerResetPasswordTitle => 'Reset Password';

  @override
  String get providerResetPasswordSubtitle =>
      'Enter the code sent to your email and set a new password';

  @override
  String get providerPasswordResetSuccess => 'Password reset successfully';

  @override
  String get providerOAuthCancelled => 'Sign-in was cancelled';

  @override
  String get providerOAuthNotAvailable =>
      'Apple Sign-In is only available on iOS and macOS';

  @override
  String get providerNotLinked => 'Not linked';

  @override
  String get providerEmailVerified => 'Verified';

  @override
  String get providerEmailNotVerified => 'Not verified';

  @override
  String get workspaceTitle => 'Your Workspace';

  @override
  String get workspacePinnedFormulas => 'Pinned Formulas';

  @override
  String get workspacePinnedEdit => 'Edit';

  @override
  String get workspaceQuickAdd => 'Quick Add';

  @override
  String get workspaceStats => 'Stats';

  @override
  String get workspaceInventory => 'Inventory';

  @override
  String get workspaceCategory => 'Category';

  @override
  String get workspaceFormula => 'Formula';

  @override
  String get workspaceAmbience => 'Ambience';

  @override
  String get workspaceRecentlyUsed => 'Recently Used';

  @override
  String get workspaceSearchToPin => 'Search to pin';

  @override
  String get workspaceNoPinnedFormulas => 'No pinned formulas';

  @override
  String get workspaceNoRecentlyUsed => 'No recently used formulas';
}
