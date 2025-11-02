# iOS Integration of Relay Plugin
We’ve identified that the build issues some developers experience on iOS are likely related to the way the Relay plugin is currently integrated into your Flutter project. When the Relay Client Plugin is being pulled in directly through Pods.framework, it can lead to platform-version mismatches and missing plugin registration.
There are two supported paths forward:

## Recommended Path (Use Flutter + pubspec.yaml)

This is the intended integration method for Flutter plugins. It ensures Flutter manages dependency versions, generates registrant code, and keeps Android and iOS in sync.
Steps
1.	Remove manual Pod reference
    •	Open ios/Podfile and remove any pod 'mte-relay-client-plugin' entries.
    •	The plugin should only be referenced in pubspec.yaml.
2.	Add plugin via pubspec.yaml
```yaml
dependencies:
  mte_relay_client_plugin:
    git:
      url: https://github.com/Eclypses/mte-relay-client-flutter.git
      ref: 4.2.11  
```
3.	Update iOS deployment target
	•	Open ios/Podfile and make sure the platform matches the plugin’s minimum requirement:
    ```ruby
    platform :ios, '14.0'
    ```
    •	If ios.Podfile doesn't exist, within yourFlutterApp/ios/Runner/Runner.xcodeproj/project.pbxproj file, search for and edit the IPHONEOS_DEPLOYMENT_TARGET = 12.0; settings to IPHONEOS_DEPLOYMENT_TARGET = 14.0;

4. Clean and rebuild
``` sh
    flutter clean
    rm -rf ios/Pods ios/Podfile.lock
    pod repo update
    pod install --project-directory=ios
    flutter build ios
```
At this point, Flutter will correctly pull in the plugin, auto-register it, and you can continue development without custom Pod tweaks.


## Alternate Path (Using Pods.framework)

If you have a strong reason to manage dependencies strictly through CocoaPods, you can continue using Pods.framework. Please note that this approach requires additional manual steps and is not the recommended Flutter integration path.

Steps
	1.	Add plugin to Podfile
``` ruby
pod 'mte-relay-client-plugin', :git => 'https://github.com/Eclypses/mte-relay-client-flutter.git', :ref => '4.2.11'
```
	2.	Update iOS deployment target
        •	Same as above:
``` ruby
    platform :ios, '14.0'
```
        •	Ensure the Xcode project (Runner.xcodeproj) also targets iOS 14.

	3.	Manually register the plugin
Because Flutter won’t auto-register manually added Pods, you must register it yourself.
In AppDelegate.swift:
``` swift
import mte_relay_client_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    MteRelayClientPlugin.register(with: self.registrar(forPlugin: "MteRelayClientPlugin")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
4. Rebuild with CocoaPods
``` sh
    pod repo update
    pod install --project-directory=ios
```

# Summary
	•	The Flutter-managed path (via pubspec.yaml) is the recommended and supported approach. It keeps iOS and Android consistent and avoids manual maintenance.
	•	The Pod-only path is possible, but requires:
	•	Matching iOS deployment target (14.0+)
	•	Manual plugin registration code


If you follow the recommended migration to pubspec.yaml, you’ll avoid future maintenance headaches and align with Flutter best practices.