# Simple program to clear some Chromium browsers' cache;
$Host.UI.RawUI.WindowTitle = "Browser/Viewer Cache Clear";
$ProgressPreference = 'SilentlyContinue';
If ($PSversion -gt 4) {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Write-Host "Selamat datang di Browser Cache Clearer!";
Write-Host "Membersihkan cache browser Anda adalah wajib agar dapat menggunakan aset patch terbaru.";
Write-Host "Anda dapat menggunakan program kecil ini untuk melakukan hal ini!";
Write-Host "Ini juga akan memulai ulang KCCacheProxy untuk memuat ulang data mod Anda jika berjalan.";
Write-Host "";
Write-Host "Setiap peramban/penampil yang Anda pilih akan ditutup," -ForegroundColor yellow;
Write-Host "pastikan pekerjaan/game yang sedang berjalan telah tersimpan/selesai!" -ForegroundColor yellow;
Write-Host "Anda dapat memulihkan sesi Anda setelah itu dengan memulai ulang browser/penampil Anda secara manual." -ForegroundColor yellow;
Write-Host "Jika Anda tidak ingin menutup browser Anda, silakan hapus cache Anda secara manual." -ForegroundColor yellow;
Write-Host "";
Write-Host "Saat membersihkan cache secara manual, pastikan untuk mengatur rentang Waktu ke Semua waktu," -ForegroundColor yellow;
Write-Host "dan pilih hanya gambar dan file yang di-cache." -ForegroundColor yellow;
Write-Host "";
Write-Host "Jika browser/penampil Anda tidak ada dalam daftar,";
Write-Host "Anda harus menghapus cache browser/penampil Anda secara manual.";
Write-Host "Hubungi oradimi (sebelumnya Oradimi#8947) di Discord untuk menambahkan dukungan pada peramban/penampil Anda.";
Write-Host "Selain itu, peramban portabel (dengan jalur variabel) saat ini tidak didukung.";
Write-Host "";

Try {
	$loadFile = Get-Content -Raw -Path .\ID-patch-manager\browserprefs.json -ErrorAction Stop | ConvertFrom-Json; # Load the version.json file and convert as a readonly powershell object
	[System.Collections.ArrayList] $TaskkillList += $loadFile;
	ForEach ($k in $TaskkillList) {
		Switch ($k) {
			69 {$currentBrowsers += "[E] Poi, "} # Poi;
			82 {$currentBrowsers += "[R] Electronic Observer, "} # ElectronicObserver;
			84 {$currentBrowsers += "[T] Chromium/Google Chrome, "} # Chromium and Google Chrome;
			89 {$currentBrowsers += "[Y] Microsoft Edge, "} # Microsoft Edge;
			85 {$currentBrowsers += "[U] Opera/GX, "} # Opera and Opera GX;
			73 {$currentBrowsers += "[I] Brave, "} # Brave;
			79 {$currentBrowsers += "[O] Vivaldi, "} # Vivaldi;
			80 {$currentBrowsers += "[P] Yandex, "} # Yandex;
		};
	};
	$currentBrowsers = $currentBrowsers.TrimEnd(", ") + ".";
} Catch {
	Write-Host "Berkas preferensi tidak ditemukan!!";
	Write-Host "";
	$TaskkillList = New-Object System.Collections.ArrayList($null);
};

If ($TaskkillList.Count -eq 0) {
	Write-Host "-> Tutup jendala ini untuk membatalkan.";
	Write-Host "-> Tekan tombol apa saja untuk lanjut ke pemilihan...";
	$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
} Else {
	Write-Host "Currently Selected Browsers:" $currentBrowsers;
	Write-Host "-> Tekan ESCAPE untuk mengubah browser yang tersimpan.";
	Write-Host "-> Tutup jendala ini untuk membatalkan.";
	Write-Host "-> Tekan ENTER untuk menghapus cache browser.";
	Do {
		$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
		If ($PressedKey -eq 13) {
			Write-Host "";
		}
	} Until ($PressedKey -eq 27 -or $PressedKey -eq 13)
};



If ($PressedKey -eq 27 -or $TaskkillList.Count -eq 0) {
	# Asks for the browsers the user wants to clear the cache from;
	$FullList = @(69,82,84,89,85,73,79,80);
	$Notice = "";
	Write-Host "";
	Write-Host "[E] Poi        [R] EO     [T] Chrome/Chromium  [Y] Microsoft Edge";
	Write-Host "[U] Opera(GX)  [I] Brave  [O] Vivaldi          [P] Yandex";
	Write-Host "";
	Do {
		If ($TaskkillList.Count -eq 0) {
			Write-Host "-> Gunakan Kunci di atas untuk menambah/menghapus ke dalam list hapus cache.";
			Write-Host "-> Tekan ENTER untuk memberishkan segalanya ( Tidak ada preferensi yang disimpan )."
		} Else {
			$currentBrowsers = "";
			ForEach ($k in $TaskkillList) {
				Switch ($k) {
					69 {$currentBrowsers += "[E] Poi, "} # Poi;
					82 {$currentBrowsers += "[R] Electronic Observer, "} # ElectronicObserver;
					84 {$currentBrowsers += "[T] Chromium/Google Chrome, "} # Chromium and Google Chrome;
					89 {$currentBrowsers += "[Y] Microsoft Edge, "} # Microsoft Edge;
					85 {$currentBrowsers += "[U] Opera/GX, "} # Opera and Opera GX;
					73 {$currentBrowsers += "[I] Brave, "} # Brave;
					79 {$currentBrowsers += "[O] Vivaldi, "} # Vivaldi;
					80 {$currentBrowsers += "[P] Yandex, "} # Yandex;
				}
			};
			$currentBrowsers = $currentBrowsers.TrimEnd(", ") + ".";
			Write-Host "Peramban-peramban yang sekarang terpilih:" $currentBrowsers;
			Write-Host "-> Gunakan Kunci di atas untuk menambah/menghapus ke dalam list hapus cache.";
			Write-Host "-> Tekan ENTER untuk menghapus cache peramban yang terpilih.";
		};
		Do {
			$PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
		} Until ($FullList -contains $PressedKey -or $PressedKey -eq 13)
		If ((-not ($TaskkillList -contains $PressedKey)) -and ($FullList -contains $PressedKey)) {
			[System.Collections.ArrayList] $TaskkillList += $PressedKey;
			$Notice1 = "Ditambahkan"
			$Notice2 = "untuk dihapus"
		} ElseIf ($TaskkillList -contains $PressedKey) {
		[System.Collections.ArrayList] $TaskkillList.Remove($PressedKey);
		$Notice1 = "Terhapus"
		$Notice2 = "untuk ditambahkan lagi"
		}
		Write-Host "";
		Switch ($PressedKey) {
			69 {Write-Host "$Notice1 Poi. Tekan [E] $Notice2."}
			82 {Write-Host "$Notice1 ElectronicObserver. Tekan [R] $Notice2."}
			84 {Write-Host "$Notice1 Chrome/Chromium. Tekan [T] $Notice2."}
			89 {Write-Host "$Notice1 Microsoft Edge. Tekan [Y] $Notice2."}
			85 {Write-Host "$Notice1 Opera (Normal and GX). Tekan [U] $Notice2."}
			73 {Write-Host "$Notice1 Brave. Tekan [I] $Notice2."}
			79 {Write-Host "$Notice1 Vivaldi. Tekan [O] $Notice2."}
			80 {Write-Host "$Notice1 Yandex. Tekan [P] $Notice2."}
		}
	} Until ($PressedKey -eq 13);
};

If ($TaskkillList.Count -eq 0) {
	$TaskkillList = $FullList;
} Else {
	$output = "[" + $($TaskkillList -join ",") + "]"
	$output | Out-File .\ID-patch-manager\browserprefs.json;
};

# Forcefully kills selected Chromium browsers after adding them to another list;
$Browsers = @();
$OperaBrowsers = @();
$EOBrowser = '';
$EOFolder = "\_null";
$PoiBrowser = '';
$PoiFolder = "\_null";
ForEach ($k in $TaskkillList) {
	Switch ($k) {
		69 {
			taskkill /F /IM "poi.exe";
			$PoiBrowser = 'poi';
			$PoiFolder = "$($env:APPDATA)\$PoiBrowser"
		} # Poi;
		82 {
			taskkill /F /IM "ElectronicObserver.exe";
			$EOBrowser = 'ElectronicObserver\Webview2\EBWebView';
			$EOFolder = "$($env:LOCALAPPDATA)\$EOBrowser"
		} # ElectronicObserver;
		84 {
			taskkill /F /IM "chrome.exe";
			$Browsers += 'Chromium';
			$Browsers += 'Google\Chrome'
		} # Chromium and Google Chrome;
		89 {
			taskkill /F /IM "msedge.exe";
			$Browsers += 'Microsoft\Edge'
		} # Microsoft Edge;
		85 {
			taskkill /F /IM "opera.exe";
			$OperaBrowsers = @('Opera Software\Opera Stable', 'Opera Software\Opera GX Stable')
		} # Opera and Opera GX;
		73 {
			taskkill /F /IM "brave.exe";
			$Browsers += 'BraveSoftware\Brave-Browser'
		} # Brave;
		79 {
			taskkill /F /IM "vivaldi.exe";
			$Browsers += 'Vivaldi'
		} # Vivaldi;
		80 {
			taskkill /F /IM "browser.exe";
			$Browsers += 'Yandex\YandexBrowser'
		} # Yandex;
	}
};

# Gets currently running KCCacheProxy instance path;
$running = Get-Process | ForEach-Object {$_.Path};
ForEach ($_ in $running) {
	If ($_ -ne $null) {
		If ($_.contains("KCCacheProxy.exe")) {
			$kccpPath = $_
		}
	}
};

# Forcefully kills KCCacheProxy;
taskkill /F /IM "kccacheproxy.exe";

# Attempts to clear browsers cache;
$Items = @('Cache\*');
$CacheDeleted = $false;
ForEach ($Browser in $Browsers) {
	$Folder = "$($env:LOCALAPPDATA)\$Browser\User Data";
	If (Test-Path "$Folder") {
		$Profiles = Get-ChildItem -Path $Folder | Where-Object {
			$_.Name -Like "Profile*" -or $_.Name -eq "Default"
		}
		ForEach ($Profile in $Profiles) {
			$Profile = $Profile.Name;
			$Items | % { 
				If (Test-Path "$Folder\$Profile\$_") {
					Remove-Item "$Folder\$Profile\$_" -Recurse -Force;
					Write-Host "Menemukan cache $Browser di folder $Profile! Berhasil dihapus." -ForegroundColor Green;
					$CacheDeleted = $true
				}
			}
		}
	}
};

ForEach ($OperaBrowser in $OperaBrowsers) {
	$OperaFolder = "$($env:LOCALAPPDATA)\$OperaBrowser";
	If (Test-Path "$OperaFolder") {
		$Items | % { 
			If (Test-Path "$OperaFolder\$_") {
				Remove-Item "$OperaFolder\$_" -Recurse -Force;
				Write-Host "Menemukan cache $OperaBrowser! Berhasil dihapus." -ForegroundColor Green;
				$CacheDeleted = $true
			}
		}
	}
};

If (Test-Path "$EOFolder") {
	$EOProfiles = Get-ChildItem -Path $EOFolder | Where-Object {
		$_.Name -Like "Profile*" -or $_.Name -eq "Default"
	}
	ForEach ($EOProfile in $EOProfiles) {
		$EOProfile = $EOProfile.Name;
		$Items | % { 
			If (Test-Path "$EOFolder\$Profile\$_") {
				Remove-Item "$EOFolder\$Profile\$_" -Recurse -Force;
				Write-Host "Menemukan cache $EOBrowser di folder $Profile! Berhasil dihapus." -ForegroundColor Green;
				$CacheDeleted = $true
			}
		}
	}
};

If (Test-Path "$PoiFolder") {
	$Items | % { 
		If (Test-Path "$PoiFolder\$_") {
			Remove-Item "$PoiFolder\$_" -Recurse -Force;
			Write-Host "Menemukan cache $PoiBrowser! Berhasil dihapus." -ForegroundColor Green;
			$CacheDeleted = $true
		}
	}
};

# Restarts KCCacheProxy;
Write-Host "";
Try {
	& $kccpPath $null *> $null
	Write-Host "Berhasil menjalankan ulang KCCacheProxy!" -ForegroundColor Green
} Catch {
	Write-Host "Tidak dapat menjalankan KCCacheProxy. Tolong buka kembali secara manual." -ForegroundColor Yellow
};

If ($CacheDeleted) {
	Write-Host "Cache Browser/Viewer dihapus!" -ForegroundColor Green
} Else {
	Write-Host "Gagal untuk menempatkan folder cache, atau tidak ada cache yang dihapus." -ForegroundColor Yellow
};

Write-Host "";
Write-Host "Kamu sekarang bisa menekan apapun untuk keluar."
