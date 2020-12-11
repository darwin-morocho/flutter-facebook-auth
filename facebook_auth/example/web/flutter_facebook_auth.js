/**
 * get granted and declined Permissions
 */
var getGrantedAndDeclinedPermissions = function (cb) {
  FB.api("/me/permissions", function (response) {
    var declined = [];
    var granted = [];
    for (var i = 0; i < response.data.length; i++) {
      var item = response.data[i];
      if (item.status == "declined") {
        declined.push(item.permission);
      } else {
        granted.push(item.permission);
      }
    }
    cb({ granted: granted, declined: declined });
  });
};

/**
 * handle the login /loginStatus response
 * @param {Object} response
 */
var handleAuthResponse = function (response, resolve) {
  var status = response.status;
  switch (status) {
    case "connected":
      var accessToken = response.authResponse.accessToken;
      var userID = response.authResponse.userID;
      var expiresIn = response.authResponse.expiresIn;
      var graphDomain = response.authResponse.graphDomain;
      var data_access_expiration_time = response.authResponse.data_access_expiration_time;

      getGrantedAndDeclinedPermissions(function (data) {
        var granted = data.granted;
        var declined = data.declined;
        var granted = data.granted;
        var declined = data.declined;
        resolve(
          JSON.stringify({
            status: "connected",
            accessToken: {
              token: accessToken,
              userId: userID,
              expiresIn: expiresIn,
              graphDomain: graphDomain,
              data_access_expiration_time: data_access_expiration_time,
              grantedPermissions: granted,
              declinedPermissions: declined,
              applicationId: FACEBOOK_APP_ID,
            },
          })
        );
      });

      break;
    case "not_authorized":
      resolve(
        JSON.stringify({
          status: "not_authorized",
        })
      );
      break;

    default:
      resolve(
        JSON.stringify({
          status: "unknown",
        })
      );
  }
};

function FacebookAuth() {
  FacebookAuth.prototype.login = function (scope) {
    return new Promise(function (resolve) {
      FB.login(
        function (response) {
          handleAuthResponse(response, resolve);
        },
        { scope: scope }
      );
    });
  };

  FacebookAuth.prototype.isLogged = function () {
    return new Promise(function (resolve) {
      FB.getLoginStatus(function (response) {
        handleAuthResponse(response, resolve);
      });
    });
  };

  FacebookAuth.prototype.getUserData = function (fields) {
    return new Promise(function (resolve) {
      FB.api("/me?fields=" + fields, function (response) {
        resolve(JSON.stringify(response));
      });
    });
  };

  FacebookAuth.prototype.logout = function () {
    return new Promise(function (resolve) {
      FB.logout(function (response) {
        resolve(null);
      });
    });
  };
}
