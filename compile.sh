#!/bin/sh

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [TEX-FILE]
Do stuff with TEX-FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

-h          display this help and exit
-p          use pdflatex (default)
-l          use lualatex
EOF
}

tex_file=""
pdflatex=0
lualatex=0
verbose=0

while [[ $1 == -* ]]; do
	case "$1" in
	-h|--help|-\?) show_help; exit 0;;
	-v|--verbose) verbose=1; shift;;
#	-f)
#		if (($# > 1)); then
#			output_file=$2; shift 2
#		else 
#			echo "-f requires an argument" 1>&2
#			exit 1
#		fi ;;
	-l|--lualatex) lualatex=1; shift;;
	-p|--pdflatex) pdflatex=1; shift;;
	--) shift; break;;
	-*) echo "invalid option: $1" 1>&2; show_help; exit 1;;
	esac
done

# set tex document file
if [ -z "$@" ]; then
	tex_file="vim-cheat-sheet-by-angelos-drossos.tex"
else
	tex_file="$@"
fi
# execute tex engine (using latexmk)
if [ "$pdflatex" -ne "0" ]; then
	# use pdflatex
	if [ "$verbose" -ne "0" ]; then
		printf 'latexmk -pdf "%s"\n' "$tex_file"
	fi
	latexmk -pdf $tex_file
elif [ "$lualatex" -ne "0" ]; then
	# use lualatex
	if [ "$verbose" -ne "0" ]; then
		printf 'latexmk -lualatex "%s"\n' "$tex_file"
	fi
	latexmk -lualatex $tex_file
else
	# default: use pdflatex
	if [ "$verbose" -ne "0" ]; then
		printf 'latexmk -pdf "%s"\n' "$tex_file"
	fi
	latexmk -pdf $tex_file
fi
