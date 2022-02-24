
$files = (Get-ChildItem -Filter "*.jpg")

foreach ($file in $files) {

  magick convert $file -deskew 20% "a$file"

}