@echo off

title batch-launcher
setlocal enabledelayedexpansion
set csv_file=%~dp0\key_list.csv

for /f "tokens=1,2 delims=: " %%a in ('powershell -command "Get-WinUserLanguageList"') do set %%a=%%b

if "%EnglishName%" == "Japanese" (
    set "table_header=No.  キー      名前"
    set "exit_message=ランチャーを終了"
    set "key_input_message=キーを入力"
) else (
    set "table_header=No.  Key       name"
    set "exit_message=exit launcher"
    set "key_input_message=input key"
)

for /f "usebackq tokens=1,2 delims==" %%a in ("%~dp0\config.txt") do set %%a=%%b

if not "%WINDOW_SIZE%" == "" mode %WINDOW_SIZE%

if "%RULED_LINE_LEN%" == "" (
    set ruled_line=────────────────────────────────────────
) else (
    set ruled_line=─
    for /l %%i in (1,1,%RULED_LINE_LEN%) do (
        set tmp_line=!ruled_line!
        set ruled_line=─!tmp_line!
    )
)

if "%EXIT_KEY%" == "" set EXIT_KEY=q

:LOOP_START
cls
set n=1
echo %table_header%
echo %ruled_line%
for /f "skip=1 tokens=1,2* delims=," %%i in (%csv_file%) do (
    set num=0!n!
    set num=!num:~-2,2!

    set key=%%i        
    set key=!key:~0,8!

    set content=%%k
    if "!content!" == "" set content=%%j

    echo !num!   !key!  !content!
    set /a n=n+1
)

set num=0!n!
set num=!num:~-2,2!
echo %ruled_line%
echo !num!   %EXIT_KEY%         %exit_message%

echo.

set key=""
set /p key="%key_input_message% ==> "

if "%key%" == "%EXIT_KEY%" goto END

for /f "skip=1 tokens=1,2* delims=," %%i in (%csv_file%) do (
    if %%i==%key% (
         start "" %%j
    )
)

if "%LOOP%" == "YES" goto LOOP_START

:END
