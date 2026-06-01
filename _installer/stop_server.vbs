Option Explicit
Dim WshShell, ResultCode
Set WshShell = CreateObject("WScript.Shell")
' หยุด process บน port 3300
WshShell.Run "cmd /c for /f ""tokens=5"" %a in ('netstat -aon ^| findstr "":3300 ""') do taskkill /PID %a /F >nul 2>&1", 0, True
Set WshShell = Nothing
