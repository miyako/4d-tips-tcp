![version](https://img.shields.io/badge/version-20%20R9%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-tips-tcp)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-tips-tcp/total)

# 4d-tips-tcp
How to send large TCP data

### about

20 R8では，[TCPクライアント](https://blog.4d.com/ja/new-class-to-perform-tcp-connections/)，20 R9では[TCPサーバー](https://blog.4d.com/ja/new-class-to-handle-incoming-tcp-connections/)を作成するためのクラスが追加されました。新しいTCPクラスは，[4D Internet Commands](https://doc.4d.com/4Dv20/4D/20/Low-Level-Routines-Overview.300-6341155.ja.html)のTCP/IPコマンドとは違い，いずれも[プリエンプティブプロセス](https://developer.4d.com/docs/ja/Develop/preemptive-processes)に対応しています。ネットワーク通信は，メソッドを実行中のプロセスではなく，4Dの**バックグラウンドスレッド**で実行され，古典的なループ処理ではなく，コールバック関数でデータを処理します。

### classes

[`TCPConnection`](https://developer.4d.com/docs/ja/API/TCPConnectionClass#tcpconnection-オブジェクト)は，TCPクライアントおよびTCPサーバーの**データ送受信**を実装するためのクラスです。TCPクライアントの場合，コンストラクターの`4D.TCPConnection.new()`にポート番号とホスト名またはアドレスを渡してインスタンス化します。TCPサーバーの場合，**明示的にコンストラクターを呼び出すことはしません**。


[`TCPListener`](https://developer.4d.com/docs/ja/API/TCPListenerClass)は，TCPサーバーの**待ち受けパート**を実装するためのクラスです。コンストラクターの`4D.TCPListener.new()`にポート番号を渡してインスタンス化します。新しいTCPクライアントが接続するたびに新しい`TCPConnection`を暗黙的にインスタンス化することにより，同時に多数のクライアントを扱うことができます。多数のクライアントを扱うために多数のプロセスを起動することはしません。

[`TCPEvent`](https://developer.4d.com/docs/ja/API/TCPEventClass)は，TCPクライアントおよびTCPサーバーのコールバック関数に渡される引数データのテンプレートクラスです。4Dが内部的にインスタンス化するクラスであり，**明示的にコンストラクターを呼び出して作成することはしません**。

### callback

`TCPConnection`および`TCPListener`をインスタンス化すると，非同期コールバック関数が発生することになります。コールバック関数は，ダイアログ実行中に発生するフォームイベントのようなものであり，`TCPEvent`のインスタンスが引数として渡されます。どんなフォーミュラでも非同期コールバック関数にすることができますが，ユーザークラスのメンバー関数としてすべてのコールバックを実装し，そのクラスのインスタンスから`This`を`TCPConnection`または`TCPListener`のコンストラクターに渡すスタイルが一般的です。

非同期コールバック関数の実行コンテキストは，`TCPConnection`および`TCPListener`をインスタンス化したコンテキストで決まります。ダイアログを実行していないワーカーのコンテキストでTCPクラスをインスタンス化した場合，TCPのバックグランドプロセスから**ワーカー**が呼び出されます（`CALL WORKER`）。ダイアログを実行しているプロセスのコンテキストでTCPクラスをインスタンス化した場合，TCPのバックグランドプロセスから**フォーム**が呼び出されます（`CALL FORM`）。つまり，フォームイベントでTCPクラスをインスタンス化すれば，コールバックでリアルタイムにフォームをアップデートすることができます。

> [!TIP]
> あ









### テスト画面

<img width="509" height="354" alt="" src="https://github.com/user-attachments/assets/5bdf5da7-f997-49b9-a17d-11a117c4cfda" />
