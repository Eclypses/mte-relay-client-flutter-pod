<center>
<img src="Eclypses.png" style="width:50%;" alt="Eclypses Logo"/>
</center>

<div align="center" style="font-size:40pt; font-weight:900; font-family:arial; margin-top:50px;" >
MteRelay Client Flutter Plugin (CocoaPods) </div>
<br>

### This Flutter plugin provides plug-and-play MTE integration for iOS/Swift and Android/Java Flutter applications, allowing quick integration with very minimal code changes. This Client Plugin requires a corresponding MteRelay Server API to receive the encoded requests and relay them onto the original API.

---

## 📑 Table of Contents

- [Overview](#overview)
- [Before You Begin](#before-you-begin)
- [Add MteRelay Client Flutter Plugin to your application](#add-mterelay-client-flutter-plugin-to-your-application)
- [Response Handling](#response-handling)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)
- [Contact Eclypses](#contact-eclypses) 
<br><br>

## Overview 
When you have integrated this Plugin into your Flutter application and have set up and configured the corresponding MteRelay Server API, your client application will make its network calls just as before except that they are now routed through the MteRelay plugin. 

There, the Request is inspected and the relevant information captured. The MteRelay mobile client checks for a corresponding MteRelay Server and if not found, returns an error. However, if the server IS found, a new request is created, the original data is encoded with MTE and sent to the MteRelay server where is it decoded. 

From there, the original request is sent on to the original destination API. Any response will follow the same path in reverse.
<br>

This project is a starting point for a Flutter [plug-in package](https://flutter.dev/to/develop-plugins), a specialized Eclypses MteRelay Client package that includes platform-specific implementation code for Android and iOS. To be useful, this Plugin requires licensed access to an MteRelay server instance. 

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<br>

## Before You Begin

Ensure you have the following ready before integrating this plugin:

- [ ] **MteRelay Server Access** - A running MteRelay server instance with your server URL
- [ ] **Flutter SDK** - Latest stable version installed (`flutter --version` to check)
- [ ] **Xcode** - Latest version for iOS development (macOS only)
- [ ] **CocoaPods** - Installed and updated (`sudo gem install cocoapods`)
- [ ] **Android Studio** - For Android development with SDK tools installed

> 💡 **Tip:** Run `flutter doctor` to verify your development environment is properly configured.

<br>

## Add MteRelay Client Flutter Plugin to your application

### Step 1: Add the Plugin Dependency

This MteRelay Client Flutter Plugin is not published on pub.dev. Add it directly from GitHub by editing your `pubspec.yaml` file:

> ⚠️ **Important:** YAML indentation is critical! Use exactly 2 or 4 spaces (be consistent), never tabs.

```yaml
dependencies:
  flutter:
    sdk: flutter
  mte_relay_client_plugin:
    git:
      url: https://github.com/Eclypses/mte-relay-client-flutter-pod.git
      ref: 4.3.1
```

> ⚠️ **iOS Requirement:** This plugin requires iOS 16.0 or greater. See the [iOS Integration Guide](iosIntegrationGuide.md) for detailed CocoaPods setup instructions.

### Step 2: Install Dependencies

In a terminal at the root directory of your project:

```bash
flutter pub get
```

This downloads the MteRelay Client Plugin to your project.

### Step 3: Import the Plugin

In the file where you'll use the MteRelay plugin, add these imports:

```dart
import 'dart:convert';           // For JSON encoding/decoding
import 'dart:typed_data';        // For Uint8List handling
import 'package:flutter/services.dart';  // For PlatformException
import 'package:mte_relay_client_plugin/mte_relay_client_plugin.dart';
import 'package:mte_relay_client_plugin/mte_relay_response_model.dart';
import 'package:mte_relay_client_plugin/mte_relay_native_response.dart';
```

### Step 4: Create a Plugin Instance

Create a class-level variable to store the reference to the plugin:

```dart
final _mteRelayClientPlugin = MteRelayClientPlugin();   
```

### Step 5: Initialize the Relay

When your class is instantiated, set up the Relay callbacks and initialize the Relay.

```dart
@override
  void initState() {
    super.initState();

      // Listen for responses from the plugin
      _mteRelayClientPlugin.relayResponseStream.listen((message) {
          // Deal appropriately with response message 
      });

      // These 3 callbacks are only necessary for file streaming uploads and downloads
      _mteRelayClientPlugin.relayStreamResponseStream.listen((args) {

      // Deal appropriately with response args. Here is some sample code
      bool success = args['success'] as bool;
       int statusCode = args['statusCode'] as int;
      Uint8List? data = args['data'] as Uint8List?;
      String? relayError = args["relayError"] as String?;
      String? pluginError = args["pluginError"] as String?;

      Map<String, String>? headers;
      if (args["headers"] != null && args["headers"] is Map) {
          headers = (args["headers"] as Map).map(
            (key, value) => MapEntry(key.toString(), value.toString()),
        );
      } else {
        headers = null;
      }

      if (data != null) {
        try {
          final dynamic jsonObject = json.decode(utf8.decode(data));
          String formattedJson = JsonEncoder.withIndent(
            '  ',
          ).convert(jsonObject);
        } catch (e) {
          // Deal with Exception appropriately
        }
      }
        });

        _mteRelayClientPlugin.relayRequestChunksStream.listen((streamID) {
        startSendingChunks(streamID); // Start sending chunks
        });

        _mteRelayClientPlugin.relayStreamCompletionStream.listen((progressStr) {
        double? progress = double.tryParse(progressStr);
        _updateProgress(progress ?? 0);
        });

        initializeRelay();
    }

  Future<void> initializeRelay() async {

    try {
      await _mteRelayClientPlugin.initializeRelay();
      responseMessage = "Relay Initialized";
    } on PlatformException {
      responseMessage = 'Failed to initialize Relay.';
    }
    // Deal appropriately with response message
  }
```

### Step 6: Make API Calls

Create arguments and call Plugin methods. Here's a sample POST request:

```dart
// This is a sample POST request
Future<void> login() async {
    final body = jsonEncode({"email": "user@example.com", "password": "password!"});
    
    // Define which headers should be encrypted (Content-Type is always encrypted if present)
    final headersToEncrypt = ['Content-Type', 'Authorization'];
    
    try {
      final dynamic args = {
        'url': "https://your-relay-server.com",  // Your MteRelay server URL
        'pathnamePrefix': null,  // Optional: Use a string like "/api/v1" if your architecture requires an unencrypted prefix
        'route': "/api/login",   // This route WILL be encrypted
        'method': 'POST',
        'headers': {'Content-Type': 'application/json'},
        'headersToEncrypt': headersToEncrypt,
        'body': body,
      };
       Map<dynamic, dynamic> response = await _mteRelayClientPlugin
          .relayDataTask(args);
```

---

## Response Handling

The plugin provides two classes for handling responses. Choose based on your needs:

| Class | Body Data Type | Best For |
|-------|----------------|----------|
| `Result<T>` | `T?` (generic) | Flexible data handling, when you want type inference |
| `NativeHttpResponse` | `Uint8List?` | When you need raw bytes directly |

Both classes provide these common properties:
- `isSuccess` - Boolean indicating if the request succeeded
- `statusCode` - HTTP status code (e.g., 200, 404)
- `headers` - Response headers as `Map<String, String>?`
- `errorMessage` - Error description if request failed
- `bodyAsString` - Convenience getter to convert body to String
- `bodyAsJsonObject` - Convenience getter to parse body as JSON

### Option 1: Using Result<T>

```dart
// Parse the response map into a Result object
final result = Result.fromMap(response);

// Check for errors
if (!result.isSuccess) {
  print('Error: ${result.errorMessage}');
  return;
}

// Access the response data
final bodyString = result.bodyAsString;        // Body as String (empty if null)
final bodyJson = result.bodyAsJsonObject;      // Body as parsed JSON (null if invalid)
int? statusCode = result.statusCode;           // HTTP status code
String? dateHeader = result.headers?['Date'];  // Access specific header
```

### Option 2: Using NativeHttpResponse

```dart
// Parse the response map into a NativeHttpResponse object  
final nativeResponse = NativeHttpResponse.fromMap(response);

// Check for errors
if (!nativeResponse.isSuccess) {
  print('Error: ${nativeResponse.errorMessage}');
  return;
}

// Access the response data (body is Uint8List?)
Uint8List rawBytes = nativeResponse.safeData;         // Body as bytes (empty if null)
final dataString = nativeResponse.bodyAsString;       // Body as String
final dataJson = nativeResponse.bodyAsJsonObject;     // Body as parsed JSON

// Access metadata
int? statusCode = nativeResponse.statusCode;
String? dateHeader = nativeResponse.headers?['Date'];
```

### Complete Example

```dart
Future<void> login() async {
  final body = jsonEncode({"email": "user@example.com", "password": "P@ssw0rd!"});
  
  try {
    final args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,
      'route': "/api/login",
      'method': 'POST',
      'headers': {'Content-Type': 'application/json'},
      'headersToEncrypt': ['Content-Type'],
      'body': body,
    };
    
    Map<dynamic, dynamic> response = await _mteRelayClientPlugin.relayDataTask(args);
    
    final result = Result.fromMap(response);
    
    if (result.isSuccess) {
      final jsonData = result.bodyAsJsonObject;
      print('Login successful: $jsonData');
    } else {
      print('Login failed: ${result.errorMessage}');
    }
    
  } on PlatformException catch (e) {
    print('Platform error: ${e.message}');
  } catch (error) {
    print('Unexpected error: $error');
  }
}

---

## API Reference

### File Stream Upload

For large file uploads, use streaming to avoid memory issues:

```dart
// Sample FileStream Upload
// See the Example project in this plugin for complete implementation including MultipartHelper class
Future<void> uploadFileStream(String filesize) async {
  File file = await getFileToUpload(filesize);  // Your method to get the file
  String filename = file.path.split(Platform.pathSeparator).last;

  // MultipartHelper is provided in the Example project's lib/multipart_helper.dart
  builder = MultipartHelper(filename);

  String contentTypeHeader =
      'multipart/form-data; boundary=${builder.boundary}';
  int contentLength = await builder.calculateContentLength(file);

  final dynamic args = {
    'url': relayServerUrl,
    'pathnamePrefix': null,  // Optional: unencrypted path prefix
    'route': "/api/files/upload",  // This route WILL be encrypted
    'method': 'POST',
    'headers': {
      'Content-Type': contentTypeHeader,
      'Content-Length': contentLength.toString(),
    },
    'headersToEncrypt': headersToEncrypt,
  };

  String result = await _mteRelayClientPlugin.relayUploadFile(args);
  // Response arrives via relayStreamResponseStream callback (set up in Step 5)
}
```

### File Stream Download

```dart
// Sample FileStream download
Future<void> downloadFileStream() async {
  String filename = "example.pdf";  // The filename to download
  final urlEncodedFilename = Uri.encodeComponent(filename);
  final downloadLocation = await getDownloadLocation(filename);  // Your method to get save path
  
  print("Download Location: $downloadLocation");
  
  try {
    final arguments = {
      'url': relayServerUrl,
      'pathnamePrefix': null,  // Optional: unencrypted path prefix
      'route': "/api/files/download/stream/$urlEncodedFilename",  // Encrypted route
      'method': 'GET',
      'headers': {'Content-Type': 'application/json'},
      'headersToEncrypt': headersToEncrypt,
      'downloadLocation': downloadLocation,  // Local path where file will be saved
    };
    
    String result = await _mteRelayClientPlugin.relayDownloadFile(arguments);
    // Response arrives via relayStreamResponseStream callback
  } catch (error) {
    print('Download failed: $error');
  }
}
```

### Manual Re-Pairing

If a network call fails due to an MteRelay issue, automatic re-pair/retry occurs once. Use this method for manual re-pairing:

```dart
Future<void> rePair() async {
  try {
    final dynamic args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,  // Optional: unencrypted path prefix
    };
    String result = await _mteRelayClientPlugin.rePair(args);
    print('Re-pair result: $result');
  } catch (error) {
    print('Re-pair failed: $error');
  }
}
```

### Adjusting Relay Settings

Customize MteRelay settings if defaults don't fit your needs. Call this right after `initializeRelay()` to always use custom settings:

```dart
Future<void> adjustRelaySettings() async {
  try {
    final dynamic args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,  // Optional: unencrypted path prefix
      // Only include settings you want to change; others keep current values
      'streamChunkSize': 1024 * 1024,  // Chunk size for streaming (default: 1MB)
      'pairPoolSize': 3,               // Number of MTE pairs to maintain (default: 3)
      'persistPairs': false,           // Save pairs across app restarts (default: false)
    };
    String result = await _mteRelayClientPlugin.adjustRelaySettings(args);
    print('Settings adjusted: $result');
  } catch (error) {
    print('Failed to adjust settings: $error');
  }
}
```

> 💡 **Note:** Adjusting settings triggers an automatic re-pair so future transmissions use the new configuration.

### Native Logging

Enable file logging for debugging MteRelay operations:

```dart
// Enable or disable file logging
Future<void> enableFileLogging(bool isEnabled) async {
  try {
    final dynamic args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,
      'isEnabled': isEnabled,
    };
    String result = await _mteRelayClientPlugin.enableFileLogging(args);
    print('Logging ${isEnabled ? "enabled" : "disabled"}: $result');
  } catch (error) {
    print('Failed to toggle logging: $error');
  }
}

// Read the current log file contents
Future<void> readLogFile() async {
  try {
    final dynamic args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,
    };
    String result = await _mteRelayClientPlugin.readLogFile(args);
    print('Log contents:\n$result');
  } catch (error) {
    print('Failed to read log: $error');
  }
}

// Clear the log file
Future<void> clearLogFile() async {
  try {
    final dynamic args = {
      'url': relayServerUrl,
      'pathnamePrefix': null,
    };
    String result = await _mteRelayClientPlugin.clearLogFile(args);
    print('Log cleared: $result');
  } catch (error) {
    print('Failed to clear log: $error');
  }
}
```

---

## Troubleshooting

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `PlatformException` | Native code issue | Check that iOS/Android native setup is complete |
| `Failed to initialize Relay` | Server unreachable | Verify your `relayServerUrl` is correct and server is running |
| `MteRelay server not found` | Pairing failed | Check network connectivity and server configuration |
| Build fails on iOS | CocoaPods issue | See [iOS Integration Guide](iosIntegrationGuide.md) |

### Need More Help?

Refer to the **Example project** included in this plugin for complete, working implementations of all features.

---

<div style="page-break-after: always; break-after: page;"></div>

# Contact Eclypses

<p align="center" style="font-weight: bold; font-size: 20pt;">Email: <a href="mailto:info@eclypses.com">info@eclypses.com</a></p>
<p align="center" style="font-weight: bold; font-size: 20pt;">Web: <a href="https://www.eclypses.com">www.eclypses.com</a></p>
<p align="center" style="font-weight: bold; font-size: 20pt;">Chat with us: <a href="https://developers.eclypses.com/dashboard">Developer Portal</a></p>
<p style="font-size: 8pt; margin-bottom: 0; margin: 100px 24px 30px 24px; " >
<b>All trademarks of Eclypses Inc.</b> may not be used without Eclypses Inc.'s prior written consent. No license for any use thereof has been granted without express written consent. Any unauthorized use thereof may violate copyright laws, trademark laws, privacy and publicity laws and communications regulations and statutes. The names, images and likeness of the Eclypses logo, along with all representations thereof, are valuable intellectual property assets of Eclypses, Inc. Accordingly, no party or parties, without the prior written consent of Eclypses, Inc., (which may be withheld in Eclypses' sole discretion), use or permit the use of any of the Eclypses trademarked names or logos of Eclypses, Inc. for any purpose other than as part of the address for the Premises, or use or permit the use of, for any purpose whatsoever, any image or rendering of, or any design based on, the exterior appearance or profile of the Eclypses trademarks and or logo(s).
</p>