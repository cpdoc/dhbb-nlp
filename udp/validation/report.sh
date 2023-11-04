make
cat *.report | egrep -o '\[L[0-9]+ [A-Za-z]+ [a-z\-]+\]' | sort | uniq -c | sort -nr > report.log

