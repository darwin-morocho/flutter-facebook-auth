#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
    s.name             = 'flutter_facebook_auth_web'
    s.version          = '1.0.0'
    s.summary          = 'No-op implementation of flutter_facebook_auth_web web plugin to avoid build issues on iOS'
    s.description      = <<-DESC
    web support for flutter_facebook_auth
                         DESC
    s.homepage         = 'https://github.com/darwin-morocho/flutter-facebook-auth/tree/master/flutter_facebook_auth_web'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Darwin Morocho' => 'darwin.morocho@icloud.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'
  
    s.ios.deployment_target = '9.0'
  end