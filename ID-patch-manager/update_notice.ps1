# Notifies the user of an update to the English Patch;
$host.ui.RawUI.WindowTitle = "KanColle Indonesia Patch Update Notice";
$ProgressPreference = 'SilentlyContinue';
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path; 
$pwd = $pwd.replace("\","/") + "/";

# Gets the current version;
$IDpatchContent = Get-Content -Raw -Path .\ID-patch.mod.json | ConvertFrom-Json;
$verCur = $IDpatchContent.version;

# Old version names support;
If ($verCur.length -lt 6) {
	If ($verCur.contains("a")) {
		$verCur = $verCur.substring(0,4);
		$verCur += ".1"
	} ElseIf ($verCur.contains("b")) {
		$verCur = $verCur.substring(0,4);
		$verCur += ".2"
	} Else {
		$verCur += ".0"
	}
};

# Compares current version with available versions;
$versionContent = Get-Content -Raw -Path version.json | ConvertFrom-Json;
$verLat = $versionContent.version[$versionContent.count - 1];

Write-Host "Sebuah update untuk Patch Bahasa Inggris KanColle telah tersedia (v$verLat).";
Write-Host "(Anda sedang menggunakan v$verCur)";
Write-Host "Apakah Anda ingin mendownloadnya sekarang?";
Write-Host "-> Tutup jendela ini untuk membatalkan. (No)";
Write-Host "-> Tekan sembarang tombol untuk menjalankan pembaru... (Yes)";

$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode;

Write-Host "";
Write-Host "";