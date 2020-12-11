const FACEBOOK_APP_ID = "APP_ID";

const FB: any = {};

interface AuthResponse {
  status: string;
  accessToken?: {
    token: string;
    userId: string;
    expiresIn: number;
    graphDomain: string;
    data_access_expiration_time: number;
    grantedPermissions: string[];
    declinedPermissions: string[];
    applicationId: string;
  };
}

/**
 * get granted and declined Permissions
 */
const getGrantedAndDeclinedPermissions = (): Promise<{ granted: string[]; declined: string[] }> => {
  return new Promise<{ granted: string[]; declined: string[] }>((resolve) => {
    FB.api("/me/permissions", function (response) {
      const declined = [];
      const granted = [];
      for (let i = 0; i < response.data.length; i++) {
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
};

const handleAuthResponse = async (
  response: any,
  resolve: (value: AuthResponse | PromiseLike<AuthResponse>) => void
): Promise<void> => {
  const status = response.status;
  switch (status) {
    case "connected":
      const { accessToken, userID, expiresIn, graphDomain, data_access_expiration_time } = response.authResponse;

      const { granted, declined } = await getGrantedAndDeclinedPermissions();
      const res: AuthResponse = {
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
      };
      resolve(res);

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
};

class FacebookAuth {
  public login(scope: string): Promise<AuthResponse> {
    return new Promise<AuthResponse>((resolve) => {
      FB.login(
        (response) => {
          handleAuthResponse(response, resolve);
        },
        { scope: scope }
      );
    });
  }

  public isLogged(): Promise<any> {
    return new Promise((resolve) => {
      FB.getLoginStatus(function (response) {
        handleAuthResponse(response, resolve);
      });
    });
  }

  public getUserData(fields: string): Promise<any> {
    return new Promise((resolve) => {
      FB.api("/me?fields=" + fields, function (response) {
        resolve(JSON.stringify(response));
      });
    });
  }
  public logout(): Promise<any> {
    return new Promise((resolve) => {
      FB.logout(function (response) {
        resolve(null);
      });
    });
  }
}
