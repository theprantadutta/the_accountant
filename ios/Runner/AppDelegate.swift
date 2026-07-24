import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register WorkManager plugin for background fetch
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(3600))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Plugin registration moved here for the UIScene lifecycle. Registering in
  // didFinishLaunchingWithOptions is no longer correct once scenes are adopted.
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
