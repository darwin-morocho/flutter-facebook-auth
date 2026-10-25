// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "flutter_facebook_auth",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(name: "flutter-facebook-auth", targets: ["flutter_facebook_auth"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/facebook/facebook-ios-sdk",
      "18.1.1" ..< "19.0.0"
    ),
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "flutter_facebook_auth",
      dependencies: [
        .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ]
    )
  ]
)
