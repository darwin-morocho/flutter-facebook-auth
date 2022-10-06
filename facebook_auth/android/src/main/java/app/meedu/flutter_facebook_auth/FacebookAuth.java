package app.meedu.flutter_facebook_auth;

import android.app.Activity;
import android.os.Bundle;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.LoginStatusCallback;
import com.facebook.login.LoginBehavior;
import com.facebook.login.LoginManager;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class FacebookAuth {
  private final LoginManager loginManager;
  FacebookLoginResultDelegate resultDelegate;

  FacebookAuth() {
    loginManager = LoginManager.getInstance();
    CallbackManager callbackManager = CallbackManager.Factory.create();
    resultDelegate = new FacebookLoginResultDelegate(callbackManager);
    loginManager.registerCallback(callbackManager, resultDelegate);
  }

  /**
   * makes an login request using the facebook sdk
   *
   * @param activity the android activity to handle onActivityResult event
   * @param permissions list of permissions
   * @param result flutter method channel result to send the response to the client
   */
  void login(Activity activity, List<String> permissions, MethodChannel.Result result) {
    final boolean hasPreviousSession = AccessToken.getCurrentAccessToken() != null;
    if (hasPreviousSession) {
      loginManager.logOut();
    }
    final boolean isOk = resultDelegate.setPendingResult(result);
    if (isOk) {
      loginManager.logIn(activity, permissions);
    }
  }

  /**
   * set the login behavior to use native app, webview, dialogs, etc
   *
   * @param behavior string that defines the ui type for login
   */
  public void setLoginBehavior(String behavior) {
    LoginBehavior loginBehavior;
    switch (behavior) {
      case "NATIVE_ONLY":
        loginBehavior = LoginBehavior.NATIVE_ONLY;
        break;
      case "KATANA_ONLY":
        loginBehavior = LoginBehavior.KATANA_ONLY;
        break;
      case "DIALOG_ONLY":
        loginBehavior = LoginBehavior.DIALOG_ONLY;
        break;
      case "DEVICE_AUTH":
        loginBehavior = LoginBehavior.DEVICE_AUTH;
        break;
      case "WEB_ONLY":
        loginBehavior =  LoginBehavior.WEB_ONLY;
        break;
        
      default:
        loginBehavior = LoginBehavior.NATIVE_WITH_FALLBACK;
    }

    loginManager.setLoginBehavior(loginBehavior);
  }

  /**
   * Gets current access token, if one exists
   *
   * @param result flutter method channel result to send the response to the client
   */
  public void getAccessToken(MethodChannel.Result result) {
    AccessToken accessToken = AccessToken.getCurrentAccessToken();
    boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
    if (isLoggedIn) {
      HashMap<String, Object> data = getAccessToken(AccessToken.getCurrentAccessToken());
      result.success(data);
    } else {
      result.success(null);
    }
  }

  /**
   * close the current facebook session
   *
   * @param result flutter method channel result to send the response to the client
   */
  void logOut(MethodChannel.Result result) {
    final boolean hasPreviousSession = AccessToken.getCurrentAccessToken() != null;
    if (hasPreviousSession) {
      loginManager.logOut();
    }
    result.success(null);
  }

  /**
   * Enable Express Login
   *
   * @param activity
   * @param result flutter method channel result to send the response to the client
   */
  void expressLogin(Activity activity, final MethodChannel.Result result) {
    LoginManager.getInstance()
        .retrieveLoginStatus(
            activity,
            new LoginStatusCallback() {
              @Override
              public void onCompleted(AccessToken accessToken) {
                // User was previously logged in, can log them in directly here.
                // If this callback is called, a popup notification appears that says
                // "Logged in as <User Name>"
                HashMap<String, Object> data = getAccessToken(accessToken);
                result.success(data);
              }

              @Override
              public void onFailure() {
                // No access token could be retrieved for the user
                result.error("CANCELLED", "User has cancelled login with facebook", null);
              }

              @Override
              public void onError(Exception e) {
                // An error occurred
                result.error("FAILED", e.getMessage(), null);
              }
            });
  }

  /**
   * Get the facebook user data
   *
   * @param fields string of fields like "name,email,picture"
   * @param result flutter method channel result to send the response to the client
   */
  public void getUserData(String fields, final MethodChannel.Result result) {
    GraphRequest request =
        GraphRequest.newMeRequest(
            AccessToken.getCurrentAccessToken(),
            new GraphRequest.GraphJSONObjectCallback() {
              @Override
              public void onCompleted(JSONObject object, GraphResponse response) {
                try {
                  result.success(object.toString());
                } catch (Exception e) {
                  result.error("FAILED", e.getMessage(), null);
                }
              }
            });
    Bundle parameters = new Bundle();
    parameters.putString("fields", fields);
    request.setParameters(parameters);
    request.executeAsync();
  }

  /**
   * @param accessToken an instance of Facebook SDK AccessToken
   * @return a HashMap data
   */
  static HashMap<String, Object> getAccessToken(final AccessToken accessToken) {
    return new HashMap<String, Object>() {
      {
        put("token", accessToken.getToken());
        put("userId", accessToken.getUserId());
        put("expires", accessToken.getExpires().getTime());
        put("applicationId", accessToken.getApplicationId());
        put("lastRefresh", accessToken.getLastRefresh().getTime());
        put("isExpired", accessToken.isExpired());
        put("grantedPermissions", new ArrayList<>(accessToken.getPermissions()));
        put("declinedPermissions", new ArrayList<>(accessToken.getDeclinedPermissions()));
        put("dataAccessExpirationTime", accessToken.getDataAccessExpirationTime().getTime());
      }
    };
  }
}
