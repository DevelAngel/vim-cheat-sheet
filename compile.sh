#!/bin/sh

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [TEX-FILE]
Do stuff with TEX-FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

-h          display this help and exit
EOF
}

tex_file=""
verbose=0

while [[ $1 == -* ]]; do
	case "$1" in
	-h|--help|-\?) show_help; exit 0;;
	-v|--verbose) verbose=1; shift;;
	-f)
		if (($# > 1)); then
			output_file=$2; shift 2
		else 
			echo "-f requires an argument" 1>&2
			exit 1
		fi ;;
	--) shift; break;;
	-*) echo "invalid option: $1" 1>&2; show_help; exit 1;;
	esac
done

# check if var is empty
if [ -z "$@" ]; then
	tex_file="vim-cheat-sheet-by-angelos-drossos.tex"
else
	tex_file="$@"
fi

if [ "$verbose" -ne "0" ]; then
	printf 'latexmk -lualatex "%s"\n' "$tex_file"
fi
latexmk -lualatex $tex_file
