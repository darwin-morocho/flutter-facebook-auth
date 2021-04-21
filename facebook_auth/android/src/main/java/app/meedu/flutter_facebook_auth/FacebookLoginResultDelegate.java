package app.meedu.flutter_facebook_auth;


import android.content.Intent;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginResult;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class FacebookLoginResultDelegate implements FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {
    private final CallbackManager callbackManager;
    private MethodChannel.Result pendingResult;


    FacebookLoginResultDelegate(CallbackManager callbackManager) {
        this.callbackManager = callbackManager;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onSuccess(LoginResult loginResult) {
        final HashMap<String, Object> accessToken = FacebookAuth.getAccessToken(loginResult.getAccessToken());
        finishWithResult(accessToken);// send response to the client
    }

    @Override
    public void onCancel() {
        finishWithError("CANCELLED", "User has cancelled login with facebook");
    }

    @Override
    public void onError(FacebookException error) {
        finishWithError("FAILED", error.getMessage());
    }

    void finishWithError(String errorCode, String message) {
        if (pendingResult != null) {
            pendingResult.error(errorCode, message, null);
            pendingResult = null;
        }
    }


    boolean setPendingResult(MethodChannel.Result result) {
        if (pendingResult != null) {
            result.error("OPERATION_IN_PROGRESS",
                    "The method login was called while another Facebook " +
                            "operation was in progress.",
                    null
            );
            return false;
        }
        pendingResult = result;
        return true;
    }


    void finishWithResult(Object result) {
        if (pendingResult != null) {
            pendingResult.success(result);
            pendingResult = null;
        }
    }
}