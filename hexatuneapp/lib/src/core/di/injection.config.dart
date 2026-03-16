// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart'
    as _i925;
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart' as _i845;
import 'package:hexatuneapp/src/core/dsp/dsp_bindings.dart' as _i1000;
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart' as _i716;
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart'
    as _i494;
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart'
    as _i475;
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart'
    as _i468;
import 'package:hexatuneapp/src/core/log/log_service.dart' as _i571;
import 'package:hexatuneapp/src/core/media/image_service.dart' as _i207;
import 'package:hexatuneapp/src/core/network/api_client.dart' as _i761;
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart'
    as _i56;
import 'package:hexatuneapp/src/core/network/interceptors/error_interceptor.dart'
    as _i782;
import 'package:hexatuneapp/src/core/network/interceptors/logging_interceptor.dart'
    as _i1063;
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart'
    as _i367;
import 'package:hexatuneapp/src/core/notification/notification_service.dart'
    as _i623;
import 'package:hexatuneapp/src/core/permission/permission_service.dart'
    as _i1001;
import 'package:hexatuneapp/src/core/proto/proto_service.dart' as _i410;
import 'package:hexatuneapp/src/core/rest/account/account_repository.dart'
    as _i87;
import 'package:hexatuneapp/src/core/rest/audit/audit_repository.dart' as _i501;
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart' as _i10;
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart' as _i907;
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart' as _i815;
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart'
    as _i226;
import 'package:hexatuneapp/src/core/rest/auth/tenant_repository.dart' as _i20;
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart' as _i815;
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart'
    as _i883;
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart'
    as _i864;
import 'package:hexatuneapp/src/core/rest/device/device_service.dart' as _i292;
import 'package:hexatuneapp/src/core/rest/flow/flow_repository.dart' as _i364;
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart'
    as _i770;
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart'
    as _i53;
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart'
    as _i778;
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart'
    as _i1069;
import 'package:hexatuneapp/src/core/rest/session/session_repository.dart'
    as _i80;
import 'package:hexatuneapp/src/core/rest/step/step_repository.dart' as _i1040;
import 'package:hexatuneapp/src/core/rest/task/task_repository.dart' as _i266;
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart'
    as _i957;
import 'package:hexatuneapp/src/core/router/app_router.dart' as _i877;
import 'package:hexatuneapp/src/core/storage/preferences_service.dart' as _i148;
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart'
    as _i325;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i571.LogService>(() => _i571.LogService()..init());
    gh.singleton<_i782.ErrorInterceptor>(() => _i782.ErrorInterceptor());
    await gh.singletonAsync<_i148.PreferencesService>(() {
      final i = _i148.PreferencesService();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i925.AmbienceService>(
      () => _i925.AmbienceService(
        gh<_i148.PreferencesService>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i845.DspAssetService>(
      () => _i845.DspAssetService(gh<_i571.LogService>()),
    );
    gh.singleton<_i1000.DspBindings>(
      () => _i1000.DspBindings(gh<_i571.LogService>()),
    );
    gh.singleton<_i494.HeadsetService>(
      () => _i494.HeadsetService(gh<_i571.LogService>()),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i207.ImageService>(
      () => _i207.ImageService(gh<_i571.LogService>()),
    );
    gh.singleton<_i1063.LoggingInterceptor>(
      () => _i1063.LoggingInterceptor(gh<_i571.LogService>())..init(),
    );
    gh.singleton<_i367.LocalNotificationService>(
      () => _i367.LocalNotificationService(gh<_i571.LogService>()),
    );
    gh.singleton<_i1001.PermissionService>(
      () => _i1001.PermissionService(gh<_i571.LogService>()),
    );
    gh.singleton<_i410.ProtoService>(
      () => _i410.ProtoService(gh<_i571.LogService>()),
    );
    gh.singleton<_i325.SecureStorageService>(
      () => _i325.SecureStorageService(gh<_i571.LogService>())..init(),
    );
    gh.singleton<_i815.TokenManager>(
      () => _i815.TokenManager(
        gh<_i325.SecureStorageService>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i292.DeviceService>(
      () => _i292.DeviceService(
        gh<_i325.SecureStorageService>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i815.OAuthService>(
      () =>
          _i815.OAuthService(gh<_i292.DeviceService>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i623.NotificationService>(
      () => _i623.NotificationService(
        gh<_i571.LogService>(),
        gh<_i367.LocalNotificationService>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i56.AuthInterceptor>(
      () => _i56.AuthInterceptor(
        gh<_i815.TokenManager>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i761.ApiClient>(
      () => _i761.ApiClient(
        gh<_i571.LogService>(),
        gh<_i56.AuthInterceptor>(),
        gh<_i782.ErrorInterceptor>(),
        gh<_i1063.LoggingInterceptor>(),
      )..init(),
    );
    gh.singleton<_i475.HexagenService>(
      () => _i475.HexagenService(
        gh<_i571.LogService>(),
        gh<_i410.ProtoService>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i716.DspService>(
      () => _i716.DspService(gh<_i1000.DspBindings>(), gh<_i571.LogService>()),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i468.HarmonizerService>(
      () => _i468.HarmonizerService(
        gh<_i716.DspService>(),
        gh<_i475.HexagenService>(),
        gh<_i494.HeadsetService>(),
        gh<_i925.AmbienceService>(),
        gh<_i845.DspAssetService>(),
        gh<_i571.LogService>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i87.AccountRepository>(
      () =>
          _i87.AccountRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i501.AuditRepository>(
      () =>
          _i501.AuditRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i10.AuthRepository>(
      () => _i10.AuthRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i226.ProviderRepository>(
      () => _i226.ProviderRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i20.TenantRepository>(
      () =>
          _i20.TenantRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i883.CategoryRepository>(
      () => _i883.CategoryRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i864.DeviceRepository>(
      () =>
          _i864.DeviceRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i364.FlowRepository>(
      () => _i364.FlowRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i770.FormulaRepository>(
      () => _i770.FormulaRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i53.HarmonicsRepository>(
      () => _i53.HarmonicsRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i778.InventoryRepository>(
      () => _i778.InventoryRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i1069.PackageRepository>(
      () => _i1069.PackageRepository(
        gh<_i761.ApiClient>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i80.SessionRepository>(
      () =>
          _i80.SessionRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i1040.StepRepository>(
      () =>
          _i1040.StepRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i266.TaskRepository>(
      () => _i266.TaskRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i957.WalletRepository>(
      () =>
          _i957.WalletRepository(gh<_i761.ApiClient>(), gh<_i571.LogService>()),
    );
    gh.singleton<_i907.AuthService>(
      () => _i907.AuthService(
        gh<_i815.TokenManager>(),
        gh<_i10.AuthRepository>(),
        gh<_i56.AuthInterceptor>(),
        gh<_i571.LogService>(),
      ),
    );
    gh.singleton<_i877.AppRouter>(
      () => _i877.AppRouter(gh<_i907.AuthService>(), gh<_i571.LogService>()),
    );
    return this;
  }
}
