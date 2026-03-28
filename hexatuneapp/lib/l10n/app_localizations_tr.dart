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
  String get enterDigitCodeBelow => 'Lütfen aşağıdaki 6 haneli kodu girin.';

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
  String get ambienceTextureFire => 'Ateş';

  @override
  String get ambienceTextureGrass => 'Çimen';

  @override
  String get ambienceTextureLeaf => 'Yaprak';

  @override
  String get ambienceTextureNight => 'Gece';

  @override
  String get ambienceTextureSnow => 'Kar';

  @override
  String get ambienceTextureSoftWind => 'Hafif Rüzgâr';

  @override
  String get ambienceTextureStrongWind => 'Kuvvetli Rüzgâr';

  @override
  String get ambienceTextureWaterDrop => 'Su Damlası';

  @override
  String get ambienceTextureWave => 'Dalga';

  @override
  String get ambienceEventSeaGull => 'Martı';

  @override
  String get ambienceEventBird => 'Kuş';

  @override
  String get ambienceEventBirdWing => 'Kuş Kanadı';

  @override
  String get ambienceEventBush => 'Çalılık';

  @override
  String get ambienceEventCrumble => 'Çıtırtı';

  @override
  String get ambienceEventFrog => 'Kurbağa';

  @override
  String get ambienceEventInsect => 'Böcek';

  @override
  String get ambienceEventOwl => 'Baykuş';

  @override
  String get ambienceEventStone => 'Taş';

  @override
  String get ambienceEventThunder => 'Gök Gürültüsü';

  @override
  String get ambienceEventTwig => 'Dal';

  @override
  String get ambienceEventWaterDrop => 'Su Damlası';

  @override
  String get ambienceEventWaterSplash => 'Su Sıçraması';

  @override
  String get ambienceEventWoodCrack => 'Odun Çıtırtısı';

  @override
  String get ambienceEventWoodpecker => 'Ağaçkakan';

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
  String get dspHarmonize => 'OYNAT';

  @override
  String get dspStop => 'DURDUR';

  @override
  String get dspGraceful => 'YUMUŞAK';

  @override
  String get dspLoading => 'YÜKLENİYOR...';

  @override
  String get dspFinishing => 'BİTİRİLİYOR...';

  @override
  String get dspHarmonizing => 'Çalıyor...';

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
  String get ambienceManagementTitle => 'Ambiyans Yönetimi';

  @override
  String get ambienceCreateTitle => 'Ambiyans Oluştur';

  @override
  String get ambienceEditTitle => 'Ambiyans Düzenle';

  @override
  String get ambienceViewTitle => 'Ambiyans Görüntüle';

  @override
  String get ambienceEmptyTitle => 'Henüz ambiyans yok.';

  @override
  String get ambienceEmptySubtitle =>
      'İlk öğenizi eklemek için + düğmesine basın.';

  @override
  String get ambienceDeleteConfirmTitle => 'Ambiyansı Sil';

  @override
  String ambienceDeleteConfirmMessage(String name) {
    return '\"$name\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get ambienceSortByName => 'Ad';

  @override
  String get ambienceSortByNewest => 'En Yeni';

  @override
  String get ambienceSortByOldest => 'En Eski';

  @override
  String get ambienceSoundLayers => 'Ses Katmanları';

  @override
  String get ambienceSoundSettings => 'Ses Ayarları';

  @override
  String get ambienceMaster => 'Ana Ses';

  @override
  String get ambienceNameLabel => 'Ad';

  @override
  String get ambienceNameHint => 'Ambiyans adı girin';

  @override
  String get ambienceNoBase => 'Yok';

  @override
  String get ambienceCreated => 'Ambiyans başarıyla oluşturuldu.';

  @override
  String get ambienceUpdated => 'Ambiyans başarıyla güncellendi.';

  @override
  String get ambienceDeleted => 'Ambiyans silindi.';

  @override
  String get ambienceNameRequired => 'Ad gereklidir.';

  @override
  String get ambienceSearchHint => 'Ambiyans ara...';

  @override
  String get ambienceSortTitle => 'Sırala';

  @override
  String get ambienceFilterTitle => 'Filtre';

  @override
  String get ambienceFilterAll => 'Tümü';

  @override
  String get ambienceViewMenuItem => 'Görüntüle';

  @override
  String get ambienceEditMenuItem => 'Düzenle';

  @override
  String get ambienceNotFound => 'Ambiyans bulunamadı.';

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
  String get hexagenOpId => 'Operasyon ID';

  @override
  String get hexagenOpCurrentStatus => 'Durum';

  @override
  String get hexagenOpStep => 'Adım';

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
  String get harmonizerTitle => 'Harmonizer Oynatıcı';

  @override
  String get harmonizerSelectFormula => 'Bir formül seçin';

  @override
  String get harmonizerNoFormulas => 'Formül bulunamadı';

  @override
  String get harmonizerFormulaLabel => 'Formül';

  @override
  String get harmonizerTypeMonaural => 'Monaural';

  @override
  String get harmonizerTypeBinaural => 'Binaural';

  @override
  String get harmonizerTypeMagnetic => 'Manyetik';

  @override
  String get harmonizerTypePhotonic => 'Fotonik';

  @override
  String get harmonizerTypeQuantal => 'Kuantal';

  @override
  String get harmonizerComingSoon => 'Bu özellik yakında gelecek';

  @override
  String get harmonizerHeadsetRequired =>
      'Binaural mod için lütfen kulaklık takınız';

  @override
  String get harmonizerHexagenRequired =>
      'Manyetik mod için lütfen bir hexaGen cihazı bağlayınız';

  @override
  String get harmonizerSelectAmbience => 'Ambiyans seçin (opsiyonel)';

  @override
  String get harmonizerNoAmbience => 'Ambiyans yok';

  @override
  String get harmonizerHarmonize => 'Oynat';

  @override
  String get harmonizerStop => 'Durdur';

  @override
  String get harmonizerPreparing => 'Hazırlanıyor...';

  @override
  String get harmonizerHarmonizing => 'Oynuyor';

  @override
  String get harmonizerStopping => 'Durduruluyor...';

  @override
  String harmonizerError(String message) {
    return 'Hata: $message';
  }

  @override
  String harmonizerCycle(int cycle) {
    return 'Döngü $cycle';
  }

  @override
  String get harmonizerTotalDuration => 'Toplam';

  @override
  String get harmonizerRemaining => 'Kalan';

  @override
  String harmonizerStep(int index, int value, String duration) {
    return 'Adım $index: $value Hz — ${duration}s';
  }

  @override
  String get harmonizerStepOneshot => 'tek seferlik';

  @override
  String get harmonizerGracefulStopHint =>
      'Mevcut döngü bitince durdurmak için dokunun';

  @override
  String get harmonizerImmediateStopHint =>
      'Anında durdurmak için 3 saniye basılı tutun';

  @override
  String get harmonizerGenerating => 'Sekans üretiliyor...';

  @override
  String get harmonizerNoSequence => 'Formül seçilmedi';

  @override
  String get categoryManagement => 'Kategori Yönetimi';

  @override
  String get categoryCreate => 'Kategori Oluştur';

  @override
  String get categoryEdit => 'Kategori Düzenle';

  @override
  String get categoryView => 'Kategori Görüntüle';

  @override
  String get categoryName => 'Ad';

  @override
  String get categoryNameHint => 'Kategori adını girin';

  @override
  String get categoryDescription => 'Açıklama';

  @override
  String get categoryDescriptionHint => 'Kategori açıklamasını girin';

  @override
  String get categoryLabels => 'Etiketler';

  @override
  String get categoryAddLabel => 'Etiket ekle';

  @override
  String categoryInventoryCount(int count) {
    return '$count Envanter';
  }

  @override
  String get categorySearchHint => 'Kategori ara...';

  @override
  String get categorySortTitle => 'Sırala';

  @override
  String get categoryFilterTitle => 'Filtrele';

  @override
  String get categorySortDefault => 'Varsayılan';

  @override
  String get categorySortNameAsc => 'Ad (A→Z)';

  @override
  String get categorySortNameDesc => 'Ad (Z→A)';

  @override
  String get categorySortNewest => 'En yeni';

  @override
  String get categorySortOldest => 'En eski';

  @override
  String get categoryEmptyTitle => 'Henüz kategori yok.';

  @override
  String get categoryEmptyHint => '+ butonuna basarak ilk öğenizi ekleyin.';

  @override
  String get categoryCreated => 'Kategori oluşturuldu';

  @override
  String get categoryUpdated => 'Kategori güncellendi';

  @override
  String get categoryDeleted => 'Kategori silindi';

  @override
  String categoryDeleteConfirm(String name) {
    return '\"$name\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get categoryNoLabels => 'Etiket yok';

  @override
  String get categoryEdit_menuItem => 'Düzenle';

  @override
  String get categoryView_menuItem => 'Görüntüle';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get create => 'Oluştur';

  @override
  String get cancel => 'İptal';

  @override
  String get loadMore => 'Daha Fazla';

  @override
  String get inventoryManagement => 'Envanter Yönetimi';

  @override
  String get inventoryCreate => 'Envanter Oluştur';

  @override
  String get inventoryEdit => 'Envanter Düzenle';

  @override
  String get inventoryView => 'Envanter Görüntüle';

  @override
  String get inventoryName => 'İsim';

  @override
  String get inventoryNameHint => 'Envanter adını girin';

  @override
  String get inventoryDescription => 'Açıklama';

  @override
  String get inventoryDescriptionHint => 'Kısa bir açıklama girin';

  @override
  String get inventoryCategory => 'Kategori';

  @override
  String get inventoryCategoryHint => 'Kategori seçin';

  @override
  String get inventoryLabels => 'Etiketler';

  @override
  String get inventoryAddLabel => 'Etiket ekle';

  @override
  String get inventoryAddImage => 'Resim Ekle';

  @override
  String get inventorySearchHint => 'Envanterlerde ara...';

  @override
  String get inventorySortTitle => 'Sırala';

  @override
  String get inventoryFilterTitle => 'Filtrele';

  @override
  String get inventorySortDefault => 'Varsayılan';

  @override
  String get inventorySortNameAsc => 'İsim (A→Z)';

  @override
  String get inventorySortNameDesc => 'İsim (Z→A)';

  @override
  String get inventorySortNewest => 'En yeni';

  @override
  String get inventorySortOldest => 'En eski';

  @override
  String get inventoryEmptyTitle => 'Envanteriniz boş.';

  @override
  String get inventoryEmptyHint => 'İlk öğenizi eklemek için + butonuna basın.';

  @override
  String get inventoryCreated => 'Envanter oluşturuldu';

  @override
  String get inventoryUpdated => 'Envanter güncellendi';

  @override
  String get inventoryDeleted => 'Envanter silindi';

  @override
  String inventoryDeleteConfirm(String name) {
    return '\"$name\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String get inventoryNoLabels => 'Etiket yok';

  @override
  String get inventoryEdit_menuItem => 'Düzenle';

  @override
  String get inventoryView_menuItem => 'Görüntüle';

  @override
  String inventoryCount(int count) {
    return '$count Envanter';
  }

  @override
  String get inventorySelectedTitle => 'Seçili Envanterler';

  @override
  String get inventoryCategoryAddNew => 'Yeni Ekle';

  @override
  String get inventoryCategoryRequired => 'Kategori gereklidir';

  @override
  String get inventoryNameRequired => 'İsim gereklidir';

  @override
  String get inventoryImageCamera => 'Kamera';

  @override
  String get inventoryImageGallery => 'Galeri';

  @override
  String get formulaManagement => 'Formül Yönetimi';

  @override
  String get formulaCreate => 'Formül Oluştur';

  @override
  String get formulaEdit => 'Formül Düzenle';

  @override
  String get formulaView => 'Formül Görüntüle';

  @override
  String get formulaName => 'Ad';

  @override
  String get formulaNameHint => 'Formül adını girin';

  @override
  String get formulaDescription => 'Açıklama';

  @override
  String get formulaDescriptionHint => 'Kısa bir açıklama girin';

  @override
  String get formulaLabels => 'Etiketler';

  @override
  String get formulaAddLabel => 'Etiket ekle';

  @override
  String get formulaAddInventory => 'Envanter Ekle';

  @override
  String get formulaSearchInventory => 'Eklenecek envanteri ara';

  @override
  String get formulaItemCount => 'Adet';

  @override
  String formulaInventoryCount(int count) {
    return '$count Envanter';
  }

  @override
  String get formulaSearchHint => 'Formülleri ara...';

  @override
  String get formulaSortTitle => 'Sırala';

  @override
  String get formulaFilterTitle => 'Filtre';

  @override
  String get formulaSortDefault => 'Varsayılan';

  @override
  String get formulaSortNameAsc => 'Ad (A→Z)';

  @override
  String get formulaSortNameDesc => 'Ad (Z→A)';

  @override
  String get formulaSortNewest => 'En yeni';

  @override
  String get formulaSortOldest => 'En eski';

  @override
  String get formulaEmptyTitle => 'Henüz formül yok.';

  @override
  String get formulaEmptyHint => 'İlk öğenizi eklemek için + düğmesine basın.';

  @override
  String get formulaCreated => 'Formül oluşturuldu';

  @override
  String get formulaUpdated => 'Formül kaydedildi';

  @override
  String get formulaDeleted => 'Formül silindi';

  @override
  String formulaDeleteConfirm(String name) {
    return '$name silmek istediğinizden emin misiniz?';
  }

  @override
  String get formulaNoLabels => 'Etiket yok';

  @override
  String get formulaEditMenuItem => 'Düzenle';

  @override
  String get formulaViewMenuItem => 'Görüntüle';

  @override
  String get formulaNameRequired => 'Ad gereklidir';

  @override
  String get formulaAddedInventory => 'Eklenen envanter';

  @override
  String get formulaItemRemoved => 'Öğe kaldırıldı';

  @override
  String get formulaItemAdded => 'Öğe eklendi';

  @override
  String formulaQuantityMax(int max) {
    return 'Maksimum toplam miktar aşıldı ($max)';
  }

  @override
  String get formulaInventoryDuplicate => 'Bu envanter zaten eklenmiş';

  @override
  String get errorUnauthorized =>
      'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.';

  @override
  String get errorForbidden => 'Bu işlem için yetkiniz bulunmuyor.';

  @override
  String get errorNotFound => 'İstenen kaynak bulunamadı.';

  @override
  String get errorBadRequest =>
      'Geçersiz istek. Lütfen girdinizi kontrol edin.';

  @override
  String get errorValidationFailed =>
      'Lütfen formu kontrol edip tekrar deneyin.';

  @override
  String get errorConflict =>
      'Bu kaynak zaten mevcut veya başka bir kaynakla çakışıyor.';

  @override
  String get errorInternalError =>
      'Bir şeyler ters gitti. Lütfen daha sonra tekrar deneyin.';

  @override
  String get errorTooManyAttempts =>
      'Çok fazla deneme. Lütfen bekleyin ve tekrar deneyin.';

  @override
  String get errorAccountLocked => 'Hesabınız kilitlendi.';

  @override
  String get errorAccountSuspended => 'Hesabınız askıya alındı.';

  @override
  String get errorEmailNotVerified => 'Lütfen e-posta adresinizi doğrulayın.';

  @override
  String get errorEmailAlreadyExists => 'Bu e-posta adresi zaten kayıtlı.';

  @override
  String get errorEmailAlreadyVerified =>
      'Bu e-posta adresi zaten doğrulanmış.';

  @override
  String get errorProviderAlreadyLinked =>
      'Bu sağlayıcı zaten hesabınıza bağlı.';

  @override
  String get errorPasswordResetInvalid =>
      'Geçersiz veya süresi dolmuş sıfırlama kodu.';

  @override
  String get errorPasswordResetMaxAttempts =>
      'Maksimum sıfırlama denemesi aşıldı. Lütfen yeni bir kod isteyin.';

  @override
  String get errorVerificationInvalid =>
      'Geçersiz veya süresi dolmuş doğrulama kodu.';

  @override
  String get errorVerificationMaxAttempts =>
      'Maksimum doğrulama denemesi aşıldı. Lütfen yeni bir kod isteyin.';

  @override
  String get errorNetwork => 'İnternet bağlantısı yok.';

  @override
  String get errorTimeout =>
      'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';

  @override
  String get errorUnknown => 'Beklenmeyen bir hata oluştu.';

  @override
  String get errorRateLimited => 'Çok fazla istek. Lütfen yavaşlayın.';

  @override
  String get otpExpired =>
      'Kodun süresi doldu. Yeni kod almak için tekrar gönder\'e dokunun.';

  @override
  String otpExpiresIn(String time) {
    return 'Kodun süresi $time içinde doluyor';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLinkedAccounts => 'Bağlı Hesaplar';

  @override
  String get settingsLinkedAccountsSubtitle =>
      'Kimlik doğrulama sağlayıcılarınızı yönetin';

  @override
  String get providerTitle => 'Bağlı Hesaplar';

  @override
  String get providerEmailSection => 'E-posta';

  @override
  String get providerGoogleSection => 'Google';

  @override
  String get providerAppleSection => 'Apple';

  @override
  String providerLinkedAt(String date) {
    return 'Bağlanma tarihi: $date';
  }

  @override
  String get providerLinkWithEmail => 'E-posta ile Bağla';

  @override
  String get providerLinkWithGoogle => 'Google ile Bağla';

  @override
  String get providerLinkWithApple => 'Apple ile Bağla';

  @override
  String get providerUnlink => 'Bağlantıyı Kaldır';

  @override
  String get providerResetPassword => 'Şifre Sıfırla';

  @override
  String get providerEmailHint => 'E-posta adresi';

  @override
  String get providerPasswordHint => 'Şifre';

  @override
  String get providerEmailRequired => 'E-posta gereklidir';

  @override
  String get providerPasswordRequired => 'Şifre gereklidir';

  @override
  String get providerEmailLinked => 'E-posta sağlayıcısı bağlandı';

  @override
  String get providerGoogleLinked => 'Google hesabı bağlandı';

  @override
  String get providerAppleLinked => 'Apple hesabı bağlandı';

  @override
  String get providerUnlinked => 'Sağlayıcı bağlantısı kaldırıldı';

  @override
  String get providerUnlinkConfirm =>
      'Bu sağlayıcının bağlantısını kaldırmak istediğinizden emin misiniz?';

  @override
  String get providerUnlinkCancel => 'İptal';

  @override
  String get providerUnlinkConfirmAction => 'Bağlantıyı Kaldır';

  @override
  String get providerVerifyEmail => 'E-postanızı doğrulayın';

  @override
  String get providerVerifyEmailSubtitle =>
      'E-postanıza gönderilen doğrulama kodunu girin';

  @override
  String get providerResetPasswordTitle => 'Şifre Sıfırla';

  @override
  String get providerResetPasswordSubtitle =>
      'E-postanıza gönderilen kodu girin ve yeni şifre belirleyin';

  @override
  String get providerPasswordResetSuccess => 'Şifre başarıyla sıfırlandı';

  @override
  String get providerOAuthCancelled => 'Oturum açma iptal edildi';

  @override
  String get providerOAuthNotAvailable =>
      'Apple ile oturum açma yalnızca iOS ve macOS\'ta kullanılabilir';

  @override
  String get providerNotLinked => 'Bağlı değil';

  @override
  String get providerEmailVerified => 'Doğrulanmış';

  @override
  String get providerEmailNotVerified => 'Doğrulanmamış';

  @override
  String get workspaceTitle => 'Çalışma Alanınız';

  @override
  String get workspacePinnedFormulas => 'Sabitlenmiş Formüller';

  @override
  String get workspacePinnedEdit => 'Düzenle';

  @override
  String get workspaceQuickAdd => 'Hızlı Ekle';

  @override
  String get workspaceStats => 'İstatistikler';

  @override
  String get workspaceInventory => 'Envanter';

  @override
  String get workspaceCategory => 'Kategori';

  @override
  String get workspaceFormula => 'Formül';

  @override
  String get workspaceAmbience => 'Ambiyans';

  @override
  String get workspaceRecentlyUsed => 'Son Kullanılanlar';

  @override
  String get workspaceSearchToPin => 'Sabitlemek için ara';

  @override
  String get workspaceNoPinnedFormulas => 'Sabitlenmiş formül yok';

  @override
  String get workspaceNoRecentlyUsed => 'Son kullanılan formül yok';
}
