# LunchFree
Personal project for app development practices and testing APIs, design elements and technologies for iOS app. 
Not for commercial purpose. 
Learning and Research only. 

個人スキルアップ用のプロジェクト。APIや、新しいテクノロジーや、新デザインなどをテストするためのiOSアプリプロジェクト。
こちらのアプリは仮想したもので、商業用のアプリではない。

MVCの構造パターンとリファクタリングをしていなくて、若干読みづらくて申し訳ございません。

## Project Status 進捗状況
In deveopment. Users can launch the app and interacting with the visual element on the UI. Also, it has login and data storage function which is using Firebase Authentication and Firebase Cloud Firestore (Beta) service.

Note: launching the app requires to register google API key, facebook app id and twitter app id on info.plist first.
How to register the keys: https://firebase.google.com/docs/auth/ios/firebaseui

開発中。
ユーザーがアプリを起動することができ、UIを操作することができる。
また、Firebase AuthenticationとFirebase Cloud Firestore (Beta)により、ログイン機能とクラウドにユーザーが登録した情報を保存する機能を実装した。

注：アプリを成功に起動させるには、先にgoogle API keyと、facebook app idと、twitter app idをinfo.plistに登録することが必要となります。秘密情報であるため、このリポジトリにはそういった情報を載せていません。
登録方法；https://firebase.google.com/docs/auth/ios/firebaseui?hl=ja

## Project Screen Shot(s)　スクリーンショット
Upload later...

後ほど追加します。

## Installation and Setup Instructions　インストール手順
Clone repository and open the LunchFree.xcworkspace file with the newest version of Xcode

リポジトリをクローンして、最新版のXcodeでLunchFree.xcworkspaceを開く。

## Reflection　プロジェクトの由来
This is my very first iOS app project in my journey of iOS app development learning starting from July 2017. Project goals included using personal app deveopment skill training, experiment technology and familiarizing myself with the iOS native app development in general.

Originally I wanted to build an app that allowed office workers to order their lunch daily with the least effort for choosing their lunch and allowed them to pick it up at a destinated time at the entrance of the office building. However, I abandon the project due to business concern and now it becomes my personal project for learning, practicing and experimenting iOS native app development.

One of the challenges is implementing the expandable picker cell in tableView which spend my a few days for search on Internet and learn the logic and the implement of it.

One of the great gain in the project is that Firebase is really easy to use in app development to implementing basic functions in mobile app such as login and fetching and saving data to backend. (Cloud Firestore is so great! No more JSON!!!)

I will keep contributing to the development of this app. I will really appreciate if you comment your opinion after reading my code.

Thank you.

こちらのプロジェクトは、私の最初のiOSネイティブアプリ開発プロジェクトです。2017年7月からiOSネイティブアプリ開発の勉強を始めて、このreadmeを書く時点で約1年を経ちました。

このプロジェクトはもともと、オフィスワーカーのランチ問題を解決するためのサービスを立ち上げるために開発したアプリですが、ビジネスの考慮により、サービスの立ち上げが中止になってしまい、今私の個人のスキルアップ、テクノロジーの実験用のプロジェクトになっています。

一つの大きなチャレンジとしては、展開できるpicker viewをtableviewに実装すること。結構時間をかかって、色々調べて、無事に実装しました。正直、一見シンプルそうな機能の実装がこんなに大変だと思いませんでした。（そのおかげでコードもめちゃくちゃになってしまいますが。。。）

一つの学びとしてはFirebaseは最高ということ笑。Firebaseを使うと、モバイルアプリにおける、いくつかのベーシックな機能を簡単に実装できます！databaseとかの運用も便利で楽です！（cloud FirestoreはJSONなくて最高！）今後も積極的にFirebaseを使うと思います。

このアプリは不定期にコミットします！もしこのプロジェクトについて何かの感想やフィードバックをコメントでいただけると幸いです。

よろしくお願いいたします！
