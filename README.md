# batch-launcher

[README in English](README-en.md)

![batch-launcher](png/launcher-jp.png)

## 概要
batch-launcherはバッチファイルで作成したランチャーです。
ショートカットキーでWindowsのコマンドやアプリを実行することができます。

## 特徴
* CSVファイルで「実行するコマンド」、「ショートカットキー」、「表示名」を設定
* コマンドを表形式で複数列に表示可能
* ウィンドウサイズを自動的に調整
* 背景色、文字色を変更可能
* 日本語環境以外では英語表記でランチャーが起動

## ショートカットキーの設定
key_list.csvに以下の順番でカンマ','区切りで記述します。

1. ショートカットキー
2. 実行するコマンド
3. 表示名
4. 色

以下は注意事項。

* 既存の内容はサンプルなので変更してください（key_list-jp.csvは日本語環境用のサンプル）。
* 1行目はコメント行
* 改行コードはCR＋LF
* 日本語の文字コードはShift_JIS
* 編集はテキストエディタ推奨。Excel非推奨。
* 「表示名」がない場合は「実行するコマンド」を「表示名」とする。
* 「色」を指定しない場合はsettings.txtの「文字色」の設定に従う。
* 「色」は4番目に記載した場合のみ有効

以下はGoogle Chromeでgithub.comのページにアクセスするための設定例です。実行コマンド名だけでなく複数の引数を指定することもできます。この例では'ch'と入力するとChromeが起動します。

<pre>
ch,"C:\Program Files\Google\Chrome\Application\chrome.exe" https://github.com/,Chrome
</pre>

以下は電卓を起動するための設定例です。Pathの通ったコマンドやアプリケーションはフルパスで記述する必要はありません。4番目に"red"とあるので、赤い文字で"電卓"と表示されます。

<pre>
calc,calc,電卓,red
</pre>

以下は"C:\Program Files"フォルダをエクスプローラで開くための設定例です。「実行するコマンド」にフォルダ名を記述するだけです。空白文字を含むフォルダの場合はダブルクォーテーション'"'で囲む必要があります。

<pre>
e,"C:\Program Files"
</pre>

## ランチャー本体の設定
settings.txtでランチャーの設定変更ができます。
|No.|名前|初期値|種類|説明|
|-:|-|-|-|-|
|1|LOOP|YES|YESまたはNO|常駐の有無|
|2|EXIT_KEY|q|文字列|終了のショートカットキー|
|3|BACKGROUND_COLOR|black|色設定値|背景色|
|4|TEXT_COLOR|white|色設定値|文字色|
|5|COLUMN_NUM|2|1以上の数字|列数|
|6|DISPLAY_NUMBER|YES|YESまたはNO|番号の表示|
|7|EQUALIZE_CELL_WIDTH|NO|YESまたはNO|セル幅を均等にする。|
|8|ARRANGE_VERTICAL|YES|YESまたはNO|縦に並べる。NO選択時は横並び。|

## 色設定
batch-launcherは以下の16個の色を使用できます。

<table>
<tr><th>No.</th><th width=50>色</th><th>色名</th><th>設定値</th></tr>
<tr><td>1</td><td bgcolor=#cccccc></td><td>白</td><td>white, 白</td></tr>
<tr><td>2</td><td bgcolor=#0c0c0c></td><td>黒</td><td>black, 黒</td></tr>
<tr><td>3</td><td bgcolor=#c50f1f></td><td>赤</td><td>red, 赤</td></tr>
<tr><td>4</td><td bgcolor=#c19c00></td><td>黄色</td><td>yellow, 黄</td></tr>
<tr><td>5</td><td bgcolor=#13a10e></td><td>緑</td><td>green, 緑</td></tr>
<tr><td>6</td><td bgcolor=#0037da></td><td>青</td><td>blue, 青</td></tr>
<tr><td>7</td><td bgcolor=#3a96dd></td><td>水色</td><td>aqua, 水</td></tr>
<tr><td>8</td><td bgcolor=#881798></td><td>紫</td><td>purple, 紫</td></tr>
<tr><td>9</td><td bgcolor=#f2f2f2></td><td>輝く白</td><td>white_b, 白明</td></tr>
<tr><td>10</td><td bgcolor=#767676></td><td>灰色</td><td>gray, black_b, 灰, 黒明</td></tr>
<tr><td>11</td><td bgcolor=#e74856></td><td>明るい赤</td><td>red_b, 赤明</td></tr>
<tr><td>12</td><td bgcolor=#f9f1a5></td><td>明るい黄色</td><td>yellow_b, 黄明</td></tr>
<tr><td>13</td><td bgcolor=#16c60c></td><td>明るい緑</td><td>green_b, 緑明</td></tr>
<tr><td>14</td><td bgcolor=#3b78ff></td><td>明るい青</td><td>blue_b, 青明</td></tr>
<tr><td>15</td><td bgcolor=#61d6d6></td><td>明るい水色</td><td>aqua_b, 水明</td></tr>
<tr><td>16</td><td bgcolor=#b4009e></td><td>明るい紫</td><td>purple_b, 紫明</td></tr></table>
<br>
設定値はアルファベット形式または漢字形式を使用できます。漢字形式は設定ファイルの文字コードがShift_JISのときのみ有効です。
<br>
以下はkey_list.csvの色指定例です。
<pre>
calc,calc,calculator,red
s,services.msc,Services,緑
</pre>

以下はsettings.txtの色指定例です。
<pre>
BACKGROUND_COLOR=black
TEXT_COLOR=青明
</pre>

## インストール方法
1. 同じフォルダに以下のファイルを置きます。
* settings.txt
* key_list.csv
* launcher.bat

2. 任意のディレクトリからランチャーを起動したい場合はPath環境変数に先程のフォルダを追加します。
* ”Windowsキー＋R”でコマンド`systempropertiesadvanced`を実行して、システムの詳細設定から環境変数を変更する。

## 想定する使用方法
`launcher.bat`をコマンドプロンプトなどから手動で実行しても良いですが、以下のいずれかの使用方法を想定しています。
* ”Windowsキー＋R”を入力して「ファイル名を指定して実行」から`launcher.bat`を起動する。
  * Path環境変数を設定してlauncher.batの名前をl.batに変更しておけば、`l`と入力するだけで起動可能。
  * この場合は常駐の設定を"LOOP=NO"にしておくと良い。
* [AutoHotKey](https://www.autohotkey.com/)を使用して`launcher.bat`を起動する。
  * リポジトリにAutoHotKeyのver1用とver2用の設定ファイルサンプルを用意しているので参考にして欲しい（Pauseキーを押すとアクティブまたは起動）。
  * この場合は常駐の設定を"LOOP=YES"にしておくと良い。

## 表示位置の設定
batch-launcherをデスクトップの毎回決まった位置に表示するには、
`launcher.bat`のシンボリックリンクを作成して「ウィンドウの位置」を設定します。
シンボリックリンクを右クリックしてプロパティを表示し、レイアウトタブから設定可能です。
AutoHotKeyなどから起動する場合はこのシンボリックリンクから起動するように変更を忘れずに。
