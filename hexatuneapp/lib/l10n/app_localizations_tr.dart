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

  @override
  String get ambienceBaseForest => 'Orman';

  @override
  String get ambienceBaseOcean => 'Okyanus';

  @override
  String get ambienceBaseRain => 'Yağmur';

  @override
  String get ambienceTextureWave => 'Dalga';

  @override
  String get ambienceTextureWindThroughTrees => 'Ağaçların Arasında Rüzgâr';

  @override
  String get ambienceEventBird => 'Kuş';

  @override
  String get ambienceEventCat => 'Kedi';

  @override
  String get ambienceEventFish => 'Balık';

  @override
  String get ambienceEventThunder => 'Gök Gürültüsü';

  @override
  String get dspPageTitle => 'DSP Ses Motoru';

  @override
  String get dspSoundLayers => 'Ses Katmanları';

  @override
  String get dspGainControls => 'Ses Ayarları';

  @override
  String get dspBinauralConfig => 'Binaural Yapılandırma';

  @override
  String get dspCycleSteps => 'Frekans Döngü Adımları';

  @override
  String get dspSectionBase => 'Temel';

  @override
  String get dspSectionTexture => 'Doku';

  @override
  String get dspSectionEvents => 'Olaylar';

  @override
  String dspSelectedCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get dspNoSelection => 'Seçmek için dokunun';

  @override
  String get dspPlay => 'OYNAT';

  @override
  String get dspStop => 'DURDUR';

  @override
  String get dspGraceful => 'YUMUŞAK';

  @override
  String get dspLoading => 'YÜKLENİYOR...';

  @override
  String get dspFinishing => 'BİTİRİLİYOR...';

  @override
  String get dspPlaying => 'Çalıyor...';

  @override
  String get dspStopped => 'Durduruldu';

  @override
  String get dspGracefullyStopped => 'Yumuşak geçişle durduruldu';

  @override
  String get dspFinishingCycle => 'Döngü tamamlanıyor...';

  @override
  String get dspCarrierFrequency => 'Taşıyıcı Frekans (Hz)';

  @override
  String get dspBinauralMode => 'Binaural Mod';

  @override
  String get dspBinauralStereo => 'Stereo binaural atışlar';

  @override
  String get dspBinauralMono => 'AM mono darbeli';

  @override
  String get dspDeltaHz => 'Delta Hz';

  @override
  String get dspDurationS => 'Süre s';

  @override
  String get dspAddStep => 'Adım Ekle';

  @override
  String dspBaseLoaded(String name) {
    return 'Temel yüklendi: $name';
  }

  @override
  String dspTextureLoaded(int index, String name) {
    return 'Doku $index yüklendi: $name';
  }

  @override
  String dspEventLoaded(int index, String name) {
    return 'Olay $index yüklendi: $name';
  }

  @override
  String get dspSelectBaseFirst => 'Önce bir Temel katman seçin';

  @override
  String dspLoadFailed(int code) {
    return 'Yükleme başarısız (rc=$code)';
  }

  @override
  String get dspAmbienceTitle => 'Ambiyans Ön Ayarları';

  @override
  String get dspAmbienceCreate => 'Ambiyans Oluştur';

  @override
  String get dspAmbienceEdit => 'Ambiyansı Düzenle';

  @override
  String get dspAmbienceSave => 'Kaydet';

  @override
  String get dspAmbienceUpdate => 'Güncelle';

  @override
  String get dspAmbienceName => 'Ambiyans Adı';

  @override
  String get dspAmbienceEmpty => 'Henüz ambiyans yok';

  @override
  String get dspAmbienceEmptyHint =>
      'İlk ambiyansınızı oluşturmak için + düğmesine dokunun';

  @override
  String get dspAmbienceDeleteTitle => 'Ambiyansı Sil';

  @override
  String dspAmbienceDeleteConfirm(String name) {
    return '\"$name\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get dspAmbienceDelete => 'Sil';

  @override
  String get dspAmbienceCancel => 'İptal';

  @override
  String get dspAmbienceNoBase => 'Yok';

  @override
  String get dspAmbienceSummary => 'Özet';

  @override
  String get dspAmbienceSelectAmbience => 'Ambiyans Seç';

  @override
  String get dspAmbienceNoneSelected => 'Ambiyans seçilmedi';

  @override
  String dspAmbienceLoaded(String name) {
    return 'Ambiyans yüklendi: $name';
  }

  @override
  String get dspAmbienceManage => 'Yönet';

  @override
  String get hexagenTitle => 'hexaGen Cihazı';

  @override
  String get hexagenRefresh => 'Yenile';

  @override
  String get hexagenConnection => 'Bağlantı';

  @override
  String get hexagenStatusReady => 'Hazır';

  @override
  String get hexagenStatusConnected => 'Bağlı';

  @override
  String get hexagenStatusDisconnected => 'Bağlı Değil';

  @override
  String get hexagenDevice => 'Cihaz';

  @override
  String get hexagenDeviceId => 'Cihaz ID';

  @override
  String get hexagenFirmware => 'Firmware';

  @override
  String get hexagenInitialized => 'Başlatıldı';

  @override
  String get hexagenYes => 'Evet';

  @override
  String get hexagenNo => 'Hayır';

  @override
  String get hexagenNone => 'Yok';

  @override
  String get hexagenInit => 'Başlat';

  @override
  String get hexagenReset => 'Sıfırla';

  @override
  String get hexagenInitSuccess => 'HexaGen servisi başlatıldı';

  @override
  String get hexagenRefreshed => 'Cihaz taraması tamamlandı';

  @override
  String get hexagenResetSent => 'Sıfırlama komutu gönderildi';

  @override
  String get hexagenRgb => 'RGB LED';

  @override
  String get hexagenRed => 'K';

  @override
  String get hexagenGreen => 'Y';

  @override
  String get hexagenBlue => 'M';

  @override
  String get hexagenSendRgb => 'RGB Gönder';

  @override
  String get hexagenRgbSent => 'RGB komutu gönderildi';

  @override
  String get hexagenFreqSweep => 'Frekans Taraması';

  @override
  String get hexagenFreqEmpty => 'Frekans eklenmedi';

  @override
  String get hexagenFreqHz => 'Frekans (Hz)';

  @override
  String get hexagenDurationMs => 'Süre (ms)';

  @override
  String hexagenFreqRun(int count) {
    return 'Çalıştır ($count)';
  }

  @override
  String get hexagenFreqStop => 'Durdur';

  @override
  String hexagenFreqProgress(int current, int total, int freq) {
    return 'Frekans $current/$total: $freq Hz';
  }

  @override
  String hexagenFreqFailed(int freq, String status) {
    return 'Frekans $freq Hz başarısız: $status';
  }

  @override
  String get hexagenFreqListDone => 'Frekans listesi tamamlandı';

  @override
  String get hexagenOperation => 'Operasyon';

  @override
  String get hexagenOpId => 'Operasyon ID';

  @override
  String get hexagenOpCurrentStatus => 'Durum';

  @override
  String get hexagenOpStep => 'Adım';

  @override
  String get hexagenOpStart => 'Operasyonu Başlat';

  @override
  String get hexagenOpRunning => 'Çalışıyor...';

  @override
  String get hexagenOpPreparing => 'Operasyon hazırlanıyor...';

  @override
  String hexagenOpPrepareFailed(String status) {
    return 'Hazırlık başarısız: $status';
  }

  @override
  String get hexagenOpGenerating => 'Üretiliyor...';

  @override
  String hexagenOpStatus(String status, int step) {
    return 'Operasyon: $status (adım $step)';
  }

  @override
  String get hexagenOpDone => 'Operasyon tamamlandı';
}
