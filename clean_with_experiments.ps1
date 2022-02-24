function Get-Encoding
{
  param
  (
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]
    $Path
  )

  process 
  {
    $bom = New-Object -TypeName System.Byte[](4)
        
    $file = New-Object System.IO.FileStream($Path, 'Open', 'Read')
    
    $null = $file.Read($bom, 0, 4)
    $file.Close()
    $file.Dispose()
    
    $enc = [Text.Encoding]::ASCII
    if ($bom[0] -eq 0x2b -and $bom[1] -eq 0x2f -and $bom[2] -eq 0x76) 
      { $enc =  [Text.Encoding]::UTF7 }
    if ($bom[0] -eq 0xff -and $bom[1] -eq 0xfe) 
      { $enc =  [Text.Encoding]::Unicode }
    if ($bom[0] -eq 0xfe -and $bom[1] -eq 0xff) 
      { $enc =  [Text.Encoding]::BigEndianUnicode }
    if ($bom[0] -eq 0x00 -and $bom[1] -eq 0x00 -and $bom[2] -eq 0xfe -and $bom[3] -eq 0xff) 
      { $enc =  [Text.Encoding]::UTF32 }
    if ($bom[0] -eq 0xef -and $bom[1] -eq 0xbb -and $bom[2] -eq 0xbf) 
      { $enc =  [Text.Encoding]::UTF8 }
        
    $enc
  }
}
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/get-text-file-encoding

function Test-PSCustomObjectEquality {
  param(
    [Parameter(Mandatory = $true)]
    [PSCustomObject] $firstObject,

    [Parameter(Mandatory = $true)]
    [PSCustomObject] $secondObject
  )
  -not (Compare-Object $firstObject.PSObject.Properties $secondObject.PSObject.Properties)
}
# https://stackoverflow.com/questions/47576496/powershell-how-to-tell-if-two-objects-are-identical

Function ContainsBOM
{   
    return $input | where {
        $contents = new-object byte[] 3
        $stream = [System.IO.File]::OpenRead($_.FullName)
        $stream.Read($contents, 0, 3) | Out-Null
        $stream.Close()
        $contents[0] -eq 0xEF -and $contents[1] -eq 0xBB -and $contents[2] -eq 0xBF }
}
# https://superuser.com/questions/418515/how-to-find-all-files-in-directory-that-contain-utf-8-bom-byte-order-mark/914116

Get-ChildItem "*.txt" | % {

    echo "-------------------------------------------------"

    $_.FullName
    if ( (Get-Encoding $_.FullName).EncodingName -eq "US-ASCII" -and (ContainsBOM $_.FullName) ) {
      echo "UTF-8"
    } else {
      echo "Not UTF-8"
    }
    # (ContainsBOM $_.FullName) ? "yes" : "no"

    echo "-------------------------------------------------"

    # ORIGINALE
    #
    # testo_tesseract.txt:
    #  - Notepad++:  ANSI
    #  - PowerShell: IsSingleByte      : True
    #                BodyName          : us-ascii
    #                EncodingName      : US-ASCII
    #                HeaderName        : us-ascii
    #                WebName           : us-ascii
    #                WindowsCodePage   : 1252
    #                IsBrowserDisplay  : False
    #                IsBrowserSave     : False
    #                IsMailNewsDisplay : True
    #                IsMailNewsSave    : True
    #                EncoderFallback   : System.Text.EncoderReplacementFallback
    #                DecoderFallback   : System.Text.DecoderReplacementFallback
    #                IsReadOnly        : True
    #                CodePage          : 20127
    #
    # test_czur.txt:
    #  - Notepad++:  UTF-8-BOM
    #  - PowerShell: BodyName          : utf-8
    #                EncodingName      : Unicode (UTF-8)
    #                HeaderName        : utf-8
    #                WebName           : utf-8
    #                WindowsCodePage   : 1200
    #                IsBrowserDisplay  : True
    #                IsBrowserSave     : True
    #                IsMailNewsDisplay : True
    #                IsMailNewsSave    : True
    #                IsSingleByte      : False
    #                EncoderFallback   : System.Text.EncoderReplacementFallback
    #                DecoderFallback   : System.Text.DecoderReplacementFallback
    #                IsReadOnly        : True
    #                CodePage          : 65001
    
    # DOPO CONVERSIONE
    #
    # testo_tesseract.txt:
    #  - Notepad++:  UTF-8
    #  - PowerShell: IsSingleByte      : True
    #                BodyName          : us-ascii
    #                EncodingName      : US-ASCII
    #                HeaderName        : us-ascii
    #                WebName           : us-ascii
    #                WindowsCodePage   : 1252
    #                IsBrowserDisplay  : False
    #                IsBrowserSave     : False
    #                IsMailNewsDisplay : True
    #                IsMailNewsSave    : True
    #                EncoderFallback   : System.Text.EncoderReplacementFallback
    #                DecoderFallback   : System.Text.DecoderReplacementFallback
    #                IsReadOnly        : True
    #                CodePage          : 20127
    #
    # test_czur.txt:
    #  - Notepad++:  UTF-8
    #  - PowerShell: IsSingleByte      : True
    #                BodyName          : us-ascii
    #                EncodingName      : US-ASCII
    #                HeaderName        : us-ascii
    #                WebName           : us-ascii
    #                WindowsCodePage   : 1252
    #                IsBrowserDisplay  : False
    #                IsBrowserSave     : False
    #                IsMailNewsDisplay : True
    #                IsMailNewsSave    : True
    #                EncoderFallback   : System.Text.EncoderReplacementFallback
    #                DecoderFallback   : System.Text.DecoderReplacementFallback
    #                IsReadOnly        : True
    #                CodePage          : 20127
    
    # Convert file encoding to UTF-8 without BOM: ONLY ONCE
    # $fileContent = Get-Content -Raw $_.FullName
    # $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    # [System.IO.File]::WriteAllLines($_.FullName, $fileContent, $Utf8NoBomEncoding)
    
    # ((Get-Content $_.FullName -Raw) -replace '’', "'" `
    #                                 -replace "(`r`n)+ (`r`n)+", "`r`n" `
    #                                 -replace "`r`n(\d+)`r`n", "`r`n`r`n$1`r`n`r`n" `
    #                                 -replace "`r`n(`r`n)+", "`r`n`r`n" `
    #                                 -replace '', '').Trim() | Set-Content $_.FullName
    # 
}

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7.2
# https://docs.microsoft.com/en-us/answers/questions/405610/powershell-change-save-encoding-how-to-convert-sev.html
# https://stackoverflow.com/questions/5596982/using-powershell-to-write-a-file-in-utf-8-without-the-bom
# https://stackoverflow.com/questions/13126175/get-full-path-of-the-files-in-powershell
