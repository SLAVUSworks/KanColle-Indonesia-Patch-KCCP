# Simple updater to update the Indonesia Patch;
$host.ui.RawUI.WindowTitle = "KanColle Indonesia Patch Quick Updater v0.6.0";
$PSversion = $PSVersionTable.PSVersion.Major;
If ($PSversion -lt 5) {
	Write-Host "Selamat datang di KanColle Indonesia Patch Quick Updater v0.6.0!";
	Write-Host "";
	Write-Host "Versi PowerShell Anda tidak didukung." -ForegroundColor Red;
	Write-Host "";
	Write-Host "Anda dapat mengunduh versi yang didukung di sini:";
	Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=54616";
	Write-Host "Klik unduh, dan pilih `"Win7-KB3191566-x86.zip`"";
	Write-Host "atau `"Win8.1-KB3191564-x86.msu`" tergantung pada sistem operasi Anda.";
	Write-Host "Kemudian, jalankan file yang telah diunduh.";
	Write-Host "Cache clearer telah bekerja pada versi Anda,";
	Write-Host "jadi Anda dapat melanjutkan untuk menghapus cache Anda sekarang jika Anda mau.";
	Write-Host "";
	Write-Host "-> Tahan tombol Ctrl dan klik tautan untuk membukanya.";
	Write-Host "-> Tutup jendela ini untuk tidak melanjutkan menghapus cache Anda.";
	Write-Host "-> Tekan sembarang tombol (kecuali Ctrl) untuk melanjutkan menghapus cache Anda...";
	Do {
		$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
	} Until ($PressedKey -ne 17)
	Write-Host "";
	Write-Host "";
	Exit
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

Write-Host "Selamat datang di Pembaru Cepat Patch Bahasa Indonesia KanColle v0.6.0!";
Write-Host "Anda dapat menggunakan updater ini untuk memperbarui patch Anda dari v3.01 atau yang lebih baru ke versi terbaru.";
Write-Host "";
Write-Host "Program ini dapat memicu beberapa anti-virus." -ForegroundColor Yellow;
Write-Host "Ini adalah hasil positif palsu dan dapat diabaikan." -ForegroundColor Yellow;
Write-Host "Saya sarankan untuk memasukkan folder English Patch ke dalam daftar putih di anti-virus Anda." -ForegroundColor Yellow;
Write-Host "Jika terjadi sesuatu, sebuah zip yang berisi file-file yang diperlukan telah disediakan." -ForegroundColor Yellow;
Write-Host "Anda dapat mengekstrak zip-nya untuk mengembalikan manajer ke kondisi semula." -ForegroundColor Yellow;
Write-Host "";
Write-Host "Pastikan Anda terhubung ke Internet sebelum memperbarui!" -ForegroundColor Yellow;
Write-Host "Ini bisa memakan waktu cukup lama, pastikan Anda menunggu sampai selesai!" -ForegroundColor Yellow;
Write-Host "";
Try {
	$previousVersion = Get-Content -Raw -Path .\ID-patch-manager\download_interrupted.txt -ErrorAction Stop; # Load the download_interrupted.txt file as an array of its lines;
	$downloadInterrupted = $true;
	Write-Host "Updater tidak ditutup dengan benar penggunaan terakhir kali." -ForegroundColor Red;
	Write-Host "Ini akan mengulang download dari v$previousVersion." -ForegroundColor Red;
	Write-Host "";
} Catch {
	$downloadInterrupted = $false
};
Write-Host "-> Tutup jendela ini untuk membatalkan.";
Write-Host "-> Tekan tombol apa saja untuk memperbarui...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host "";
Write-Host "Memperbarui version.json...";

# Gets and tweaks the current path. Will only work if the script is ran from the master directory;
$pwd = Get-Location | select -ExpandProperty Path; 
$pwd = $pwd.replace("\","/") + "/";

# Gets the online path and the file containing diff info;
$gitPath = "https://raw.githubusercontent.com/SLAVUSworks/KanColle-Indonesia-Patch-KCCP/master/";
Invoke-WebRequest ($gitPath + "version.json") -O ($pwd + "version.json"); 

Write-Host "";
Write-Host "Parsing contents...";

# Gets the current version;
$IDpatchContent = Get-Content -Raw -Path .\ID-patch.mod.json | ConvertFrom-Json;
If ($downloadInterrupted) {
	$verCur = $previousVersion
} Else {
	$verCur = $IDpatchContent.version
}

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
# Adds deleted files and new/modified files from newer versions in arrays;
$versionContent = Get-Content -Raw -Path version.json | ConvertFrom-Json;
[bool] $verNewFlag = $false;
$delURI = New-Object System.Collections.ArrayList($null);
$addURI = New-Object System.Collections.ArrayList($null);
$i = 0;
$j = 0;
ForEach ($ver in $versionContent.version) {
	If ($verNewFlag) {
		$verNew = $versionContent[$i];
		$delURI += ,@($verNew.del);
        $delURI[$j] = [System.Collections.ArrayList]$delURI[$j];
		$addURI += ,@($verNew.add);
        $addURI[$j] = [System.Collections.ArrayList]$addURI[$j];
        $j += 1
	} ElseIf ($ver -eq $verCur) {
		$verNewFlag = $true
	}
	$i += 1
};
$verSkip = $j - 1;

# If current version is the same as the latest;
If ($j -eq 0) {
	Write-Host "Tidak ada versi baru yang tersedia, atau versi saat ini tidak valid." -ForegroundColor Yellow;
	Write-Host "Jika Anda masih menggunakan v1 atau v2 dari Patch Bahasa Inggris," -ForegroundColor Yellow;
	Write-Host "Silakan dapatkan versi terbaru dari GitHub." -ForegroundColor Yellow;
	Write-Host "";
	Write-Host "-> Tutup jendela ini untuk tidak melanjutkan menghapus cache Anda.";
	Write-Host "-> Tekan sembarang tombol untuk melanjutkan menghapus cache Anda...";
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Write-Host "";
	Write-Host "";
	Exit
};

$downloadInterruptedFile = ".\ID-patch-manager\download_interrupted.txt";
$verCur | Out-File $downloadInterruptedFile -NoNewline;

# Removes any duplicate mention of added/modified files;
For ($i = $verSkip; $i -ge 1; $i--) {
	For ($j = $i - 1; $j -ge 0; $j--) {
		ForEach ($k in $addURI[$i]) {
			If ($addURI[$j] -contains $k) {
				$addURI[$j].Remove($k)
			}
		}
	}
};

Write-Host "";
Write-Host "Memperbarui...";
# Deletes then downloads each mentionned file, version after version;
$sw = [System.Diagnostics.Stopwatch]::StartNew();
$fileHistory = New-Object System.Collections.ArrayList($null);
For ($i = 0; $i -le $verSkip; $i++) {
	$a = $i + 1;
	$b = $verSkip + 1;
	$u = $versionContent[$versionContent.count - $b + $i].version;
	Write-Progress -Activity 'Memperbarui Indonesia Patchnya...' -Status "Update $a out of $b (v$u)" `
		-PercentComplete ([Math]::Floor($a / $b * 100))
	$j = 0;
    ForEach ($uri in $delURI[$i]) {
		If (Test-Path -Path ($pwd + $uri)) {
			if ($sw.Elapsed.TotalMilliseconds -ge 200) {
				$c = $j + 1;
				$d = $delURI[$i].count;
				Write-Progress -ID 1 -Activity 'Menghapus file...' -Status "File $c out of $d" `
					-PercentComplete ([Math]::Floor($c / $d * 100))
				$sw.Restart();
				$fileHistory | Out-Host;
				$fileHistory.clear()
			};
			Remove-Item -Path ($pwd + $uri) -Recurse -Force;
			$fileHistory += "Deleted $uri";
			$j++
		}
    };
	$k = 0;
	ForEach ($uri in $addURI[$i]) {
		if ($sw.Elapsed.TotalMilliseconds -ge 200) {
			$c = $k + 1;
			$d = $addURI[$i].count;
			Write-Progress -ID 1 -Activity 'Mengunduh files...' -Status "File $c out of $d" `
				-PercentComplete ([Math]::Floor($c / $d * 100))
			$sw.Restart();
			$fileHistory | Out-Host;
			$fileHistory.clear()
		};
		Try {
			$ProgressPreference = 'SilentlyContinue';
			Invoke-WebRequest ($gitPath + $uri) -O (New-Item -Path ($pwd + $uri) -Force);
			$fileHistory += "Terunduh $uri";
			$ProgressPreference = 'Continue'
		} Catch [System.Net.WebException] {
			$fileHistory += "Dilewat $uri (File terhapus dari server)"
			$ProgressPreference = 'Continue';
		};
		$k++
    };
	$fileHistory.clear()
};

Write-Host "";
Write-Host "Done updating! Proceeding to cache clear..." -ForegroundColor Green;
Write-Host "";
Write-Host "";

Remove-Item -Path ($downloadInterruptedFile) -Recurse -Force
