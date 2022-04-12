# iOS configuration


:::danger IMPORTANT
For `Objective-C` projects this plugin won't work because this plugin was written in swift. So you need to use swift as a default language for your flutter project (Check how to change to swift [here](https://github.com/darwin-morocho/flutter-facebook-auth/issues/41#issuecomment-761702248)).
:::

- In your Podfile uncomment the next line (You need set the minimum target to 11.0 or higher)

```
platform :ios, '11.0'
```

- Go to **[Facebook Login for iOS - Quickstart
](https://developers.facebook.com/docs/facebook-login/ios)** and select or create your app.

   <img src="https://user-images.githubusercontent.com/15864336/98708293-0056a900-234f-11eb-9975-b75ca08b6470.png" />

- **Skip** the step 2 **(Set up Your Development Environment)**.

- In the step 3 (Register and Configure Your App with Facebook) you need add your `Bundle Identifier`

    <img src="https://user-images.githubusercontent.com/15864336/98708485-38f68280-234f-11eb-9d1a-7c970d04642a.png"  />

  You can find your `Bundle Identifier` in Xcode (Runner - Target Runner - General)

  ![image](https://user-images.githubusercontent.com/15864336/98708171-e1581700-234e-11eb-8f94-23c0db55e8f0.png)

- In the Step 4 you need configure your `Info.plist` file inside `ios/Runner/Info.plist`

  From Xcode you can open your `Info.plist` as `Source Code` now add the next code and replace `{your-app-id}` with your facebook app Id.

  In the key **FacebookClientToken**, replace CLIENT-TOKEN with the value found under Settings > Advanced > Client Token in your App Dashboard.

    <img src="https://user-images.githubusercontent.com/15864336/98708650-66433080-234f-11eb-81c6-2297b9e6f7a7.png" width="600"/>

    ```xml
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>fb{your-app-id}</string>
        </array>
      </dict>
    </array>
    <key>FacebookAppID</key>
    <string>{your-app-id}</string>
    <key>FacebookClientToken</key>
    <string>CLIENT-TOKEN</string>
    <key>FacebookDisplayName</key>
    <string>{your-app-name}</string>
    <key>LSApplicationQueriesSchemes</key>
    <array>
      <string>fbapi</string>
      <string>fb-messenger-share-api</string>
      <string>fbauth2</string>
      <string>fbshareextension</string>
    </array>
    ```

    > If you have implement `another providers` (Like Google) in your app you should merge values in Info.plist

    Check if you already have `CFBundleURLTypes` or `LSApplicationQueriesSchemes` keys in your Info.plist. If you have, you should merge their values, instead of adding a duplicate key.

    Example with Google and Facebook implemetation:

    ```xml
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>fb{your-app-id}</string>
          <string>com.googleusercontent.apps.{your-app-specific-url}</string>
        </array>
      </dict>
    </array>
    ```

    To use any of the Facebook dialogs (e.g., Login, Share, App Invites, etc.) that can perform an app switch to Facebook apps, your application's Info.plist also needs to include: `<dict>...</dict>`)

    ```xml
    <key>LSApplicationQueriesSchemes</key>
    <array>
      <string>fbapi</string>
      <string>fbapi20130214</string>
      <string>fbapi20130410</string>
      <string>fbapi20130702</string>
      <string>fbapi20131010</string>
      <string>fbapi20131219</string>
      <string>fbapi20140410</string>
      <string>fbapi20140116</string>
      <string>fbapi20150313</string>
      <string>fbapi20150629</string>
      <string>fbapi20160328</string>
      <string>fbauth</string>
      <string>fb-messenger-share-api</string>
      <string>fbauth2</string>
      <string>fbshareextension</string>
    </array>
    ```
