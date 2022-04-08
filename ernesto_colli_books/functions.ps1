# ##############################################################################
#
# @author Francesco Zanoni
# @version 2022-04-08
#
# ##############################################################################

Add-Type -AssemblyName System.Web

# Get the total number of pages of a book, given the book URL.
function Get-TotalPageCount
{
    param
    (
        [string]$Url
    )

    # .Replace() cannot be used because it does not handle regular expressions.
    $ConfigJsUrl = ($Url -replace "/[^/]+$", "/mobile/javascript/config.js")

    $ConfigJsContent = (Invoke-WebRequest -URI $ConfigJsUrl).Content

    $IsStringFound = ($ConfigJsContent -CMatch "bookConfig\.totalPageCount=(\d+)")

    if ($IsStringFound -eq $true)
    {
        $Matches[1]
    }
    else
    {
        0
    }
}

# Get the title of a book, given the book URL.
function Get-Title
{
    param
    (
        [string]$Url
    )

    # .Replace() cannot be used because it does not handle regular expressions.
    $LastUrlToken = ($Url -replace "^.+/([^.]+)\.html$", '$1')

    $Title = [System.Web.HTTPUtility]::UrlDecode($LastUrlToken)

    $Title
}

# Get page URLs of a book, given the book URL and the total number of pages.
function Get-PageUrls
{
    param
    (
        [string]$Url,
        [int]$TotalPageNumber
    )

    # .Replace() cannot be used because it does not handle regular expressions.
    $BasePageUrl = ($Url -replace "/[^/]+$", "/files/mobile")

    $PageUrls = @()

    for ($i = 1; $i -le $TotalPageNumber; $i++)
    {
        $PageUrls += "${BasePageUrl}/${i}.jpg"
    }

    $PageUrls
}

# ##############################################################################
#
# References:
#  - https://4sysops.com/archives/strings-in-powershell-replace-compare-concatenate-split-substring/
#  - https://4sysops.com/archives/the-regular-expression-regex-in-powershell/
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_for?view=powershell-7.2
#  - https://docs.microsoft.com/it-it/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.2
#  - https://docs.microsoft.com/it-it/powershell/scripting/learn/ps101/09-functions?view=powershell-7.2
#  - https://mcpmag.com/articles/2019/04/10/managing-arrays-in-powershell.aspx
#  - https://ridicurious.com/2017/05/26/url-encode-decode/
#  - https://stackoverflow.com/questions/11794412/powershell-regex-group-replacing
#  - https://stackoverflow.com/questions/38408729/unable-to-find-type-system-web-httputility-in-powershell
#
