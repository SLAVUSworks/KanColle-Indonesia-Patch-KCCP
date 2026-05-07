@echo off
 
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'ID-patch-manager\update_notice.ps1'"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'ID-patch-manager\quick_updater.ps1'"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'ID-patch-manager\clear_browser_cache.ps1'"
 
TIMEOUT /T 60