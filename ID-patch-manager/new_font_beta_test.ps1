# Simple program to move the new experimental font in the patch;
$host.ui.RawUI.WindowTitle = "KanColle Indonesia Patch New Font Beta Test";
$ProgressPreference = 'SilentlyContinue';
If ($PSversion -gt 4) {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

Write-Host "Selamat datang di installer font eksperimental baru KanColle Indonesia Patch!";
Write-Host "Anda dapat menggunakan installer ini untuk menguji font baru di mana";
Write-Host "Patch Bahasa Inggris akan berdasarkan teks mentahnya di masa depan.";
Write-Host "";
Write-Host "Anda dapat menemukan font di ID-patch/kcs2/resources/" -ForegroundColor Yellow;
Write-Host "Jika Anda tidak ingin menggunakan font lagi, hapus folder 'font' di dalamnya." -ForegroundColor Yellow;
Write-Host "";
Write-Host "-> Tutup jendela ini untuk membatalkan.";
Write-Host "-> Tekan tombol apa saja untuk menginstal...";

$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path;
$pwd = $pwd.replace("\","/") + "/";

# Copies the font folder on the root to the correct location;
Copy-Item -Path ($pwd + "font") -Destination ($pwd + "ID-patch/kcs2/resources") -Recurse -Force;

Write-Host "";
Write-Host "Installasi selesai! Memproses untuk menghapus cache..." -ForegroundColor Green;
Write-Host "";
Write-Host "";
