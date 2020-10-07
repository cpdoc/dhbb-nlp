
for f in `find -E . -type f -regex '.*[0-9]+-..\.sent' | sed -e 's/-..\.sent//' | sed -e 's/\.\///' | sort -n | uniq`; do
    FL=`find . -name "$f-*.sent"`
    echo consolidating $FL
    ../src/sent-analysis $FL && rm $FL
done
