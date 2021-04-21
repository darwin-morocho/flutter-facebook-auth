package app.meedu.flutter_facebook_auth;


import android.content.Intent;
import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookAuthorizationException;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class FacebookLoginResultDelegate implements FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {
    private final CallbackManager callbackManager;
    private MethodChannel.Result pendingResult;


    // this int will be used to check if the user has a previous session but with other
    // user if that is right we will logout and make a login request again
    private int intent = 0;


    public OnReLoginListener onReLoginListener;

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
        if (error instanceof FacebookAuthorizationException ) {
            // if the user has a previous session with other user
            final boolean prevSessionWithDifferentAccount = AccessToken.getCurrentAccessToken() != null;
            if (prevSessionWithDifferentAccount && intent == 0) {
                LoginManager.getInstance().logOut();// close the previous session
                if (this.onReLoginListener != null) {
                    this.onReLoginListener.onReLogin();
                    intent++;
                    return;
                }
            }
        }

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
        intent = 0;
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


interface OnReLoginListener {
    void onReLogin();
}