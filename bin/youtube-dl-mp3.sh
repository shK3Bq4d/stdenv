#!/usr/bin/env bash
# ex: set filetype=sh :
##
##Usage:  __SCRIPT__ REMOTEHOST [REMOTEPORT]
##configures whatever action with whatever config
##    REMOTEHOST: remote host where to ssh
##    REMOTEPORT: JMX port (default: 12345)
##
## Author: Jeff Malone, 12 Sep 2018
##

set -euo pipefail

# function usage() { sed -r -n -e s/__SCRIPT__/$(basename $0)/ -e '/^##/s/^..// p'   $0 ; }

# [[ $# -eq 1 && ( $1 == -h || $1 == --help ) ]] && usage && exit 0

# [[ $# -lt 1 || $# -gt 2 ]] && echo FATAL: incorrect number of args && usage && exit 1

# for i in sed which grep; do ! command -v $i &>/dev/null && echo FATAL: unexisting dependency $i && exit 1; done

# DIR="$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"

# exec > >(tee -a ~/log/$(basename $0 .sh).log)
# exec > >(tee >(logger --id=$$ -t "$(basename $0)" -p user.info ))
# exec 2>&1

# test -z "${HOSTNAMEF:-}" && HOSTNAMEF=$(hostname -f)
#
if [[ $# -eq 0 ]]; then
	CLIP=$(xclip -o)
	if [[ $CLIP == https://www.youtube.com* ]]; then
		ARG=$CLIP
	else
		echo "FATAL: give URL as arg (nothing in clipboard as well)"
		exit 1
	fi
else
	ARG="$@"
fi
pip install --user --upgrade youtube-dl
~/.local/bin/youtube-dl --no-call-home --ignore-errors --no-playlist --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$ARG" || echo "pip install --upgrade --user youtube_dl"

echo EOF
exit 0

