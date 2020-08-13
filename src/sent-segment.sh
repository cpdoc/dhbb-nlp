#!/usr/bin/env bash


usage()
{
    echo "usage: sent-segment.sh [-i directory -o directory -m model [-f filename] [-v] | -h]"
}

source="${BASH_SOURCE[0]}"
model=
indir=
outdir=
file=
verbose=t

while [ "$1" != "" ]; do
    case $1 in
        -i | --indir )          shift
                                indir=$1
                                ;;
        -o | --outdir )         shift
                                outdir=$1
                                ;;
        -m | --model )          shift
                                model=$1
                                ;;
        -f | --file )           shift
                                file=$1
                                ;;
        -v | --verbose )        verbose=t
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
				;;
    esac
    shift
done

if [ -z "$model" ] || [ -z "$indir" ] || [ -z "$outdir" ]; then
   usage
   exit 1
fi

if [ -z "$file" ]; then
    abcl --batch --load sent-segment.lisp --eval "(main \"$indir\" \"$outdir\" \"$model\")" --eval '(quit)'
else
    abcl --batch --load sent-segment.lisp --eval "(main \"$indir\" \"$outdir\" \"$model\" :single-file \"$file\")" --eval '(quit)'
fi
