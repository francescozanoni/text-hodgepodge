
# PROCEDURE 1: ImageMagick + OCRmyPDF

# Merge images to a single PDF file.
# @see https://askubuntu.com/questions/493584/convert-images-to-pdf
cd path/to/image/folder
convert "*.{jpg}" -quality 100 outfile.pdf

# Above command could be prevented by below error:
# convert-im6.q16: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/421.
# If so, file /etc/ImageMagick-6/policy.xml needs to be patched,
# as suggested by https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion#59193253

# Another possible problem:
# convert-im6.q16: cache resources exhausted `00000511.jpg' @ error/cache.c/OpenPixelCache/4095.
# To be fixed again by patching file /etc/ImageMagick-6/policy.xml
# https://stackoverflow.com/questions/31407010/cache-resources-exhausted-imagemagick#53699200

# OCR the PDF just created.
# @see https://ocrmypdf.readthedocs.io/en/latest/cookbook.html#basic-examples
ocrmypdf -l ita outfile.pdf outfile_ocr.pdf

# ######################################################################################################################


# PROCEDURE 2: Tesseract

# @see https://ocrmypdf.readthedocs.io/en/latest/cookbook.html#ocr-images-not-pdfs
cd path/to/image/folder
tesseract <( ls -1 ) output-prefix pdf -l ita
