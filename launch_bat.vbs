Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & ".\ID-patch-manager\update_checker.bat" & Chr(34), 0
Set WshShell = Nothing