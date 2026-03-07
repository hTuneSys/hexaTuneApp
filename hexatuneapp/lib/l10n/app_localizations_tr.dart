// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app => 'hexaTune';

  @override
  String get appName => 'hexaTune App';

  @override
  String get signInTitle => 'Giriş yap';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get emailAddress => 'E-posta adresi';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifreyi onayla';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get orContinueWith => 'veya şununla devam et';

  @override
  String get apple => 'Apple';

  @override
  String get google => 'Google';

  @override
  String get forgotPasswordQuestion => 'Şifrenizi mi unuttunuz?';

  @override
  String get dontHaveAccountPrefix => 'Hesabınız yok mu? ';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get createAnAccount => 'Hesap oluştur';

  @override
  String get signUpSubtitle => 'Başlamak için kayıt olun!';

  @override
  String get alreadyHaveAccountPrefix => 'Zaten bir hesabınız var mı? ';

  @override
  String get signInLink => 'Giriş Yap';

  @override
  String get forgotPasswordTitle => 'Şifremi Unuttum';

  @override
  String get forgotPasswordSubtitle =>
      'Sıfırlama kodu almak için e-postanızı girin.';

  @override
  String get sendResetCode => 'Sıfırlama Kodu Gönder';

  @override
  String get enterOtpCode => 'OTP Kodunu Girin';

  @override
  String get verificationCodeSentTo => 'Doğrulama kodunu gönderdik:';

  @override
  String get enterDigitCodeBelow => 'Lütfen aşağıdaki 8 haneli kodu girin.';

  @override
  String get verify => 'Doğrula';

  @override
  String get didntReceiveCode => 'Kodu almadınız mı?';

  @override
  String resendIn(String time) {
    return '$time sonra tekrar gönder';
  }

  @override
  String get resendCode => 'Kodu Tekrar Gönder';

  @override
  String get resetYourPassword => 'Şifrenizi Sıfırlayın';

  @override
  String get resetPasswordSubtitle =>
      'Yeni bir şifre oluşturmak için kodu girin.';

  @override
  String get resetPassword => 'Şifreyi Sıfırla';

  @override
  String get passwordStrengthWeak => 'zayıf';

  @override
  String get passwordStrengthFair => 'orta';

  @override
  String get passwordStrengthGood => 'iyi';

  @override
  String get passwordStrengthStrong => 'güçlü';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get emailAndPasswordRequired => 'E-posta ve şifre gerekli';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get otpRequired => 'Lütfen doğrulama kodunu girin';

  @override
  String get emailVerifiedSignIn => 'E-posta doğrulandı! Lütfen giriş yapın.';

  @override
  String get passwordResetSuccess => 'Şifre başarıyla sıfırlandı!';

  @override
  String otpSentTo(String email) {
    return 'Sıfırlama kodu $email adresine gönderildi';
  }

  @override
  String get verificationCodeResent => 'Doğrulama kodu tekrar gönderildi';

  @override
  String get accountCreatedVerifyEmail =>
      'Hesap oluşturuldu! Lütfen e-postanızı doğrulayın.';

  @override
  String get newAccountViaGoogle => 'Google ile yeni hesap oluşturuldu';

  @override
  String get newAccountViaApple => 'Apple ile yeni hesap oluşturuldu';

  @override
  String get appleSignInNotAvailable =>
      'Apple ile giriş yalnızca iOS\'ta kullanılabilir';
}
