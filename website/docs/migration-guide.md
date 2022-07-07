# Migration guide

if you are upgrading from a previous version of this plugin maybe you need to 
run the next commands to upgrade the native dependencies.

```
flutter clean
flutter pub get
```
Next for ios 
```
cd ios
pod update flutter_facebook_auth
```