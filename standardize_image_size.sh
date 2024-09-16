
for i in $(ls -1 ???.jpg) ; do convert $i -background white -gravity center -extent 1476x2248 e$i ; done

