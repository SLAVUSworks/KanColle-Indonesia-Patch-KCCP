# Define the directory containing your files
$sourceDirectory = "D:\Temporary Project Folder\KanColle-Indonesia-Patch-KCCP\ID-patch\kcs2\img\sally\alert\PNG"

# Get all files in the directory
$files = Get-ChildItem -Path $sourceDirectory -File

foreach ($file in $files) {
    # Get the file name without the extension
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    # Get the file extension
    $fileExtension = $file.Extension.TrimStart('.')
    
    # Create the folder name based on file name and type
    $folderName = "$fileNameWithoutExtension ($fileExtension)"
    $folderPath = Join-Path -Path $sourceDirectory -ChildPath $folderName
    
    # Create the folder if it doesn't exist
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory
    }
    
    # Move the file into the folder
    $destinationPath = Join-Path -Path $folderPath -ChildPath $file.Name
    Move-Item -Path $file.FullName -Destination $destinationPath
}

Write-Output "Sudah Rapi pak de"
