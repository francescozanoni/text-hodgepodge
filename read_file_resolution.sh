for i in $(ls -1 *.jpg)
do
  file $i | sed -E 's/^([^:]+:).+density ([0-9]+)x([0-9]+).+$/\1 \2 \3/'
done
