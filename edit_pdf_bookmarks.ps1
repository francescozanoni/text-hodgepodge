
# @see https://opensource.com/article/22/1/pdf-metadata-pdftk

# STEP 1: extract metadata
pdftk my_file_with_old_bookmarks.pdf data_dump output metadata.txt

# STEP 2: edit metadata.txt
#  1. remove everything under NumberOfPages
#  2. add bookmarks with this structure:
#       BookmarkBegin
#       BookmarkTitle: My first bookmark
#       BookmarkLevel: 1
#       BookmarkPageNumber: 2

# STEP 3: apply new metadata
pdftk my_file_with_old_bookmarks.pdf update_info metadata.txt output my_file_with_new_bookmarks.pdf
