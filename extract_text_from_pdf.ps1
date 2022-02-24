# Basic pdftotext usage:
#  - pdftotext .\file.pdf -f 1 -l 1 -raw .\output.txt



pdftotext file.pdf -f $( $i - 2 ) -l $( $i - 2 ) -raw output.txt
if ((Get-Content output.txt).Length -gt 0)
{
    ((Get-Content output.txt -Raw) -replace 'ﬁ', 'fi' `
                                -replace ' dell ', " dell'").Trim() | Set-Content output.txt
    ((Get-Content output.txt) -join "`n") | Set-Content -NoNewLine output.txt
}



# PowerShell references:
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_for?view=powershell-7.2
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.2
#  - https://mcpmag.com/articles/2018/08/08/replace-text-with-powershell.aspx
#  - https://stackoverflow.com/questions/68326094/removing-unicode-character-using-powershell
#  - https://stackoverflow.com/questions/19127741/replace-crlf-using-powershell
#  - https://www.tutorialspoint.com/how-to-check-if-the-file-is-empty-using-powershell
#  - https://stackoverflow.com/questions/51388862/if-statement-on-path-variable-powershell-true-false-test