#import "FacebookAuthPlugin.h"
#if __has_include(<facebook_auth/facebook_auth-Swift.h>)
#import <facebook_auth/facebook_auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "facebook_auth-Swift.h"
#endif

@implementation FacebookAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookAuthPlugin registerWithRegistrar:registrar];
}
@end
