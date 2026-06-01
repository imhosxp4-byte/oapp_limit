Option Explicit

Dim WshShell, fso, strDir, nodeExe, c, i
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' ── ตำแหน่งติดตั้งโปรแกรม ─────────────────────────────────────────────────
strDir = fso.GetParentFolderName(WScript.ScriptFullName)

' ── หา node.exe จาก path ที่รู้จัก ────────────────────────────────────────
Dim candidates(3)
candidates(0) = WshShell.ExpandEnvironmentStrings("%ProgramFiles%\nodejs\node.exe")
candidates(1) = WshShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%\nodejs\node.exe")
candidates(2) = WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\Programs\nodejs\node.exe")
candidates(3) = WshShell.ExpandEnvironmentStrings("%SystemDrive%\Program Files\nodejs\node.exe")

nodeExe = ""
For i = 0 To 3
    If fso.FileExists(candidates(i)) Then
        nodeExe = candidates(i)
        Exit For
    End If
Next

' fallback ถ้าไม่เจอ full path ให้ใช้ชื่อจาก PATH
If nodeExe = "" Then nodeExe = "node"

' ── หยุด process ที่ใช้ port 3300 (ถ้ามี) ──────────────────────────────────
On Error Resume Next
WshShell.Run "cmd /c for /f ""tokens=5"" %a in ('netstat -aon ^| findstr "":3300 ""') do taskkill /PID %a /F >nul 2>&1", 0, True
On Error GoTo 0

WScript.Sleep 800

' ── เปิด Node.js server แบบ hidden (ไม่มี command prompt) ──────────────────
WshShell.CurrentDirectory = strDir
WshShell.Run Chr(34) & nodeExe & Chr(34) & " server.js", 0, False

' ── รอให้ server พร้อม แล้วเปิด browser ───────────────────────────────────
WScript.Sleep 3000
WshShell.Run "http://localhost:3300"

Set fso = Nothing
Set WshShell = Nothing
