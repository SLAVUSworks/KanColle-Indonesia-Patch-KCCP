@echo off
 
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'ID-patch-manager\new_font_beta_test.ps1'"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'ID-patch-manager\clear_browser_cache.ps1'"
 
TIMEOUT /T 60