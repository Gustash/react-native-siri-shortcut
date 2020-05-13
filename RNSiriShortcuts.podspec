require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNSiriShortcuts"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "9.0"
  s.swift_version = "5.2"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.source       = { :git => "https://github.com/Gustash/react-native-siri-shortcut.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m,swift}"

  s.dependency 'React'
end
