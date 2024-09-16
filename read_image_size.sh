
for i in $(ls -1 *.jpg) ; do echo -n "$i: " ; identify -format '%w %h' $i ; echo ; done

# https://unix.stackexchange.com/questions/75635/shell-command-to-get-pixel-size-of-an-image
