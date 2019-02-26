# LunchFree
Personal project for app development practices and testing APIs, design elements and technologies for iOS app. 
Not for commercial purpose. 
Learning and Research only. 

個人スキルアップ用のプロジェクト。APIや、新しいテクノロジーや、新デザインなどをテストするためのiOSアプリプロジェクト。
こちらのアプリは仮想したもので、商業用のアプリではない。

MVCの構造パターンとリファクタリングをしていなくて、若干読みづらくて申し訳ございません。

## Screenshot & video
![Lunchfree](https://i.imgur.com/f3e0GmH.png "サンプル")

video: https://www.youtube.com/watch?v=HLBglrB-VsY

## Project Status 進捗状況
In deveopment. It has login and data storage function which is using Firebase Authentication and Firebase Cloud Firestore (Beta) service.

Note: launching the app requires to register google API key, facebook app id and twitter app id on info.plist first.

How to register the keys: https://firebase.google.com/docs/auth/ios/firebaseui

Also add the consumer secret and consumer key in AppDelegate for twitter login.

```TWTRTwitter.sharedInstance().start(withConsumerKey:"yourKeyHere", consumerSecret:"yourSecretHere")```

開発中。
Firebase AuthenticationとFirebase Cloud Firestore (Beta)により、ログイン機能とクラウドにユーザーが登録した情報を保存する機能を実装した。

注：アプリを成功に起動させるには、先にgoogle API keyと、facebook app idと、twitter app idをinfo.plistに登録することが必要となります。秘密情報であるため、このリポジトリにはそういった情報を載せていません。

登録方法: https://firebase.google.com/docs/auth/ios/firebaseui?hl=ja

Twitterログイン機能を利用するには、さらにAppDelegateでconsumer secretとconsumer keyを登録することが必要。

```TWTRTwitter.sharedInstance().start(withConsumerKey:"yourKeyHere", consumerSecret:"yourSecretHere")```

## Installation and Setup Instructions　インストール手順
Clone repository and open the LunchFree.xcworkspace file with the newest version of Xcode

リポジトリをクローンして、最新版のXcodeでLunchFree.xcworkspaceを開く。

## Reflection　プロジェクトの由来
This is my very first iOS app project in my journey of iOS app development learning. Project goals included using personal app deveopment skill training, experiment technology and familiarizing myself with the iOS native app development in general.

I will keep contributing to the development of this app. I will really appreciate if you comment your opinion after reading my code.

Thank you.

こちらのプロジェクトは、私の最初のiOSネイティブアプリ開発プロジェクトです。

このプロジェクトはもともと、オフィスワーカーのランチ問題を解決するためのサービスを立ち上げるために開発したアプリですが、ビジネスの考慮により、サービスの立ち上げが中止になってしまい、今私の個人のスキルアップ、テクノロジーの実験用のプロジェクトになっています。

このアプリは不定期にコミットします。もしこのプロジェクトについて何かの感想やフィードバックをコメントでいただけると幸いです。

よろしくお願いいたします。
