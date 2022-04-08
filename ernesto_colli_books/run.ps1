# ##############################################################################
#
# Get page URLs of all Ernesto Colli's books available
# at URL https://www.alzati.it/BassaNovarese/LaStoriaDiDonErnestoColli.html
#
# Run:
#   powershell -ExecutionPolicy Bypass -File .\run.ps1
#
# Output:
#   Barbavara di Gravellona Lomellina:                                82 pages
#   Carlo Fusi e Terdobbiate:                                        110 pages
#   MemorieStoricheGarbagnaNovarese:                                 156 pages
#   Gravellona Lomellina nella sua Storia:                           136 pages
#   Il Castello Rocca di Vespolate:                                   12 pages
#   LeMieMemorie:                                                    180 pages
#   ManoscrittiDon ErnestoColli-Parrocchia_B_V_Assunta_Nibbiola:     250 pages
#   NibbiolaNellaStoria:                                             234 pages
#   Olengo di Novara:                                                130 pages
#   Primo decennio dell'Asilo Nibbiola:                               88 pages
#   Tornaco e Vignarello:                                            229 pages
#   Vespolate nella Storia Vol Secondo:                              100 pages
#   Vespolate nella sua storia:                                      148 pages
#   Vespolate-Mergozzo-Nibbiuola:                                    116 pages
#   Villanova di Cassolo:                                             82 pages
#
# @author Francesco Zanoni
# @version 2022-04-08
#
# ##############################################################################

. $PSScriptRoot\functions.ps1

# ##############################################################################

$BaseUrl = "https://www.alzati.it/BassaNovarese"
$BookUrls = @(
"${BaseUrl}/Barbavara%20di%20Gravellona%20Lomellina/Sfogliatore/Barbavara%20di%20Gravellona%20Lomellina.html",
"${BaseUrl}/Carlo%20Fusi%20e%20Terdobbiate/Sfogliatore/Carlo%20Fusi%20e%20Terdobbiate.html",
"${BaseUrl}/Garbagna%20Memorie%20Storiche/Sfogliatore/MemorieStoricheGarbagnaNovarese.html",
"${BaseUrl}/Gravellona%20Lomellina%20nella%20Storia/Gravellona%20Lomellina%20nella%20sua%20Storia.html",
"${BaseUrl}/Il%20Castello%20Rocca%20di%20Vespolate/Sfogliatore/Il%20Castello%20Rocca%20di%20Vespolate.html",
"${BaseUrl}/LeMieMemorie/HTML5/LeMieMemorie.html",
"${BaseUrl}/Manoscritto%20HTML5/ManoscrittiDon%20ErnestoColli-Parrocchia_B_V_Assunta_Nibbiola.html",
"${BaseUrl}/Nibbiola%20nella%20Storia/Sfogliatore/NibbiolaNellaStoria.html",
"${BaseUrl}/Olengo%20di%20Novara/Olengo%20di%20Novara.html",
"${BaseUrl}/Primo%20decennio%20dell%27Asilo/Sfogliatore/Primo%20decennio%20dell%27Asilo%20Nibbiola.html",
"${BaseUrl}/Tornaco%20e%20Vignarello/Tornaco%20e%20Vignarello.html",
"${BaseUrl}/Vespolate%20nella%20sua%20Storia%20Vol%20Secondo/Vespolate%20nella%20Storia%20Vol%20Secondo.html",
"${BaseUrl}/Vespolate%20nella%20sua%20Storia/Vespolate%20nella%20sua%20storia.html",
"${BaseUrl}/VespolateMergozzoNibbiola/HTML5/Vespolate-Mergozzo-Nibbiuola.html",
"${BaseUrl}/Villanova%20di%20Cassolo/Sfogliatore/Villanova%20di%20Cassolo.html"
)

foreach ($BookUrl in $BookUrls)
{
    $Title = (Get-Title $BookUrl)
    $PaddedTitle = "${Title}:".PadRight(64, " ")
    $TotalPageNumber = (Get-TotalPageCount $BookUrl)
    $PaddedTotalPageNumber = $TotalPageNumber.PadLeft(3, " ")

    Write-Output "${PaddedTitle} ${PaddedTotalPageNumber} pages"
    $PageUrls = (Get-PageUrls $BookUrl $TotalPageNumber)

    # $PageUrls
}

# ##############################################################################
#
# References:
#  - https://devblogs.microsoft.com/scripting/powertip-pad-string-to-left-with-powershell/
#  - https://docs.microsoft.com/it-it/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-7.2
#  - https://docs.microsoft.com/it-it/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.2
#  - https://stackoverflow.com/questions/5466329/whats-the-best-way-to-determine-the-location-of-the-current-powershell-script
#
