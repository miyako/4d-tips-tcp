![version](https://img.shields.io/badge/version-20%20R9%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-tips-tcp)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-tips-tcp/total)

# 4d-tips-tcp
How to send large TCP data

### screenshot

<img width="509" height="354" alt="" src="https://github.com/user-attachments/assets/5bdf5da7-f997-49b9-a17d-11a117c4cfda" />

### about

20 R8では，[TCPクライアント](https://blog.4d.com/ja/new-class-to-perform-tcp-connections/)，20 R9では[TCPサーバー](https://blog.4d.com/ja/new-class-to-handle-incoming-tcp-connections/)を作成するためのクラスが追加されました。新しいTCPクラスは，[4D Internet Commands](https://doc.4d.com/4Dv20/4D/20/Low-Level-Routines-Overview.300-6341155.ja.html)のTCP/IPコマンドとは違い，いずれも[プリエンプティブプロセス](https://developer.4d.com/docs/ja/Develop/preemptive-processes)に対応しています。ネットワーク通信は，メソッドを実行中のプロセスではなく，4Dの**バックグラウンドスレッド**で実行され，古典的なループ処理ではなく，コールバック関数でデータを処理します。

### classes

[`TCPConnection`](https://developer.4d.com/docs/ja/API/TCPConnectionClass#tcpconnection-オブジェクト)は，TCPクライアントおよびTCPサーバーの**データ送受信**を実装するためのクラスです。TCPクライアントの場合，コンストラクターの`4D.TCPConnection.new()`にポート番号とホスト名またはアドレスを渡してインスタンス化します。TCPサーバーの場合，**明示的にコンストラクターを呼び出すことはしません**。


[`TCPListener`](https://developer.4d.com/docs/ja/API/TCPListenerClass)は，TCPサーバーの**待ち受けパート**を実装するためのクラスです。コンストラクターの`4D.TCPListener.new()`にポート番号を渡してインスタンス化します。新しいTCPクライアントが接続するたびに新しい`TCPConnection`を暗黙的にインスタンス化することにより，同時に多数のクライアントを扱うことができます。多数のクライアントを扱うために多数のプロセスを起動することはしません。

[`TCPEvent`](https://developer.4d.com/docs/ja/API/TCPEventClass)は，TCPクライアントおよびTCPサーバーのコールバック関数に渡される引数データのテンプレートクラスです。4Dが内部的にインスタンス化するクラスであり，**明示的にコンストラクターを呼び出して作成することはしません**。

### callback

`TCPConnection`および`TCPListener`をインスタンス化すると，非同期コールバック関数が発生することになります。コールバック関数は，ダイアログ実行中に発生するフォームイベントのようなものであり，`TCPEvent`のインスタンスが引数として渡されます。どんなフォーミュラでも非同期コールバック関数にすることができますが，ユーザークラスのメンバー関数としてすべてのコールバックを実装し，そのクラスのインスタンスから`This`を`TCPConnection`または`TCPListener`のコンストラクターに渡すスタイルが一般的です。

非同期コールバック関数の実行コンテキストは，`TCPConnection`および`TCPListener`をインスタンス化したコンテキストで決まります。ダイアログを実行していないワーカーのコンテキストでTCPクラスをインスタンス化した場合，TCPのバックグランドプロセスから**ワーカー**が呼び出されます（`CALL WORKER`）。ダイアログを実行しているプロセスのコンテキストでTCPクラスをインスタンス化した場合，TCPのバックグランドプロセスから**フォーム**が呼び出されます（`CALL FORM`）。

> [!TIP]
> フォームイベントでTCPクラスをインスタンス化すれば，コールバックでリアルタイムにフォームをアップデートすることができます（`Form`やフォームオブジェクトコマンドが使用できます）。

> [!WARNING]
> フォームイベントでTCPクラスをインスタンス化した場合，理論的にはフォームが閉じられた後にコールバック関数が呼ばられる可能性があります。念の為，コールバックには`Form#Null`のチェックを含めると良いでしょう。

TCPクライアントは，経過を視覚的に確認できるフォームのコンテキストで実装したい場合もあれば，ユーザーインターフェースを持たないプロセスで実行したい場合もあります。例題では，ユーザーインターフェースとは関係のない共通のコードを[`cs.Client`](4d-tips-tcp/Project/Sources/Classes/Client.4dm)クラスに実装し，継承クラスである[`cs.ClientForm`](4d-tips-tcp/Project/Sources/Classes/ClientForm.4dm)にフォーム特有のコードを実装しています。

### data

[ドキュメント](https://developer.4d.com/docs/ja/API/TCPConnectionClass#tcpconnection-オブジェクト)に記載されているとおり，`4D.TCPConnection`クラスの`onData`コールバック関数は，段階的に呼ばれることがあります。

```4d
// 警告: 一つのネットワークパケットで必要なデータを全て受け取れる保証はありません。 
```

4Dのバックグラウンドスレッドは，コールバックの実行コンテキストであるワーカーやダイアログからは独立しており，内部的なバッファにデータを累積しています。`TRACE`や`DELAY PROCESS`などでワーカーやダイアログをビジー状態にし，コールバックを呼べない時間を作り出すと，バックグラウンドスレッドのバッファにデータが溜まってゆき，最終的にすべてのデータが`1`回のコールバックで渡されるかもしれません。とはいえ，通常は，ワーカーやダイアログをアイドル状態にしておき，こまめにコールバックを受け取ることになります。

TCPクラスのデータは`4D.Blob`型で渡されます。このデータタイプはイミュータブル（変更不可）なので，オブジェクト型のプロパティとして扱いたい場合，一旦，`Blob`にコピーしてから，`4D.Blob`に戻る必要があります。

```4d
var $buf : Blob
$buf:=This.data
COPY BLOB($data; $buf; 0; This.data.size; $data.size)
This.data:=$buf
```

サーバーの`onData`には`4D.TCPConnection`が引数として渡されるので，`.send()`でレスポンスを返すこともできます。ただし，`.send()`レスポンスを返した場合，**以降の`onData`は呼ばれません**。そのため，受信したデータのサイズを確認し，すべてのデータを受け取るまで`.send()`を遅延する必要があります。

### custom protocol

例題では，下記に示す簡単な通信プロトコルを実装しています。

* サーバーからクライアント

|JSONプロパティ|意味|
|:-|:-|
|`mesasge`|`Sure!` サイズ情報を認識した<br />`Thanks!` 完了した<br />`Oops!` エラー|
|`size`|これまで受信したバイト数|
|`total`|全部で受信するバイト数|
|`complete`|完了したら`True`|

* クライアントからサーバー

|JSONプロパティ|意味|
|:-|:-|
|`size`|これから送信するバイト数|

それ以外のパケットは生データとみなす
