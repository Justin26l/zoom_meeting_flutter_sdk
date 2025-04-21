# zoom_meeting_flutter_sdk

[![Pub](https://img.shields.io/pub/v/zoom_native_sdk.svg)](https://pub.dartlang.org/packages/zoom_native_sdk)
[![likes](https://img.shields.io/pub/likes/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![popularity](https://img.shields.io/pub/popularity/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![pub points](https://img.shields.io/pub/points/zoom_native_sdk)](https://pub.dev/packages/zoom_native_sdk/score)
[![codecov](https://codecov.io/gh/ABausG/zoom_native_sdk/branch/main/graph/badge.svg?token=ZXTZOL6KFO)](https://codecov.io/gh/ABausG/zoom_native_sdk)

this version is initial join zoom meeting using native sdk for android and ios
you need to drag and drop zoom ios meeting sdk manually to your application

## Platform Setup

In order to work correctly there needs to be some platform specific setup. Check below on how to add support for Android and iOS


<details><summary>Android</summary>
download zoom sdk (mobilertc.aar) for android :  
https://www.dropbox.com/scl/fi/krasgg3f82pru38wbsb3o/mobilertc.aar?rlkey=mpq34pxe2ipjikks34mapytd6&st=txhipze8&dl=0

put it as 
`/Users/YourName/.pub-cache/hosted/pub.dev/zoom_meeting_flutter_sdk<PackageVersion>/android/mobilertc/mobilertc.aar`

</details>

<details><summary>iOS</summary>

in first you need to login to your zoom account then select your project and download ios sdk.


 <img src="https://i.ibb.co/2yvrtHF/ios-zoom-sdk.webp?raw=true"> 


after download is complete unzip file and copy two file  :-

* MobileRTC.xcframework
* MobileRTCResources.bundle

and past in **IOS** module

 <img src="https://i.ibb.co/YtHXtbz/ios-module.png?raw=true" hight="500 px"> 


then open ios in **Xcode** and click right to Runner folder and add two file to it

* MobileRTC.xcframework
* MobileRTCResources.bundle

<img src="https://i.ibb.co/C1c99F6/add-file-to-runner.png?raw=true" hight="500 px"> 
<br /> 

will be shown as this image below

<img src="https://i.ibb.co/z6byskP/xcode-file.png?raw=true" hight="500 px"> 

<br /> 

after adding this files running **pod install** to get pods for zoom in ios

by click right to ios folder and select onpen in terminal

```
pod install
```

after pod install is complete open xcode and make sure **MobileRTC.xcframework**
is added in `TARGETS/Runner/Frameworks,Libraries, and Embedded Content`

<img src="https://i.ibb.co/K21Y3Sg/add-rtc.png?raw=true" hight="500 px"> 

<br /> 

in xcode go to `Pods/TARGETS/zoom_native_sdk/Frameworks and Libraries`

and add MobileRTC.xcframework to it and make sure it Do Not Embed as shown

<img src="https://i.ibb.co/NYs2Ysz/config-pod.png?raw=true" hight="500 px"> 
  
and last, re-sign the sdk using command  
``` bash
codesign --force --deep --sign "Apple Development: ... (...)" MobileRTC.xcframework  
```

for more info
[ios docs](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/getting-started/install-sdk/)

reference
[example/ios](./example/ios)
</details>
<br /> 

### Usage
-------------------------

```
import 'package:zoom_native_sdk/zoom_native_sdk.dart';
```

```
final _zoomNativelyPlugin = ZoomMeetingFlutterSdk();
```

```
isInitialized = (await _zoomNativelyPlugin.initZoom(
  jwtToken: "",
)) ??
false;
```

```
await _zoomNativelyPlugin.joinMeting(
  meetingNumber: "",
  meetingPassword: "",
);
```

### Call Structure
-------------------------------
open with [drawio vscode plugin](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)  
[structureChart.drawio](docs/structureChart.drawio)

### About Develpment
-------------------------------
Develop & Maintain by Justin26l @ SimIT Group  
forked from **Al7osam company**'s [zoom_native_sdk](https://github.com/abo-el30la/zoom_native_sdk)
<br>
