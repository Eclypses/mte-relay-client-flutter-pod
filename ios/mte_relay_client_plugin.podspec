Pod::Spec.new do |s|
  s.name             = 'mte_relay_client_plugin'
  s.version          = '4.3.1'
  s.summary          = 'Flutter plugin for Eclypses MTE Relay Client'
  s.description      = <<-DESC
                        Flutter plugin for the Eclypses MteRelay Client.
                        Provides iOS integration for HTTP MteRelay functionality,
                        bridging the Flutter layer with the native MteRelay library.
                       DESC
  s.homepage         = 'https://github.com/Eclypses/mte-relay-client-flutter-pod'
  s.license          = { :type => 'MIT', :text => 'See LICENSE in repo' }
  s.author           = { 'Eclypses' => 'support@eclypses.com' }

  s.platform         = :ios, '16.0'
  s.swift_versions   = ['5.7', '5.8', '5.9']

  s.source           = { :git => 'https://github.com/Eclypses/mte-relay-client-flutter-pod.git', :tag => s.version.to_s }

  # Flutter plugin Swift sources (plugin interface)
  s.source_files = 'Sources/mte_relay_client_plugin/**/*.{swift,h}'

  # Dependency on the native relay client
  s.dependency 'MteRelay', '~> 4.4'

  # Flutter integration (lets CocoaPods know it’s a Flutter plugin)
  s.dependency 'Flutter'

  s.ios.deployment_target = '16.0'
end
