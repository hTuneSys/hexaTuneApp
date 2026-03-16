import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var audioDeviceDetector: AudioDeviceDetector?
  private var dspChannelHandler: DspMethodChannelHandler?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Force-link all Rust FFI symbols so dlsym() can find them at runtime.
    let _ = hexa_force_link_symbols()

    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      audioDeviceDetector = AudioDeviceDetector(messenger: controller.binaryMessenger)
      audioDeviceDetector?.start()

      dspChannelHandler = DspMethodChannelHandler()
      dspChannelHandler?.register(with: controller.binaryMessenger)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
