for f in ../raw/*.raw; do
	out=$(echo "$f" | tr -d "/.raw")
	path="../sents/$out-nl.sent"
	python3 segmentation.py < $f > $path
done
