![version](https://img.shields.io/badge/version-20%20R9%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-tips-tcp)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-tips-tcp/total)

# 4d-tips-tcp
How to send large TCP data

### about

20 R8では，[TCPクライアント](https://blog.4d.com/ja/new-class-to-perform-tcp-connections/)，20 R9では[TCPサーバー](https://blog.4d.com/ja/new-class-to-handle-incoming-tcp-connections/)を作成するためのクラスが追加されました。新しいTCPクラスは，[4D Internet Commands](https://doc.4d.com/4Dv20/4D/20/Low-Level-Routines-Overview.300-6341155.ja.html)のTCP/IPコマンドとは違い，いずれも[プリエンプティブプロセス](https://developer.4d.com/docs/ja/Develop/preemptive-processes)に対応しています。ネットワーク通信は，クラスのメンバー関数を実行したプロセスではなく，4Dのバックグラウンドスレッドで実行され，データは，古典的なループ処理ではなく，コールバック関数で受け渡します。

### 資料

* [`TCPConnection`](https://developer.4d.com/docs/ja/API/TCPConnectionClass#tcpconnection-オブジェクト)
* [`TCPListener`](https://developer.4d.com/docs/ja/API/TCPListenerClass)
* [`TCPEvent`](https://developer.4d.com/docs/ja/API/TCPEventClass)

### テスト画面

<img width="509" height="354" alt="" src="https://github.com/user-attachments/assets/5bdf5da7-f997-49b9-a17d-11a117c4cfda" />
