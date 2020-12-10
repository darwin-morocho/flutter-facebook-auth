window.fbAsyncInit = function () {
  FB.init({
    appId: FACEBOOK_APP_ID,
    cookie: true,
    xfbml: true,
    version: "v9.0",
  });

  FB.AppEvents.logPageView();
};

(function (d, s, id) {
  var js,
    fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {
    return;
  }
  js = d.createElement(s);
  js.id = id;
  js.src = "https://connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
})(document, "script", "facebook-jssdk");

/**
 * get granted and declined Permissions
 */
function getGrantedAndDeclinedPermissions() {
  return new Promise((resolve) => {
    FB.api("/me/permissions", function (response) {
      const declined = [];
      const granted = [];
      for (i = 0; i < response.data.length; i++) {
        const item = response.data[i];
        if (item.status == "declined") {
          declined.push(item.permission);
        } else {
          granted.push(item.permission);
        }
      }
      resolve({ granted, declined });
    });
  });
}

/**
 * handle the login /loginStatus response
 * @param {Object} response
 */
function handleAuthResponse(response, resolve) {
  const status = response.status;
  switch (status) {
    case "connected":
      const { accessToken, userID, expiresIn, graphDomain, data_access_expiration_time } = response.authResponse;
      getGrantedAndDeclinedPermissions().then((data) => {
        const { granted, declined } = data;
        resolve({
          status: "connected",
          accessToken: {
            token: accessToken,
            userId: userID,
            expiresIn,
            graphDomain,
            data_access_expiration_time,
            grantedPermissions: granted,
            declinedPermissions: declined,
            applicationId: FACEBOOK_APP_ID,
          },
        });
      });

      break;
    case "not_authorized":
      resolve({
        status: "not_authorized",
      });
      break;

    default:
      resolve({
        status: "unknown",
      });
  }
}

function FacebookAuth() {
  /**
   * makes an API request to login with facebook
   * @param {string} scope (example: 'public_profile,email')
   */
  FacebookAuth.prototype.login = function (scope) {
    return new Promise(async (resolve) => {
      FB.login(
        (response) => {
          handleAuthResponse(response, resolve);
        },
        { scope: scope }
      );
    });
  };

  FacebookAuth.prototype.isLogged = function () {
    return new Promise((resolve) => {
      FB.getLoginStatus(function (response) {
        console.log("loginStatus", response);
        handleAuthResponse(response, resolve);
      });
    });
  };

  FacebookAuth.prototype.getUserData = function (fields) {
    return new Promise((resolve) => {
      FB.api("/me?fields=" + fields, function (response) {
        console.log("me response", response);
        resolve(JSON.stringify(response));
      });
    });
  };

  /**
   * Close the current facebook sesion
   */
  FacebookAuth.prototype.logout = function () {
    return new Promise((resolve) => {
      FB.logout(function (response) {
        resolve(null);
      });
    });
  };
}
