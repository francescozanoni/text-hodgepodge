
# Set console encoding to UTF-8.
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Get-ChildItem "*.txt" | % {

  # Backup original file, if required.
  if (-not(Test-Path -Path "$($_.FullName).backup" -PathType Leaf)) {
    Copy-Item $_.FullName -Destination "$($_.FullName).backup"
  }

  # Create a file copy to work on.
  Remove-Item -Force $_.FullName
  Copy-Item "$($_.FullName).backup" -Destination $_.FullName
  
  # Unwanted empty lines (or containing only a single character) are reduced.
  (Get-Content $_.FullName -Raw) -replace '\r\n \r\n', "`r`n`r`n" | Set-Content $_.FullName

  # Multiple blank spaces and tabs.
  (Get-Content $_.FullName -Raw) -replace ' +', " " | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "`t", " " | Set-Content $_.FullName
  
  # OCR known errors are fixed.
  (Get-Content $_.FullName -Raw) -replace '(\n|\.)\r\n(I|A)I ', "`$1`r`n`$2l " | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "(J|`]|Z)bidem", "Ibidem" | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace 'B\.(S|\$|5){1,2}\.(S|\$|5){1,2}\.(S|\$|5|8){1,2}\.', "B.S.S.S." | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "- (\d+)(B|A)\.", '- $1 $2.' | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "`r`n(\d+)(B|A)\.", "`r`n`$1 `$2." | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace ' Conti(a|o)', ' contr$1' | Set-Content $_.FullName

  # OCR known errors related to author names are fixed.
  (Get-Content $_.FullName -Raw) -replace '(?i:(\b)AINA)', '$1Aina' | Set-Content $_.FullName

  # Page numbers and titles are clearly separated from text.
  (Get-Content $_.FullName -Raw) -replace '(\r\n)+([0-9]+)(\r\n)+', "`r`n`r`n`$2`r`n`r`n" | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace '(\r\n)+([A-Z ''À«»0-9:]+)(\r\n)+', "`r`n`r`n`$2`r`n`r`n" | Set-Content $_.FullName
  
  # Foot note numbers wrapped into square brackets.
  (Get-Content $_.FullName -Raw) -replace "([a-z»]) ?([0-9]{1,3})\.([^0-9])", '$1[$2].$3' | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "([a-z»]) ?([0-9]{1,3}),([^0-9])", '$1[$2],$3' | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace "([a-z»]) ?([0-9]{1,3});([^0-9])", '$1[$2];$3' | Set-Content $_.FullName
  (Get-Content $_.FullName -Raw) -replace '(\d\d\d\d)(\d\d)(\.|,|;)', '$1[$2]$3' | Set-Content $_.FullName
  
  # Numbers of foot notes at the end.
  (Get-Content $_.FullName -Raw) -replace ' -( |\r\n)(\d+) ', ' -$1[$2] ' | Set-Content $_.FullName
  
  # Lines of the same paragraph separated by two new line characters are joined with a single new line character.
  (Get-Content $_.FullName -Raw) -replace '([a-z-])\r\n\r\n([a-z])', "`$1`r`n`$2" | Set-Content $_.FullName
  
  (Get-Content $_.FullName -Raw) -replace '(\r\n){3,}', "`r`n`r`n" | Set-Content $_.FullName

}

# References:
# - https://social.technet.microsoft.com/Forums/ie/en-US/6710c0d6-d62f-4ad1-b2bd-435433966c67/string-replacement-without-regex?forum=winserverpowershell
# - https://stackoverflow.com/questions/49476326/displaying-unicode-in-powershell/49481797#49481797
# - https://social.technet.microsoft.com/Forums/en-US/21c31fce-9f57-44e4-862e-37a494752952/how-to-specify-a-caseinsensitive-search-using-powershells-quotcriteria-expression-syntaxquot?forum=winserverpowershell
# - https://adamtheautomator.com/powershell-check-if-file-exists/#Using_PowerShell_to_Check_If_File_Exists
# - https://social.technet.microsoft.com/Forums/scriptcenter/en-US/4ab1e11d-63d5-45cb-a88e-3a64adb66329/escaping-single-quotes-inside-a-variable?forum=winserverpowershell#:~:text=The%20PowerShell%20escape%20character%20is,%22%20with%20%22''%22.
