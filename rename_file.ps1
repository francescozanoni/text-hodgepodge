
$i = 3

$files = (Get-ChildItem -Filter "image*.jpg")

foreach ($file in $files) {

  Rename-Item -Path $file -NewName "$i.jpg"

  $i += 2

}


# https://devblogs.microsoft.com/scripting/use-powershell-to-rename-files-in-bulk/
# https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-7.2
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-item?view=powershell-7.2