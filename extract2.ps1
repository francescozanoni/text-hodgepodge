
$folders = (Get-ChildItem -Filter "*")

foreach ($folder in $folders) {

  cd $folder
  New-Item -Path . -Name "testo_tesseract.txt" -ItemType "file"
  $files = (Get-ChildItem -Filter "*.jpg")
  foreach ($file in $files) {
    Add-Content -Path testo_tesseract.txt -Value (tesseract $file stdout -l ITA)
  }
  cd ..\..

}

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7.2