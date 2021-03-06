#!/usr/bin/env bash

set -e
DIR="$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"
cd "$DIR"
cat subrepo-list.txt | while read dir url; do
	cd "$DIR"
	[[ -d "$dir" ]] && continue
	git clone $url "$dir"
	cd $dir && git submodule update --init --recursive
done
cd "$DIR"
if [[ -d youcompleteme ]]; then
	cd youcompleteme
	./install.py
fi
