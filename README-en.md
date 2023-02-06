# batch-launcher

[README in Japanese](README.md)

![batch-launcher](png/launcher-en.png)

## Overview
batch-launcher is a launcher created with batch files.
It is possible to execute Windows commands and applications with shortcut keys.

## Feature
* Set "Command", "Shortcut Key" and "Display Name" in CSV file
* Launcher starts in English in non-Japanese environments.
* Commands can be displayed in multiple columns in tabular format.
* Automatically adjust window size.
* Background and text color can be changed.

## Shortcut Key Settings
Enter key_list.csv in the following order, separated by commas ','.

1. Shortcut Key
2. Command
3. Display Name
4. Color

The following are notes.

* The existing settings are samples and should be changed (key_list-jp.csv is a sample for Japanese environment).
* The first line is a comment line.
* Newline code is CR + LF
* Japanese character code is Shift_JIS
* Text editor recommended for editing; Excel deprecated.
* If there is no "Display Name", "Command" shall be used as the "Display Name".
* If "Color" is not specified, follow the "Text Color" setting in settings.txt.
* "Color" is only valid for the fourth entry.

The following is an example setting for accessing a github.com page in Google Chrome. You can specify multiple arguments as well as the name of the command to execute. In this example, typing 'ch' will launch Chrome.

<pre>
ch,"C:\Program Files\Google\Chrome\Application\chrome.exe" https://github.com/,Chrome
</pre>

The following is an example of a setting to start the calculator. The commands and applications set in the PATH environment variable do not need to be in the full path.

<pre>
calc,calc,Calculator,red
</pre>

The following is an example of how to open the "C:\Program Files" folder with Explorer. Simply enter the folder name in the "Command" field. If the folder contains spaces, you need to enclose it with double quotation marks '"'.

<pre>
e,"C:\Program Files"
</pre>

## Launcher main unit settings
You can change the launcher settings at "settings.txt".
|No.|Name|Initial|Format|Description|
|-:|-|-|-|-|
|1|LOOP|YES|YES or NO|resident in an infinite loop|
|2|EXIT_KEY|q|string|exit shortcut key|
|3|BACKGROUND_COLOR|black|color setting value|background color|
|4|TEXT_COLOR|white|color setting value|text color|
|5|COLUMN_NUM|2|integer greater than or equal to 1|number of columns|
|6|DISPLAY_NUMBER|YES|YES or NO|display the number.|
|7|EQUALIZE_CELL_WIDTH|NO|YES or NO|equalize cell widths.|
|8|ARRANGE_VERTICAL|YES|YES or NO|arrange vertically. When 'NO' is selected, horizontally.|

## Color settings
batch-launcher has the following 16 colors available.

<table>
<tr><th>No.</th><th width=50>Color</th><th>Color Name</th><th>Set Values</th></tr>
<tr><td>1</td><td bgcolor=#cccccc></td><td>White</td><td>white, 白</td></tr>
<tr><td>2</td><td bgcolor=#0c0c0c></td><td>Black</td><td>black, 黒</td></tr>
<tr><td>3</td><td bgcolor=#c50f1f></td><td>Red</td><td>red, 赤</td></tr>
<tr><td>4</td><td bgcolor=#c19c00></td><td>Yellow</td><td>yellow, 黄</td></tr>
<tr><td>5</td><td bgcolor=#13a10e></td><td>Green</td><td>green, 緑</td></tr>
<tr><td>6</td><td bgcolor=#0037da></td><td>Blue</td><td>blue, 青</td></tr>
<tr><td>7</td><td bgcolor=#3a96dd></td><td>Aqua</td><td>aqua, 水</td></tr>
<tr><td>8</td><td bgcolor=#881798></td><td>Purple</td><td>purple, 紫</td></tr>
<tr><td>9</td><td bgcolor=#f2f2f2></td><td>Bright White</td><td>white_b, 白明</td></tr>
<tr><td>10</td><td bgcolor=#767676></td><td>Gray</td><td>gray, black_b, 灰, 黒明</td></tr>
<tr><td>11</td><td bgcolor=#e74856></td><td>Light Red</td><td>red_b, 赤明</td></tr>
<tr><td>12</td><td bgcolor=#f9f1a5></td><td>Light Yellow</td><td>yellow_b, 黄明</td></tr>
<tr><td>13</td><td bgcolor=#16c60c></td><td>Light Green</td><td>green_b, 緑明</td></tr>
<tr><td>14</td><td bgcolor=#3b78ff></td><td>Light Blue</td><td>blue_b, 青明</td></tr>
<tr><td>15</td><td bgcolor=#61d6d6></td><td>Light Aqua</td><td>aqua_b, 水明</td></tr>
<tr><td>16</td><td bgcolor=#b4009e></td><td>Light Purple</td><td>purple_b, 紫明</td></tr></table>
<br>
Set values can be in alphabetic or Kanji format. The Kanji format is valid only when the character code of the setting file is Shift_JIS.
<br>
The following is an example of specifying colors in key_list.csv.
<pre>
calc,calc,calculator,red
s,services.msc,Services,緑
</pre>

The following is an example of specifying colors in settings.txt.
<pre>
BACKGROUND_COLOR=black
TEXT_COLOR=青明
</pre>

## How to Install
1. Place the following files in the same folder
* settings.txt
* key_list.csv
* launcher.bat

2. Add the folder mentioned earlier to the Path environment variable.
* Execute the command `systempropertiesadvanced` with "Windows key + R" to change the environment variables in the advanced system settings.

## Intended use
You may run `launcher.bat` from a command prompt or other means, but one of the following uses is assumed.
* Type "Windows key + R" to launch the batch file from "Run".
  * Set the Path environment variable and if you rename launcher.bat to l.bat, you can start it by just typing `l`.
  * In this case, the resident setting should be "LOOP=NO".
* Launch `launcher.bat` from [AutoHotKey](https://www.autohotkey.com/).
  * Please refer to the sample setting files for ver1 and ver2 of AutoHotKey in the repository ( Press Pause key to active or run ).
  * In this case, the resident setting should be "LOOP=YES".

## Display position setting
To display batch-launcher in a fixed position on the desktop each time, you can create a symbolic link for `launcher.bat` and set the "Window Location".
Symbolic links can be set from the Layout tab by right-clicking on the link and displaying its properties.
Don't forget to change it to start from this symbolic link when starting from AutoHotKey, etc.
