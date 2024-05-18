"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[8504],{3905:function(e,t,n){n.d(t,{Zo:function(){return p},kt:function(){return d}});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var u=r.createContext({}),l=function(e){var t=r.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},p=function(e){var t=l(e.components);return r.createElement(u.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,i=e.originalType,u=e.parentName,p=c(e,["components","mdxType","originalType","parentName"]),f=l(n),d=o,m=f["".concat(u,".").concat(d)]||f[d]||s[d]||i;return n?r.createElement(m,a(a({ref:t},p),{},{components:n})):r.createElement(m,a({ref:t},p))}));function d(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=n.length,a=new Array(i);a[0]=f;var c={};for(var u in t)hasOwnProperty.call(t,u)&&(c[u]=t[u]);c.originalType=e,c.mdxType="string"==typeof e?e:o,a[1]=c;for(var l=2;l<i;l++)a[l]=n[l];return r.createElement.apply(null,a)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},2941:function(e,t,n){n.r(t),n.d(t,{assets:function(){return u},contentTitle:function(){return a},default:function(){return s},frontMatter:function(){return i},metadata:function(){return c},toc:function(){return l}});var r=n(3117),o=(n(7294),n(3905));const i={},a="web configuration",c={unversionedId:"web",id:"version-6.x.x/web",title:"web configuration",description:"Check a web demo here",source:"@site/versioned_docs/version-6.x.x/web.md",sourceDirName:".",slug:"/web",permalink:"/docs/6.x.x/web",draft:!1,editUrl:"https://github.com/darwin-morocho/flutter-facebook-auth/tree/master/website/versioned_docs/version-6.x.x/web.md",tags:[],version:"6.x.x",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"iOS configuration",permalink:"/docs/6.x.x/ios"},next:{title:"macOS support",permalink:"/docs/6.x.x/macos"}},u={},l=[],p={toc:l};function s(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,r.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"web-configuration"},"web configuration"),(0,o.kt)("blockquote",null,(0,o.kt)("p",{parentName:"blockquote"},"Check a web demo ",(0,o.kt)("a",{parentName:"p",href:"https://flutter-facebook-auth.web.app/"},"here"))),(0,o.kt)("p",null,"\ud83d\udeab ",(0,o.kt)("em",{parentName:"p"},"IMPORTANT:")," the facebook javascript SDK is only allowed to use with ",(0,o.kt)("inlineCode",{parentName:"p"},"https")," but you can test the plugin in your localhost with an error message in your web console."),(0,o.kt)("p",null,"\ud83d\udc49 The ",(0,o.kt)("inlineCode",{parentName:"p"},"accessToken")," method only works in live mode using ",(0,o.kt)("inlineCode",{parentName:"p"},"https")," and you must add your ",(0,o.kt)("strong",{parentName:"p"},"OAuth redirect URL")," in your ",(0,o.kt)("em",{parentName:"p"},"facebook developer console"),"."),(0,o.kt)("p",null,"::: INFO\nSince ",(0,o.kt)("inlineCode",{parentName:"p"},"flutter_facebook_auth:^4.2.0")," you don't need to add a script code in your ",(0,o.kt)("inlineCode",{parentName:"p"},"index.html"),".\n:::"),(0,o.kt)("p",null,"Go to your ",(0,o.kt)("inlineCode",{parentName:"p"},"main.dart")," file and in your ",(0,o.kt)("inlineCode",{parentName:"p"},"main")," function initialize the facebook SDK."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"import 'package:flutter/foundation.dart' show kIsWeb; \nimport 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; \n.\n.\n.\nvoid main() async {\n  // check if is running on Web\n  if (kIsWeb) {\n    // initialiaze the facebook javascript SDK\n   await FacebookAuth.i.webAndDesktopInitialize(\n      appId: \"YOUR_FACEBOOK_APP_ID\",\n      cookie: true,\n      xfbml: true,\n      version: \"v15.0\",\n    );\n  }\n  runApp(MyApp());\n}\n")),(0,o.kt)("blockquote",null,(0,o.kt)("p",{parentName:"blockquote"},"On Web if the facebook SDK was not initialized by missing configuration or  content blockers all methods of this plugin will return null or a fail status depending of the method. You can check if the SDK was initialized using ",(0,o.kt)("inlineCode",{parentName:"p"}," FacebookAuth.i.isWebSdkInitialized"),".")))}s.isMDXComponent=!0}}]);