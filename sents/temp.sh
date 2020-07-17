#!/bin/bash

for f in *.sent; do
	number=$(echo "$f" |tr -d "-" | tr -d "opfl.sent")
	temp=$(echo "$number.sent")	
	if [ "$f" = "$temp" ]; then	
		cp "$number.sent" "$number-op.sent"
		cp "$number.sent" "$number-fl.sent"
		rm "$number.sent"	
	fi
done
