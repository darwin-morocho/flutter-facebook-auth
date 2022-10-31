<!-- ![image](https://user-images.githubusercontent.com/15864336/101827170-f5ce3180-3afd-11eb-9a60-5933a15f337b.png) -->

<p align="center">
  <a href="https://pub.dev/packages/flutter_facebook_auth"><img alt="pub version" src="https://img.shields.io/pub/v/flutter_facebook_auth?color=%2300b0ff&label=flutter_facebook_auth&style=flat-square"/></a>

  <img alt="last commit" src="https://img.shields.io/github/last-commit/the-meedu-app/flutter-facebook-auth?color=%23ffa000&style=flat-square"/>
  <a href="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth">
  <img src="https://codecov.io/gh/darwin-morocho/flutter-facebook-auth/branch/master/graph/badge.svg?token=XEXUNVP0UK"/>
  </a>
  <img alt="license" src="https://img.shields.io/github/license/the-meedu-app/flutter-facebook-auth?style=flat-square"/>
  <img alt="stars" src="https://img.shields.io/github/stars/the-meedu-app/flutter-facebook-auth?style=social"/>
</p>

<p>A plugin that easily adds Facebook authentication into you Flutter app. Feature includes getting user information, profile picture and more. This plugin also supports Web.</p>

## Features
- Login on iOS, Android, Web and macOS.
- Express login on Android.
- Granted and declined permissions.
- User information, picture profile and more.
- Provide an access token to make request to the Graph API.

## Install

Add the following to your `pubspec.yaml`


```yaml
dependencies:
  flutter_facebook_auth: ^5.0.1
```


:::danger IMPORTANT
Upon installation of this plugin, configuration is needed on Android before running the project again. If this is not done, an error of **No implementation found** would show because the Facebook SDK on Android would throw an Exception error if the configuration is not yet defined. This error also locks the other plugins in your project, so if the plugin is not yet needed, either remove it or comment it out from the pubspec.yaml file.
:::
