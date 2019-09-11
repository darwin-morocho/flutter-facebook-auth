#import "FlutterFacebookAuthPlugin.h"
#import <flutter_facebook_auth/flutter_facebook_auth-Swift.h>

@implementation FlutterFacebookAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFacebookAuthPlugin registerWithRegistrar:registrar];
}
@end
