#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_facebook_auth.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_facebook_auth'
  s.version          = '7.1.5'
  s.summary          = 'Plugin to Facebook authentication for iOS in your Flutter app'
  s.description      = <<-DESC
  Plugin to Facebook authentication for iOS in your Flutter app
                       DESC
  s.homepage         = 'https://meedu.app'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'meedu.app' => 'contacto@meedu.app' }
  s.source           = { :path => '.' }
  # Sources now live under the Swift-Package layout
  # (ios/flutter_facebook_auth/Sources/...). CocoaPods consumers see
  # the same files from this relative path, so no behavior change.
  s.source_files = 'flutter_facebook_auth/Sources/flutter_facebook_auth/**/*.{h,m,swift}'
  s.public_header_files = 'flutter_facebook_auth/Sources/flutter_facebook_auth/include/flutter_facebook_auth/*.h'
  s.dependency 'Flutter'


  # s.dependency 'FBSDKCoreKit', '~> 15.1.0'
  s.dependency 'FBSDKLoginKit', '18.1.1'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
