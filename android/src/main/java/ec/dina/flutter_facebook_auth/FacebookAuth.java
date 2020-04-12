package ec.dina.flutter_facebook_auth;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FacebookAuth {


    private final CallbackManager callbackManager;
    private LoginManager loginManager;
    private Activity activity;
    private FacebookLoginResultDelegate resultDelegate;


    FacebookAuth(PluginRegistry.Registrar registrar) {
        this.activity = registrar.activity();
        loginManager = LoginManager.getInstance();
        callbackManager = CallbackManager.Factory.create();
        resultDelegate = new FacebookLoginResultDelegate(callbackManager);
        loginManager.registerCallback(callbackManager, resultDelegate);
        registrar.addActivityResultListener(resultDelegate);
    }


    public void login(List<String> permissions, MethodChannel.Result result) {
        boolean isOK = resultDelegate.setPendingResult("login", result);

        if (isOK) {
            loginManager.logIn(activity, permissions);
        }
    }


    public void isLogged(MethodChannel.Result result) {
        boolean isOK = resultDelegate.setPendingResult("isLogged", result);
        if (isOK) {
            if (AccessToken.isDataAccessActive()) {
                HashMap data = getAccessToken(AccessToken.getCurrentAccessToken());
                resultDelegate.finishWithResult(data);
            } else {
                resultDelegate.finishWithResult(null);
            }
        }


    }


    public void getUserData(String fileds, final MethodChannel.Result result) {

        boolean isOK = resultDelegate.setPendingResult("getUserData", result);
        if (isOK) {
            GraphRequest request = GraphRequest.newMeRequest(
                    AccessToken.getCurrentAccessToken(),
                    new GraphRequest.GraphJSONObjectCallback() {
                        @Override
                        public void onCompleted(JSONObject object, GraphResponse response) {
                            try {
                                resultDelegate.finishWithResult(object.toString());
                            } catch (Exception e) {
                                resultDelegate.finishWithError(e.getMessage());
                            }

                        }
                    });
            Bundle parameters = new Bundle();
            parameters.putString("fields", fileds);
            request.setParameters(parameters);
            request.executeAsync();
        }


    }


    public void logOut(MethodChannel.Result result) {

        boolean isOK = resultDelegate.setPendingResult("logOut", result);
        if (isOK) {
            loginManager.logOut();
            resultDelegate.finishWithResult(null);
        }

    }


    static HashMap getAccessToken(final AccessToken accessToken) {
        return new HashMap<String, Object>() {{
            put("token", accessToken.getToken());
            put("userId", accessToken.getUserId());
            put("expires", accessToken.getExpires().getTime());
        }};
    }


}


class FacebookLoginResultDelegate implements FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {
    private final CallbackManager callbackManager;
    private MethodChannel.Result pendingResult;

    FacebookLoginResultDelegate(CallbackManager callbackManager) {
        this.callbackManager = callbackManager;
    }

    @Override
    public void onSuccess(LoginResult loginResult) {
        HashMap<String, Object> res = new HashMap<>();
        res.put("status", 200);
        res.put("grantedPermissions", new ArrayList<>(loginResult.getRecentlyGrantedPermissions()));
        res.put("declinedPermissions", new ArrayList<>(loginResult.getRecentlyDeniedPermissions()));
        res.put("accessToken", FacebookAuth.getAccessToken(loginResult.getAccessToken()));
        finishWithResult(res);
    }

    @Override
    public void onCancel() {
        HashMap<String, Object> res = new HashMap<>();
        res.put("status", 403);
        finishWithResult(res);
    }

    @Override
    public void onError(FacebookException error) {
        finishWithError(error.getMessage());
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    boolean setPendingResult(String methodName, MethodChannel.Result result) {
        if (pendingResult != null) {
            result.error("500",
                    methodName + " called while another Facebook " +
                            "login operation was in progress.",
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


    void finishWithError(String message) {
        if (pendingResult != null) {
            pendingResult.error("500", message, null);
            pendingResult = null;
        }
    }

}