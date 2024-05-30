@echo off

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\kc_id_patch_update_checker.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%~dp0\launch_bat.vbs" >> %SCRIPT%
echo oLink.WorkingDirectory = "%~dp0" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%

echo Pemeriksa pembaruan diaktifkan!
echo Sebuah file Visual Basic yang tersembunyi sekarang akan dijalankan setiap kali Anda menjalankan sistem.
echo Ini hanya akan memeriksa apakah versi saat ini lebih rendah dari yang terbaru.
echo Jika tidak, maka akan langsung menutup sendiri.
echo Jika ya, maka akan meminta Anda untuk mengunduh versi terbaru.
echo Jika Anda pernah memindahkan folder Patch Bahasa Indonesia atau mengganti namanya,
echo Anda harus menonaktifkan pemeriksa pembaruan dan mengaktifkannya lagi.
echo ~
echo Program ini dapat memicu beberapa anti virus.
echo Ini adalah hasil positif palsu dan dapat diabaikan.
echo Saya akan merekomendasikan untuk memasukkan folder Indonesia Patch ke dalam daftar putih di anti-virus Anda.
echo Jika terjadi sesuatu, sebuah zip yang berisi file yang diperlukan telah disediakan.
echo Anda dapat mengekstrak zip-nya untuk mengembalikan manajer ke kondisi semula.
echo ~
echo Anda sekarang dapat menutup jendela ini.
pause

