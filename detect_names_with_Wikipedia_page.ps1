# This script detects whether each name/surname item of a list has a dedicate Wikipedia page,
# by invoking Wikipedia's autocomplete endpoint used by search box.

# -----------------------------------------------------------------------------------------------------------

# INPUT

# This array is populated by manually extracting names and surnames from these URLs,
# with some standardization logic (capitalization, name/surname order):
#  - http://www.ssno.it/SSN/ssn_soci1920.html
#  - http://www.ssno.it/SSN/ssn_soci1927.html
#  - http://www.ssno.it/SSN/ssn_soci1935.html
#  - http://www.ssno.it/SSN/ssn_soci1943.html
#  - http://www.ssno.it/SSN/ssn_soci1958.html
$data = @(
'Ernesto Colli'
'Uberto Pestalozza'
'Alessandro Viglio'
# ...
)

# -----------------------------------------------------------------------------------------------------------

# RESPONSE STRUCTURE EXAMPLES

# Found:          [
#                   "Alessandro Viglio",
#                   [
#                     "Alessandro Viglio",
#                     "Alessandro Vaglio",
#                     "Alessandro figlio di Numenio",
#                     "Alessandro Giglio Vigna",
#                     "Alessandro (figlio di Lisimaco)"
#                   ],
#                   ["","","","","","","","",""],
#                   [
#                     "https://it.wikipedia.org/wiki/Alessandro_Viglio",
#                     "https://it.wikipedia.org/wiki/Alessandro_Vaglio",
#                     "https://it.wikipedia.org/wiki/Alessandro_figlio_di_Numenio",
#                     "https://it.wikipedia.org/wiki/Alessandro_Giglio_Vigna",
#                     "https://it.wikipedia.org/wiki/Alessandro_(figlio_di_Lisimaco)"
#                   ]
#                 ]

# Not found:      [
#                   "Uberto Pestalozza",
#                   [],
#                   [],
#                   []
#                 ]

# Found           [
# with              "Ernesto Colli",
# disambiguation:   [
#                     "Ernesto Colli",
#                     "Ernesto Colli (sacerdote)",
#                     "Ernesto Colli (disambigua)",
#                     "Ernesto Celli"
#                   ],
#                   ["","","",""],
#                   [
#                     "https://it.wikipedia.org/wiki/Ernesto_Colli",
#                     "https://it.wikipedia.org/wiki/Ernesto_Colli_(sacerdote)",
#                     "https://it.wikipedia.org/wiki/Ernesto_Colli_(disambigua)",
#                     "https://it.wikipedia.org/wiki/Ernesto_Celli"
#                   ]
#                 ]

# -----------------------------------------------------------------------------------------------------------

for ($index = 0; $index -lt $data.count; $index++)
# for ( $index = 0; $index -lt 2; $index++)
{
    $nameToSearch = $data[$index]
    $encodedNameToSearch = $nameToSearch.replace(' ', '%20')

    # URL cannot be provided to Invoke-WebRequest as a concatenation of strings,
    # otherwise this error is triggered:
    #   Invoke-WebRequest : A positional parameter cannot be found that accepts argument '+'
    $url = "https://it.wikipedia.org/w/api.php?action=opensearch" +  `
                                              "&format=json" +  `
                                              "&formatversion=2" +  `
                                              "&search=$encodedNameToSearch" +  `
                                              "&namespace=0" +  `
                                              "&limit=10"
    $response = (Invoke-WebRequest -Uri $url).Content
    $responseAsArray = ($response | ConvertFrom-Json)
    $foundPages = $responseAsArray[1]
    # $foundPages.Length
    $nameToSearch + ": " + $foundPages.Contains($data[$index])
}

# -----------------------------------------------------------------------------------------------------------

# OUTPUT

# Ernesto Colli: True
# Uberto Pestalozza: False
# Alessandro Viglio: True

# -----------------------------------------------------------------------------------------------------------

# REFERENCES

# - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.2
# - https://devblogs.microsoft.com/scripting/powertip-does-powershell-array-contain-a-value/
# - capitalization with Notepad++: replace \b(\w) with \u$0
#   https://stackoverflow.com/questions/31952353/notepad-capitalize-every-first-letter-of-every-word
