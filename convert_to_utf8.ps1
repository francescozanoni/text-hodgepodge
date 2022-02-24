
Get-ChildItem "*.txt" | % {
  
    # Convert file encoding to UTF-8 without BOM: ONLY ONCE
    $fileContent = Get-Content -Raw $_.FullName
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($_.FullName, $fileContent, $Utf8NoBomEncoding)
     
}
