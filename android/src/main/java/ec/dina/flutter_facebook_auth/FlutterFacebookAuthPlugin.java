package ec.dina.flutter_facebook_auth;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;




/**
 * FlutterFacebookAuthPlugin
 */
public class FlutterFacebookAuthPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {

    private static final String CHANNEL_NAME = "ec.dina/flutter_facebook_auth";


    private FacebookAuth facebookAuth = new FacebookAuth();
    private ActivityPluginBinding activityPluginBinding;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        Log.i("facebook:", "registerWith");
        FlutterFacebookAuthPlugin plugin = new FlutterFacebookAuthPlugin();
        plugin.onAttachedToEngine(registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.i("facebook:", "onAttachedToEngine");
        this.onAttachedToEngine(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void onAttachedToEngine(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "login":
                List<String> permissions = call.argument("permissions");
                facebookAuth.login(this.activityPluginBinding.getActivity(), permissions, result);
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

    private void attachToActivity(ActivityPluginBinding binding) {
        this.activityPluginBinding = binding;
        activityPluginBinding.addActivityResultListener(facebookAuth.resultDelegate);
    }

    private void disposeActivity() {
        activityPluginBinding.removeActivityResultListener(facebookAuth.resultDelegate);
        // delegate.setActivity(null);
        activityPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.attachToActivity(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        disposeActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.attachToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        disposeActivity();
    }
}
