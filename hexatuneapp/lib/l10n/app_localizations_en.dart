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
}
