var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var _this = this;
var FACEBOOK_APP_ID = "APP_ID";
var FB = {};
/**
 * get granted and declined Permissions
 */
var getGrantedAndDeclinedPermissions = function () {
    return new Promise(function (resolve) {
        FB.api("/me/permissions", function (response) {
            var declined = [];
            var granted = [];
            for (var i = 0; i < response.data.length; i++) {
                var item = response.data[i];
                if (item.status == "declined") {
                    declined.push(item.permission);
                }
                else {
                    granted.push(item.permission);
                }
            }
            resolve({ granted: granted, declined: declined });
        });
    });
};
var handleAuthResponse = function (response, resolve) { return __awaiter(_this, void 0, void 0, function () {
    var status, _a, _b, accessToken, userID, expiresIn, graphDomain, data_access_expiration_time, _c, granted, declined, res;
    return __generator(this, function (_d) {
        switch (_d.label) {
            case 0:
                status = response.status;
                _a = status;
                switch (_a) {
                    case "connected": return [3 /*break*/, 1];
                    case "not_authorized": return [3 /*break*/, 3];
                }
                return [3 /*break*/, 4];
            case 1:
                _b = response.authResponse, accessToken = _b.accessToken, userID = _b.userID, expiresIn = _b.expiresIn, graphDomain = _b.graphDomain, data_access_expiration_time = _b.data_access_expiration_time;
                return [4 /*yield*/, getGrantedAndDeclinedPermissions()];
            case 2:
                _c = _d.sent(), granted = _c.granted, declined = _c.declined;
                res = {
                    status: "connected",
                    accessToken: {
                        token: accessToken,
                        userId: userID,
                        expiresIn: expiresIn,
                        graphDomain: graphDomain,
                        data_access_expiration_time: data_access_expiration_time,
                        grantedPermissions: granted,
                        declinedPermissions: declined,
                        applicationId: FACEBOOK_APP_ID
                    }
                };
                resolve(res);
                return [3 /*break*/, 5];
            case 3:
                resolve({
                    status: "not_authorized"
                });
                return [3 /*break*/, 5];
            case 4:
                resolve({
                    status: "unknown"
                });
                _d.label = 5;
            case 5: return [2 /*return*/];
        }
    });
}); };
var FacebookAuth = /** @class */ (function () {
    function FacebookAuth() {
    }
    FacebookAuth.prototype.login = function (scope) {
        return new Promise(function (resolve) {
            FB.login(function (response) {
                handleAuthResponse(response, resolve);
            }, { scope: scope });
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
    return FacebookAuth;
}());
