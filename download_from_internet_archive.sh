# Download of file borrowed on Internet Archive.


# Tokens to change within URL:
#  - 'unse_0001.jp2' --> 'unse_0'$i'.jp2'
#  - 'scale=8'       --> 'scale=1'

for i in $(seq -f "%03g" 1 756)
do

  if [ -f $i.jp2 ]; then
    continue
  fi
    
  curl 'https://ia802804.us.archive.org/BookReader/BookReaderImages.php?zip=/2/items/dizionarioditopo00unse/dizionarioditopo00unse_jp2.zip&file=dizionarioditopo00unse_jp2/dizionarioditopo00unse_0'$i'.jp2&id=dizionarioditopo00unse&scale=1&rotate=0' \
    -H 'accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8' \
    -H 'accept-language: en,en-US;q=0.9,it;q=0.8' \
    -H 'cookie: donation-identifier=d53c152889c274aeebb766e4061692d4; abtest-identifier=f6bc988808c74d4f85b1dc22bfe7e2e6; view-search=tiles; showdetails-search=; logged-in-sig=1746609936%201715073936%20nhsVu1wrHFF8R4%2B4qmClq%2FM4upQiLgGYHe%2FGlwBH6vBBnYUPA1x3ywCj%2BfxZ4reMHdQEKHZGOYwpsJLK4%2FjaHML%2BWkMCq4pVVF%2FauS96RznDCK3vLIXB%2F3itwMyLlTs%2F3P%2BgwNOKjlaSM%2B0mA1%2BU9B9utHfKiq711z8r5ncUzsw%3D; logged-in-user=francescozanoni81%40gmail.com; br-loan-dizionarioditopo00unse=1; ol-auth-url=%2F%2Farchive.org%2Fservices%2Fborrow%2FXXX%3Fmode%3Dauth; loan-dizionarioditopo00unse=1724163708-1376c63f8086e5e5ed523e07a1fbaf47' \
    -H 'dnt: 1' \
    -H 'priority: i' \
    -H 'referer: https://archive.org/details/dizionarioditopo00unse' \
    -H 'sec-ch-ua: "Not)A;Brand";v="99", "Google Chrome";v="127", "Chromium";v="127"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    -H 'sec-fetch-dest: image' \
    -H 'sec-fetch-mode: no-cors' \
    -H 'sec-fetch-site: same-site' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36' \
    -s \
    -o $i.jp2
  
  # Read file size.
  # https://unix.stackexchange.com/questions/16640/how-can-i-get-the-size-of-a-file-in-a-bash-script
  FILE_SIZE=$(stat --printf="%s" $i.jp2)

  # If cookie has expired, downloaded file is around 4,8kb.
  # When this happens, file is deleted and script aborted.
  # https://stackoverflow.com/questions/18668556/how-can-i-compare-numbers-in-bash
  if [ "$FILE_SIZE" -lt "10000" ]; then
    rm -f $i.jp2
    exit
  fi
  
  echo $i.jp2

done

# Ogni N minuti la sessione scade, facendo scaricare file tutti uguali da 4,8 KB.
# Per riabilitare la sessione, e quindi il download, basta sfogliare alcune pagine nuove del file su Internet Archive,
# ad esempio richiedendo una pagina non ancora visualizzata dal documento,
# e poi ricopiare l'header "cookie" del curl della nuova richiesta
