BEGIN { text=0; }

$0 ~ /^#/ { next }

text>1 { print }

/^---$/ { text = text + 1; }

