Pause::
{
    if WinExist("batch-launcher")
    {
        WinActivate "batch-launcher"
    }
    else
    {
        Run "c:\bat\launcher.bat"
    }   
}