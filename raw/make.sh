
for f in $(ls ../text/*.text); do
    BASE=$(basename $f .text)
    awk 'BEGIN { text=0; } text>1 {print} /^---$/ { text = text + 1; }' $f > $BASE.raw ;
done
