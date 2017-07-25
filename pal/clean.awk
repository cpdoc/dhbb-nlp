$0 ~ /\<\/?ß\>/ {next; blank=1}
$0 !~ /^$/ {print; blank=0}
$0 ~ /^$/ && blank==1 {next}
$0 ~ /^$/ && blank==0 {print; blank=1}
