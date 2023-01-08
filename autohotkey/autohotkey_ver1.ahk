Pause::
    IfWinExist, batch-launcher
    {
        WinActivate, batch-launcher
    }
    Else
    {
        Run, "c:\bat\launcher.bat"
    }   
Return
