# Webアプリケーションフレームワーク

## 概要
RubyによるWebアプリケーションフレームワークです。  
raccで構文解析してrackでフレームワーク本体を実装しています。  
Webアプリケーションフレームワークとしての最低限の動作が可能です。  
超高速です(笑)  


## 使い方
このリポジトリをローカルにcloneします。
app.wafにこのフレームワークの文法を記述していきます。
`% rackup config.ru`
でサーバーを起動して`localhost:9292`にアクセスしてください。

## 文法
文法の並びは以下のようになります。

```
request_method request
	action_logics
```

ブロックはインデントで表現します。
この文法でapp.wafを記述すると以下のようになります。

```ruby:app.waf
get /
	a = "hello "
	b = "world"
	a + b
```

## 仕様
最終行が出力する結果になります。
上記の例の場合`hello world`がブラウザに出力されます。

## その他
`params['params']`でパラメーターを取得出来ます。
`haml :template`でviews配下のhamlテンプレートをrenderできます。
