"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[3870],{3905:function(e,n,t){t.d(n,{Zo:function(){return s},kt:function(){return u}});var o=t(7294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function r(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);n&&(o=o.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,o)}return t}function i(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?r(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):r(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function d(e,n){if(null==e)return{};var t,o,a=function(e,n){if(null==e)return{};var t,o,a={},r=Object.keys(e);for(o=0;o<r.length;o++)t=r[o],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(o=0;o<r.length;o++)t=r[o],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var l=o.createContext({}),p=function(e){var n=o.useContext(l),t=n;return e&&(t="function"==typeof e?e(n):i(i({},n),e)),t},s=function(e){var n=p(e.components);return o.createElement(l.Provider,{value:n},e.children)},c={inlineCode:"code",wrapper:function(e){var n=e.children;return o.createElement(o.Fragment,{},n)}},m=o.forwardRef((function(e,n){var t=e.components,a=e.mdxType,r=e.originalType,l=e.parentName,s=d(e,["components","mdxType","originalType","parentName"]),m=p(t),u=a,f=m["".concat(l,".").concat(u)]||m[u]||c[u]||r;return t?o.createElement(f,i(i({ref:n},s),{},{components:t})):o.createElement(f,i({ref:n},s))}));function u(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var r=t.length,i=new Array(r);i[0]=m;var d={};for(var l in n)hasOwnProperty.call(n,l)&&(d[l]=n[l]);d.originalType=e,d.mdxType="string"==typeof e?e:a,i[1]=d;for(var p=2;p<r;p++)i[p]=t[p];return o.createElement.apply(null,i)}return o.createElement.apply(null,t)}m.displayName="MDXCreateElement"},1054:function(e,n,t){t.r(n),t.d(n,{assets:function(){return s},contentTitle:function(){return l},default:function(){return u},frontMatter:function(){return d},metadata:function(){return p},toc:function(){return c}});var o=t(3117),a=t(102),r=(t(7294),t(3905)),i=["components"],d={},l="Android configuration",p={unversionedId:"android",id:"version-4.x.x/android",title:"Android configuration",description:"Upon installation of this plugin, configuration is needed on Android before running the project again. If this is not done, an error of No implementation found would show because the Facebook SDK on Android would throw an Exception error if the configuration is not yet defined. This error also locks the other plugins in your project, so if the plugin is not yet needed, either remove it or comment it out from the pubspec.yaml file.",source:"@site/versioned_docs/version-4.x.x/android.md",sourceDirName:".",slug:"/android",permalink:"/docs/4.x.x/android",draft:!1,editUrl:"https://github.com/darwin-morocho/flutter-facebook-auth/tree/master/website/versioned_docs/version-4.x.x/android.md",tags:[],version:"4.x.x",frontMatter:{},sidebar:"version-4.x.x/tutorialSidebar",previous:{title:"intro",permalink:"/docs/4.x.x/intro"},next:{title:"iOS configuration",permalink:"/docs/4.x.x/ios"}},s={},c=[],m={toc:c};function u(e){var n=e.components,t=(0,a.Z)(e,i);return(0,r.kt)("wrapper",(0,o.Z)({},m,t,{components:n,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"android-configuration"},"Android configuration"),(0,r.kt)("admonition",{title:"IMPORTANT",type:"danger"},(0,r.kt)("p",{parentName:"admonition"},"Upon installation of this plugin, configuration is needed on Android before running the project again. If this is not done, an error of ",(0,r.kt)("strong",{parentName:"p"},"No implementation found")," would show because the Facebook SDK on Android would throw an Exception error if the configuration is not yet defined. This error also locks the other plugins in your project, so if the plugin is not yet needed, either remove it or comment it out from the pubspec.yaml file.")),(0,r.kt)("p",null,"Go to ",(0,r.kt)("a",{parentName:"p",href:"https://developers.facebook.com/docs/facebook-login/android/?locale=en"},"Facebook Login for Android - Quickstart")),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Select an App or Create a New App")),(0,r.kt)("img",{src:"https://user-images.githubusercontent.com/15864336/98711287-cedfdc80-2352-11eb-9eb3-761f43ba4f7e.png"}),(0,r.kt)("ol",{start:2},(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"Skip the step 2 (Download the Facebook App)")),(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"Skip the step 3 (Integrate the Facebook SDK)")),(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"Edit ",(0,r.kt)("strong",{parentName:"p"},"Your Resources and Manifest")," add this config in your android project"),(0,r.kt)("ul",{parentName:"li"},(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Open your ",(0,r.kt)("inlineCode",{parentName:"p"},"/android/app/src/main/res/values/strings.xml")," file, or create one if it doesn't exists.")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Add the following (replace ",(0,r.kt)("inlineCode",{parentName:"p"},"{your-app-id}")," with your facebook app Id) and with your client token:"),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'    <string name="facebook_app_id">{your-app-id}</string>\n    <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>\n')),(0,r.kt)("p",{parentName:"li"}," Here one example of ",(0,r.kt)("inlineCode",{parentName:"p"},"strings.xml")),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <string name="facebook_app_id">1365719610250300</string>\n    <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>\n</resources>\n')),(0,r.kt)("p",{parentName:"li"}," You can find the ",(0,r.kt)("strong",{parentName:"p"},"client token")," in your facebook developers console"),(0,r.kt)("img",{src:"https://user-images.githubusercontent.com/15864336/144253037-f1750fbd-62ac-42fb-88a6-2f7ed8113f3e.png"})),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Open the ",(0,r.kt)("inlineCode",{parentName:"p"},"/android/app/src/main/AndroidManifest.xml")," file.")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Add the following uses-permission element after the application element"),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'<uses-permission android:name="android.permission.INTERNET"/>\n'))),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Add the following meta-data element, an activity for Facebook, and an activity and intent filter for Chrome Custom Tabs inside your application element"),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>\n<meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>\n')),(0,r.kt)("p",{parentName:"li"},"Here one example of ",(0,r.kt)("inlineCode",{parentName:"p"},"AndroidManifest.xml")),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'<manifest xmlns:android="http://schemas.android.com/apk/res/android"\n    package="app.meedu.flutter_facebook_auth_example">\n    <uses-permission android:name="android.permission.INTERNET" />\n    <application\n       android:name="${applicationName}"\n       android:icon="@mipmap/ic_launcher"\n       android:label="facebook auth">\n\n       <meta-data\n           android:name="com.facebook.sdk.ApplicationId"\n           android:value="@string/facebook_app_id" />\n       <meta-data \n           android:name="com.facebook.sdk.ClientToken" \n           android:value="@string/facebook_client_token"/>\n\n        <activity\n           android:name=".MainActivity"\n           android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"\n           android:hardwareAccelerated="true"\n           android:launchMode="singleTop"\n           android:theme="@style/LaunchTheme"\n           android:exported="true"\n           android:windowSoftInputMode="adjustResize">\n           <meta-data\n               android:name="io.flutter.embedding.android.NormalTheme"\n               android:resource="@style/NormalTheme" />\n           <meta-data\n               android:name="io.flutter.embedding.android.SplashScreenDrawable"\n               android:resource="@drawable/launch_background" />\n           <intent-filter>\n               <action android:name="android.intent.action.MAIN" />\n               <category android:name="android.intent.category.LAUNCHER" />\n           </intent-filter>\n       </activity>\n       <meta-data\n           android:name="flutterEmbedding"\n           android:value="2" />\n    </application>\n</manifest>\n')))))),(0,r.kt)("ol",{start:5},(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"Associate Your Package Name and Default Class with Your App"),(0,r.kt)("img",{src:"https://user-images.githubusercontent.com/15864336/98712455-54b05780-2354-11eb-9509-aa2846af1a2d.png"}),(0,r.kt)("ol",{parentName:"li",start:6},(0,r.kt)("li",{parentName:"ol"},"Provide the Development and Release Key Hashes for Your App")),(0,r.kt)("img",{src:"https://user-images.githubusercontent.com/15864336/98712555-73aee980-2354-11eb-9c25-c1ef3760fce1.png"}),(0,r.kt)("p",{parentName:"li"},"To find info to how to generate you key hash go to ",(0,r.kt)("a",{parentName:"p",href:"https://developers.facebook.com/docs/facebook-login/android?locale=en_US#6--provide-the-development-and-release-key-hashes-for-your-app"},"https://developers.facebook.com/docs/facebook-login/android?locale=en_US#6--provide-the-development-and-release-key-hashes-for-your-app")),(0,r.kt)("blockquote",{parentName:"li"},(0,r.kt)("p",{parentName:"blockquote"},"Note: if your application uses ",(0,r.kt)("a",{parentName:"p",href:"https://support.google.com/googleplay/android-developer/answer/9842756?visit_id=637406280862877202-1623101210&rd=1"},"Google Play App Signing")," then you should get certificate SHA-1 fingerprint from Google Play Console and convert it to base64")),(0,r.kt)("blockquote",{parentName:"li"},(0,r.kt)("p",{parentName:"blockquote"},"You should add key hashes for every build variants like release, debug, CI/CD, etc.")))),(0,r.kt)("ol",{start:6},(0,r.kt)("li",{parentName:"ol"},"Queries\nApps that target Android API 30+ (Android 11+) cannot call Facebook native apps unless the package visibility needs are declared. Please follow ",(0,r.kt)("a",{parentName:"li",href:"https://developers.facebook.com/docs/android/troubleshooting/#faq_267321845055988"},"https://developers.facebook.com/docs/android/troubleshooting/#faq_267321845055988")," to make the declaration. To solve it you have to add in the AndroidManifest.xml file:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-xml"},'<manifest package="com.example.app">\n    <queries>\n        <provider android:authorities="com.facebook.katana.provider.PlatformProvider" />\n    </queries>\n    ...\n</manifest>\n')))}u.isMDXComponent=!0}}]);