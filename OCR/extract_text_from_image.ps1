# Basic Tesseract usage:
#  - tesseract .\3.jpg 3_text_from_tesseract -l ITA

# Text extraction.
tesseract file.jpg output_base_name -l ITA

# Text post-processing.
if ((Get-Content output_base_name.txt).Length -gt 0)
{
    ((Get-Content output_base_name.txt -Raw) -replace 'ﬁ', 'fi' `
                                -replace ' »', '»' `
                                -replace '« ', '«').Trim() | Set-Content output_base_name.txt
    ((Get-Content output_base_name.txt) -join "`n") | Set-Content -NoNewLine output_base_name.txt
}



# PowerShell references:
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_for?view=powershell-7.2
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.2
#  - https://mcpmag.com/articles/2018/08/08/replace-text-with-powershell.aspx
#  - https://stackoverflow.com/questions/68326094/removing-unicode-character-using-powershell
#  - https://stackoverflow.com/questions/19127741/replace-crlf-using-powershell
#  - https://www.tutorialspoint.com/how-to-check-if-the-file-is-empty-using-powershell
#  - https://stackoverflow.com/questions/51388862/if-statement-on-path-variable-powershell-true-false-test