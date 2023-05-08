# Android configuration


:::danger IMPORTANT
Upon installation of this plugin, configuration is needed on Android before running the project again. If this is not done, an error of **No implementation found** would show because the Facebook SDK on Android would throw an Exception error if the configuration is not yet defined. This error also locks the other plugins in your project, so if the plugin is not yet needed, either remove it or comment it out from the pubspec.yaml file.
:::

:::danger IMPORTANT
Since the native facebook sdk 15.0.0 the `minSdkVersion` required is `21`.
You must go to `android/app/build.gradle` and define `minSdkVersion` to `21`
```
    defaultConfig {
        ...
        minSdkVersion 21
        targetSdkVersion 33
        ...
    }
```
:::



Go to [Facebook Login for Android - Quickstart](https://developers.facebook.com/docs/facebook-login/android/?locale=en)

1.  Select an App or Create a New App

<img src="https://user-images.githubusercontent.com/15864336/98711287-cedfdc80-2352-11eb-9eb3-761f43ba4f7e.png" />

2.  Skip the step 2 (Download the Facebook App)

3.  Skip the step 3 (Integrate the Facebook SDK)

4.  Edit **Your Resources and Manifest** add this config in your android project

    - Open your `/android/app/src/main/res/values/strings.xml` file, or create one if it doesn't exists.
    - Add the following (replace `{your-app-id}` with your facebook app Id) and with your client token:

    ```xml
        <string name="facebook_app_id">{your-app-id}</string>
        <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
    ```

    Here one example of `strings.xml`

    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <string name="facebook_app_id">1365719610250300</string>
        <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
    </resources>
    ```

    You can find the **client token** in your facebook developers console
   <img src="https://user-images.githubusercontent.com/15864336/144253037-f1750fbd-62ac-42fb-88a6-2f7ed8113f3e.png" />

    - Open the `/android/app/src/main/AndroidManifest.xml` file.
    - Add the following uses-permission element after the application element

    ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```

    - Add the following meta-data element, an activity for Facebook, and an activity and intent filter for Chrome Custom Tabs inside your application element

    ```xml
    <meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
    <meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
    ```

    Here one example of `AndroidManifest.xml`
    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="app.meedu.flutter_facebook_auth_example">
        <uses-permission android:name="android.permission.INTERNET" />
        <application
           android:name="${applicationName}"
           android:icon="@mipmap/ic_launcher"
           android:label="facebook auth">

           <meta-data
               android:name="com.facebook.sdk.ApplicationId"
               android:value="@string/facebook_app_id" />
           <meta-data 
               android:name="com.facebook.sdk.ClientToken" 
               android:value="@string/facebook_client_token"/>

            <activity
               android:name=".MainActivity"
               android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
               android:hardwareAccelerated="true"
               android:launchMode="singleTop"
               android:theme="@style/LaunchTheme"
               android:exported="true"
               android:windowSoftInputMode="adjustResize">
               <meta-data
                   android:name="io.flutter.embedding.android.NormalTheme"
                   android:resource="@style/NormalTheme" />
               <meta-data
                   android:name="io.flutter.embedding.android.SplashScreenDrawable"
                   android:resource="@drawable/launch_background" />
               <intent-filter>
                   <action android:name="android.intent.action.MAIN" />
                   <category android:name="android.intent.category.LAUNCHER" />
               </intent-filter>
           </activity>
           <meta-data
               android:name="flutterEmbedding"
               android:value="2" />
        </application>
    </manifest>
    ```

   

5. Associate Your Package Name and Default Class with Your App

    <img src="https://user-images.githubusercontent.com/15864336/98712455-54b05780-2354-11eb-9509-aa2846af1a2d.png"  />

    6. Provide the Development and Release Key Hashes for Your App

    <img src="https://user-images.githubusercontent.com/15864336/98712555-73aee980-2354-11eb-9c25-c1ef3760fce1.png" />

    To find info to how to generate you key hash go to https://developers.facebook.com/docs/facebook-login/android?locale=en_US#6--provide-the-development-and-release-key-hashes-for-your-app

    > Note: if your application uses [Google Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756?visit_id=637406280862877202-1623101210&rd=1) then you should get certificate SHA-1 fingerprint from Google Play Console and convert it to base64

    > You should add key hashes for every build variants like release, debug, CI/CD, etc.


6. Queries
Apps that target Android API 30+ (Android 11+) cannot call Facebook native apps unless the package visibility needs are declared. Please follow https://developers.facebook.com/docs/android/troubleshooting/#faq_267321845055988 to make the declaration. To solve it you have to add in the AndroidManifest.xml file:

```xml
<manifest package="com.example.app">
    <queries>
        <provider android:authorities="com.facebook.katana.provider.PlatformProvider" />
    </queries>
    ...
</manifest>
```

7. (Optional)
To opt out of the Advertising ID Permission, add a uses-permission element to the manifest after the application element
```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>
```


:::danger KEEP IN MIND
- If your app is still in developing mode in your `facebook console` to test the `login flow` you only can use [test accounts](https://developers.facebook.com/docs/development/build-and-test/test-users/) or use the facebook account which is the owner of the app in the facebook developer console.
- If want to test the login flow with the native facebook app and your app is in developing mode your account must be added to the developer team https://developers.facebook.com/docs/development/build-and-test/app-roles

- If you want to get the user email and public profile you must check in your facebook developers console
that you have that permissions enabled.
![image](https://user-images.githubusercontent.com/15864336/198648412-201fcd9b-8c24-440f-893e-23c5c6efc664.png)


- Starting with Android 11 the facebook `ClientToken` is mandatory (check the above example).
- Facebook app to perform the login request when it is installed. The native Facebook app compare your app signing(key hash) with the key hash registered in your Facebook developers console. If the login flow doesn't works with the Facebook app that means that you have problems with your hash. Make sure that you have added the correct key hashes in your console.

- If you get error like this:
`Missing 'package' key attribute on element package at ...` 

 This issue happens for the combination of:

 ```
 Using Android-SDK's API level 31 (or later),
 With old Gradle version(s).
 ```

 Check your `com.android.tools.build:gradle` version in `android/build.gradle`. It's should be `3.5.4` or `higher`.
:::
