package ec.dina.flutter_facebook_auth;

import android.app.Activity;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterFacebookAuthPlugin
 */
public class FlutterFacebookAuthPlugin implements MethodCallHandler {


    private FacebookAuth facebookAuth;

    FlutterFacebookAuthPlugin(Registrar registrar) {
        facebookAuth = new FacebookAuth(registrar);
    }


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_facebook_auth");
        channel.setMethodCallHandler(new FlutterFacebookAuthPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        switch (call.method) {
            case "login":
                List<String> permissions = call.argument("permissions");
                facebookAuth.login(permissions, result);
                break;

            case "isLogged":
                facebookAuth.isLogged(result);
                break;

            case "getUserData":
                String fields = call.argument("fields");
                facebookAuth.getUserData(fields, result);
                break;

            case "logOut":
                facebookAuth.logOut(result);
                break;

            default:
                result.notImplemented();
        }

    }


}
