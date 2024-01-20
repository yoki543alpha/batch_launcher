@echo off

title batch-launcher
setlocal enabledelayedexpansion
set csv_file=%~dp0\key_list.csv
set settings_file=%~dp0\settings.txt
set launcher_txt=%TEMP%\batch-launcher.txt
set winset_txt=%TEMP%\winset.txt

for /f "tokens=1,2 delims=:" %%a in ('chcp') do set chcp_num=%%b

if %chcp_num% equ 932 (
    set "table_header_key_name=キー      名前"
    set "table_header_num=No." 
    set "exit_message=ランチャーを終了"
    set "key_input_message=キーを入力"
    set "line_cha=─"
    set "delim_cha=│"
) else (
    set "table_header_key_name=Key       name"
    set "table_header_num=No." 
    set "exit_message=exit launcher"
    set "key_input_message=input key"
    set "line_cha=-"
    set "delim_cha=|"
)

for /f "usebackq tokens=1,2 delims==" %%a in (%settings_file%) do set %%a=%%b

set count=0
for /f "skip=1" %%a in (%csv_file%) do set /a count=count+1
set /a total=count

set TIME_REDUCTION=NO
if exist %launcher_txt% (
    call:get_file_timestamp %launcher_txt% stamp_launcher
    call:get_file_timestamp %csv_file% stamp_csv
    if "!stamp_launcher!" gtr "!stamp_csv!" (
        call:get_file_timestamp %settings_file% stamp_settings
        if "!stamp_launcher!" gtr "!stamp_settings!" set TIME_REDUCTION=YES
    )
)

if %total% lss %COLUMN_NUM% set COLUMN_NUM=%total%

set /a line_num=%total%/%COLUMN_NUM%
set /a mod=%total%%%COLUMN_NUM%
if %mod% neq 0 set /a line_num+=1

set count=1
set contents_len_max=0
set item_total=0
if "%TIME_REDUCTION%" == "YES" (
    for /f "skip=1 tokens=1,2,3* delims=," %%a in (%csv_file%) do (
        set keys[!count!]=%%a
        set commands[!count!]=%%b
        set /a count=count+1
    )
    set /a item_total=!count!-1

    for /f "usebackq tokens=1,2 delims==" %%a in (%winset_txt%) do set %%a=%%b

    goto DISPLAY_START
) else if "%ARRANGE_VERTICAL%" == "YES" (
    for /f "skip=1 tokens=1,2,3* delims=," %%a in (%csv_file%) do (
        set content=%%c
        if "!content!" == "" set content=%%b

        set /a x=!count!/!line_num!
        set /a x0=!count!%%!line_num!
        if !x0! neq 0 set /a x+=1

        set /a y=!count!%%!line_num!
        if !y! equ 0 set /a y=!line_num!

        set /a p=!column_num!*!y!-!column_num!+!x!
        if !item_total! lss !p! set item_total=!p!

        call:get_strlen !content!
        set strlen=!ERRORLEVEL!
        set column_len[!p!]=!strlen!
        if !strlen! gtr !contents_len_max! set contents_len_max=!strlen!

        set keys[!p!]=%%a
        set contents[!p!]=!content!
        set commands[!p!]=%%b
        set colors[!p!]=%%d
        set counts[!p!]=!count!

        set /a count=count+1
    )
) else (
    for /f "skip=1 tokens=1,2,3* delims=," %%a in (%csv_file%) do (
        set content=%%c
        if "!content!" == "" set content=%%b

        call:get_strlen !content!
        set strlen=!ERRORLEVEL!
        set column_len[!count!]=!strlen!
        if !strlen! gtr !contents_len_max! set contents_len_max=!strlen!

        set keys[!count!]=%%a
        set contents[!count!]=!content!
        set commands[!count!]=%%b
        set colors[!count!]=%%d
        set counts[!count!]=!count!

        set /a count=count+1
    )

    set /a item_total=!count!-1
)

for /L %%i in (1,1,%COLUMN_NUM%) do set /a column_len_max[%%i]=0

for /L %%i in (1,1,!item_total!) do (
    set /a r=%%i%%%COLUMN_NUM%
    if !r! equ 0 set r=%COLUMN_NUM%
    if defined column_len[%%i] call:update_column_maxlen !r! !column_len[%%i]!
)

set column_total=%COLUMN_NUM%
for /L %%i in (%COLUMN_NUM%,-1,1) do (
    if !column_len_max[%%i]! equ 0 set /a column_total=%%i-1
)

if "%EQUALIZE_CELL_WIDTH%" == "YES" (
    for /L %%i in (1,1,%column_total%) do set /a column_len_max[%%i]=!contents_len_max!
)

for /L %%i in (1,1,!item_total!) do (
    if defined contents[%%i] (
        set /a r=%%i%%%COLUMN_NUM%
        if !r! equ 0 set r=%COLUMN_NUM%

        call:get_maxlen !r!
        set maxlen=!ERRORLEVEL!

        call:add_space %%i !maxlen!
    )
)

call:create_console_color "%BACKGROUND_COLOR%" "%TEXT_COLOR%" CONSOLE_COLOR
echo CONSOLE_COLOR=%CONSOLE_COLOR% > %winset_txt%

set bg_color=%CONSOLE_COLOR:~0,1%
set fg_color=%CONSOLE_COLOR:~1,1%

call:get_echo_color %bg_color% echo_bg_color
if "%echo_bg_color%" == "" set echo_bg_color=30

call:get_echo_color %fg_color% echo_fg_color
if "%echo_fg_color%" == "" set echo_fg_color=37

set correct_len=0
if "%DISPLAY_NUMBER%" == "YES" set correct_len=4

set ruled_line_len=0
for /L %%i in (1,1,%column_total%) do (
    set /a ruled_line_len=ruled_line_len+!column_len_max[%%i]!+13+%correct_len%
)

set /a width=%ruled_line_len%+3
set /a height=!line_num!+7
set auto_window_size=%width%,%height%

if not "%WINDOW_SIZE%" == "" (
    set WSIZE=%WINDOW_SIZE%
) else (
    set WSIZE=%auto_window_size%
)
echo WSIZE=%WSIZE% >> %winset_txt%

set ruled_line=%line_cha%
for /L %%i in (1,1,%ruled_line_len%) do (
    set ruled_line=%line_cha%!ruled_line!
)

if "%DISPLAY_NUMBER%" == "YES" (
    set "table_header_base=%table_header_num% %table_header_key_name%"
) else (
    set "table_header_base=%table_header_key_name%"
)

call:get_strlen %table_header_base%
set table_header_base_len=!ERRORLEVEL!

for /L %%i in (1,1,%column_total%) do (
    set heads[%%i]=%table_header_base%
)

for /L %%i in (1,1,%column_total%) do (
    call::add_space_header %%i "%table_header%"
)

set table_header=
for /L %%i in (1,1,%column_total%) do (
    if %%i equ 1 (
        set "table_header= !heads[%%i]!"
    ) else (
        set "table_header=!table_header!^^%delim_cha% !heads[%%i]!"
    )
)

if "%EXIT_KEY%" == "" set EXIT_KEY=q

for /f %%e in ('cmd /k prompt $e^<nul') do set ESC=%%e

set numL=1
for /L %%i in (1,1,!item_total!) do (
    set /a r=%%i%%%COLUMN_NUM%
    if !r! equ 0 set r=%COLUMN_NUM%

    if defined contents[%%i] (
        call:create_one_line !numL! !r! %%i

        set flag=FALSE
        if !r! equ %COLUMN_NUM% set flag=TRUE
        if %%i equ !item_total! set flag=TRUE
        if !flag! == TRUE set /a numL=numL+1
    ) else if !r! equ %COLUMN_NUM% (
        set /a numL=numL+1
    )
)

echo %table_header% > %launcher_txt%
echo %ruled_line% >> %launcher_txt%

for /L %%i in (1,1,%line_num%) do (
    echo !line[%%i]! >> %launcher_txt%
)

echo %ruled_line% >> %launcher_txt%

if "%DISPLAY_NUMBER%" == "YES" (
    set /a last_count=total+1
    set num=  !last_count!
    set num=!num:~-3,3!
    echo !num!  %EXIT_KEY%         %exit_message% >> %launcher_txt%
) else (
    echo  %EXIT_KEY%         %exit_message% >> %launcher_txt%
)

echo. >> %launcher_txt%

:DISPLAY_START
color %CONSOLE_COLOR%
mode %WSIZE%

:LOOP_START
cls
type %launcher_txt%

set key=""
set /p key="%key_input_message%==> "

if "%key%" == "%EXIT_KEY%" goto LOOP_END

for /L %%i in (1,1,!item_total!) do (
     if defined keys[%%i] if !keys[%%i]!==%key% (
          start "" !commands[%%i]!
     )
)

if "%LOOP%" == "YES" goto LOOP_START
:LOOP_END

exit /b

:get_strlen
    (echo "%*" & echo.) | findstr /O . | more +1 | (set /P RESULT= & call exit /B %%RESULT%%)
    set /A STRLENGTH=%ERRORLEVEL%-5
exit /b %STRLENGTH%

:get_echo_color
    setlocal
    if "%1" == "0" set echo_color=30
    if "%1" == "1" set echo_color=34
    if "%1" == "2" set echo_color=32
    if "%1" == "3" set echo_color=36
    if "%1" == "4" set echo_color=31
    if "%1" == "5" set echo_color=35
    if "%1" == "6" set echo_color=33
    if "%1" == "7" set echo_color=37
    if "%1" == "8" set echo_color=90
    if "%1" == "9" set echo_color=94
    if "%1" == "A" set echo_color=92
    if "%1" == "B" set echo_color=96
    if "%1" == "C" set echo_color=91
    if "%1" == "D" set echo_color=95
    if "%1" == "E" set echo_color=93
    if "%1" == "F" set echo_color=97
    if "!echo_color!" == "" echo NG:"%1"
    endlocal && set %2=%echo_color%
exit /b

:update_column_maxlen
    set num=%1
    set len=%2

    if %len% gtr !column_len_max[%num%]! set /a column_len_max[%num%]=%len%
exit /b

:get_maxlen
    set num=%1

    for /L %%k in (1,1,%COLUMN_NUM%) do (
        if %%k equ %num% exit /b !column_len_max[%%k]!
    )
exit /b 0

:add_space
    set num=%1
    set maxlen=%2

    set content=!contents[%num%]!
    set /a sp_len=%maxlen%-!column_len[%num%]!

    if !sp_len! leq 0 exit /b

    for /L %%i in (1,1,!sp_len!) do (
        set content=!content! 
    )

    set contents[%num%]=!content!
exit /b

:add_space_header
    set num=%1

    set /a sp_len=!column_len_max[%num%]!-%table_header_base_len%+11+%correct_len%

    set head1=!heads[%num%]!
    for /L %%i in (1,1,!sp_len!) do (
        set head1=!head1! 
    )

    set heads[%num%]=!head1!
exit /b

:create_one_line
    set ln_num=%1
    set col_num=%2
    set for_count=%3

    set key=!keys[%for_count%]!        
    set key=!key:~0,8!

    set color=!colors[%for_count%]!

    if "%DISPLAY_NUMBER%" == "YES" (
        set num=  !counts[%for_count%]!
        set num=!num:~-3,3!
        set line=!num!  !key!  !contents[%for_count%]!
    ) else (
        set line= !key!  !contents[%for_count%]!
    )

    if not "!color!" == "" (
        if "!color!" == "黒" set c_num=30
        if "!color!" == "赤" set c_num=31
        if "!color!" == "緑" set c_num=32
        if "!color!" == "黄" set c_num=33
        if "!color!" == "青" set c_num=34
        if "!color!" == "紫" set c_num=35
        if "!color!" == "水" set c_num=36
        if "!color!" == "白" set c_num=37

        if "!color!" == "black"  set c_num=30
        if "!color!" == "red"    set c_num=31
        if "!color!" == "green"  set c_num=32
        if "!color!" == "yellow" set c_num=33
        if "!color!" == "blue"   set c_num=34
        if "!color!" == "purple" set c_num=35
        if "!color!" == "aqua"   set c_num=36
        if "!color!" == "white"  set c_num=37

        if "!color!" == "灰"   set c_num=90
        if "!color!" == "黒明" set c_num=90
        if "!color!" == "赤明" set c_num=91
        if "!color!" == "緑明" set c_num=92
        if "!color!" == "黄明" set c_num=93
        if "!color!" == "青明" set c_num=94
        if "!color!" == "紫明" set c_num=95
        if "!color!" == "水明" set c_num=96
        if "!color!" == "白明" set c_num=97

        if "!color!" == "gray"     set c_num=90
        if "!color!" == "black_b"  set c_num=90
        if "!color!" == "red_b"    set c_num=91
        if "!color!" == "green_b"  set c_num=92
        if "!color!" == "yellow_b" set c_num=93
        if "!color!" == "blue_b"   set c_num=94
        if "!color!" == "purple_b" set c_num=95
        if "!color!" == "aqua_b"   set c_num=96
        if "!color!" == "white_b"  set c_num=97
        set line=%ESC%[!c_num!m!line!%ESC%[%echo_bg_color%;%echo_fg_color%m
    )

    if %col_num% equ 1 (
        set "line[%ln_num%]=!line!"
    ) else if defined contents[%for_count%] (
        set "line[%ln_num%]=!line[%ln_num%]! ^%delim_cha%!line!"
    )
exit /b

:get_console_color
    setlocal
    set color_name=%~1

    set concole_color_num=X
    if not "%color_name%" == "" (
        if "%color_name%" == "黒"   set concole_color_num=0
        if "%color_name%" == "青"   set concole_color_num=1
        if "%color_name%" == "緑"   set concole_color_num=2
        if "%color_name%" == "水"   set concole_color_num=3
        if "%color_name%" == "赤"   set concole_color_num=4
        if "%color_name%" == "紫"   set concole_color_num=5
        if "%color_name%" == "黄"   set concole_color_num=6
        if "%color_name%" == "白"   set concole_color_num=7
        if "%color_name%" == "灰"   set concole_color_num=8
        if "%color_name%" == "黒明" set concole_color_num=8
        if "%color_name%" == "青明" set concole_color_num=9
        if "%color_name%" == "緑明" set concole_color_num=A
        if "%color_name%" == "水明" set concole_color_num=B
        if "%color_name%" == "赤明" set concole_color_num=C
        if "%color_name%" == "紫明" set concole_color_num=D
        if "%color_name%" == "黄明" set concole_color_num=E
        if "%color_name%" == "白明" set concole_color_num=F

        if "%color_name%" == "black"    set concole_color_num=0
        if "%color_name%" == "blue"     set concole_color_num=1
        if "%color_name%" == "green"    set concole_color_num=2
        if "%color_name%" == "aqua"     set concole_color_num=3
        if "%color_name%" == "red"      set concole_color_num=4
        if "%color_name%" == "purple"   set concole_color_num=5
        if "%color_name%" == "yellow"   set concole_color_num=6
        if "%color_name%" == "white"    set concole_color_num=7
        if "%color_name%" == "gray"     set concole_color_num=8
        if "%color_name%" == "black_b"  set concole_color_num=8
        if "%color_name%" == "blue_b"   set concole_color_num=9
        if "%color_name%" == "green_b"  set concole_color_num=A
        if "%color_name%" == "aqua_b"   set concole_color_num=B
        if "%color_name%" == "red_b"    set concole_color_num=C
        if "%color_name%" == "purple_b" set concole_color_num=D
        if "%color_name%" == "yellow_b" set concole_color_num=E
        if "%color_name%" == "white_b"  set concole_color_num=F
        if "!concole_color_num!" == "X" echo NG:"%color_name%"
    )
    endlocal && set %2=%concole_color_num%
exit /b

:create_console_color
    setlocal
    set "bg_color_name=%~1"
    set "fg_color_name=%~2"

    call:get_console_color "%bg_color_name%" bg_color
    call:get_console_color "%fg_color_name%" fg_color

    set console_color=07
    if not "%bg_color%" == "X" if not "%fg_color%" == "X" set console_color=%bg_color%%fg_color%

    endlocal && set %3=%console_color%
exit /b

:get_file_timestamp
    setlocal
    set "filepath=%~1"

    for %%f in (%filepath%) do (
        set dirname=%%~dpf
        set filename=%%~nxf
    )

    cd %dirname%
    for /F "tokens=2,3" %%A in ('where /T %%filename%%') do (
        set STAMP=%%A_%%B
        echo %STAMP% | findstr _[0-9]: > nul && set STAMP=%STAMP:_=_0%
    )

    endlocal && set %2=%STAMP%
exit /b
