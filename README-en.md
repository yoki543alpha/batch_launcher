# batch-launcher

[README in Japanese](README.md)

![batch-launcher](png/launcher-en.png)

## Overview
batch-launcher is a launcher created with batch files.
It is possible to execute Windows commands and applications with shortcut keys.

## Feature
* Set "commands" and "shortcut keys" in the CSV file.
* Although created for Japanese users, the launcher launches in English in non-Japanese environments.

## Shortcut Key Settings
Enter key_list.csv in the following order, separated by commas ','.

1. shortcut key
2. command
3. display name

The following are notes.

*  The existing contents are samples and should be changed (key_list-jp.csv is a sample for Japanese environment).
* Text editor recommended for editing; Excel deprecated.
* The first line is a comment line.
* If there is no "display name", "command" shall be used as the "display name".

## Launcher main unit settings
The following settings can be configured by changing config.txt.
* Resident in an infinite loop (initial : NO)
* Window Size (initial : 45 x 25)
* Length of table rules (initial : 40)
* Key to exit (initial : q)

## How to Install
1. Place the following files in the same folder
* config.txt
* key_list.csv
* launcher.bat

2. Add the folder mentioned earlier to the Path environment variable.
* Execute the command `systempropertiesadvanced` with "Windows key + R" to change the environment variables in the advanced system settings.

## Intended use
You may run `launcher.bat` from a command prompt or other means, but one of the following uses is assumed.
* Type "Windows key + R" to launch the batch file from "Run".
  * If you rename launcher.bat to l.bat, you can start it by just typing `l`.
* Launch `launcher.bat` from [AutoHotKey](https://www.autohotkey.com/).
  * Please refer to the sample configuration files for ver1 and ver2 of AutoHotKey in the repository ( Press Pause key to active or run ).
  * In this case, the resident setting should be YES.

## Display position setting
To display batch-launcher in a fixed position on the desktop each time, you can create a symbolic link for `launcher.bat` and set the "Window Location".
Symbolic links can be configured from the Layout tab by right-clicking on the link and displaying its properties.
Don't forget to change it to start from this symbolic link when starting from AutoHotKey, etc.
