
for f in `find -E . -type f -regex '.*[0-9]+-..\.offset' | sed -e 's/-..\.offset//' | sed -e 's/\.\///' | sort -n | uniq`; do
    FL=`find . -name "$f-*.offset"`
    echo consolidating $FL
    ../src/sent-analysis $FL && rm $FL
done
