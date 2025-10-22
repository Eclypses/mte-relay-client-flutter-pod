# Changelog

All notable changes to this project will be documented in this file.

## [4.2.11] - 2025-09-30

### Added 

### Changed
- Fixed crash when Volley response contains no NetworkResponse

[4.2.11]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.11

## [4.2.10] - 2025-09-05

### Added 

### Changed
- Updated mte_relay_client_plugin.java to remove unneeded Override
- Updated pubspec.yaml to pull updated MteRelay library
- Updated Version number throughout

[4.2.10]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.10

## [4.2.9] - 2025-09-04

### Added 

### Changed
- Updated mte_relay_client_plugin.podspec to reference multiple MteRelay submodule dependencies
- Updated Version number throughout

[4.2.9]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.9

## [4.2.8] - 2025-09-03

### Added 

### Changed
- Updated mte_relay_client_plugin.podspec to reflect updated MteRelay for iOS
- Updated Version number throughout

[4.2.8]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.8

## [4.2.7] - 2025-09-03

### Added 

### Changed
- Updated mte_relay_client_plugin.podspec
- Updated Version number throughout

[4.2.7]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.7

## [4.2.6] - 2025-09-02

### Added 
- Added iOS Integration Guide

### Changed
- Updated Version number throughout

[4.2.6]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.6

## [4.2.5] - 2025-09-02

### Added 

### Changed
- Updated Version number in README.mdl

[4.2.5]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.5

## [4.2.4] - 2025-09-02

### Added 

### Changed
- Updated Version number in pubspec.yaml

[4.2.4]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.4

## [4.2.3] - 2025-08-27

### Added 

### Changed
- Updated Version number in pubspec.yaml
- Removed escape characters from Android Response Body Json
- Removed square brackets from Android Response Headers
- Upgraded iOS Relay Package which downgraded iOS Target from v16 to v14

[4.2.3]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.3
<br><br>

## [4.2.2] - 2025-05-21

### Added
- Added convenience getters to Result class
- Added NativeHttpResponse class to map responses from Native code. 

### Changed
- Updated Version number in pubspec.yaml

[4.2.2]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.2
<br><br>

## [4.2.1] - 2025-05-21

### Added
 

### Changed
- Updated README to correct method signatures
- Updated Version number in pubspec.yaml
- Various minor bug fixes

### Fixed
- Reurning 'Result' for logging methods

[4.2.1]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.1
<br><br>

## [4.2.0] - 2025-05-17

### Added
- Added Native Logging To File, available to Flutter (work in progress)
- Added Native http response StatusCode values to result object and FileStreamResponseStream arguments. 

### Changed
- Set Native default pairPoolSize to 5.

### Fixed
- Swift - Fixed null exception where we tried to remove non-existant storedHost.
- Removed debug comments

[4.2.0]: https://github.com/Eclypses/eclypses-aws-mte-relay-client-ios/releases/tag/4.2.0
<br><br>
## 1.0.0

* Initial Release. iOS plugin calls are working. Android not yet implemented.
