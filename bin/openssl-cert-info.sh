#!/usr/bin/env bash
# ex: set filetype=sh :
##
##Usage:  __SCRIPT__ HOST_OR_FILE [PORT [DNSSERVER]]
##configures whatever action with whatever config
##    REMOTEHOST: remote host where to ssh
##    REMOTEPORT: JMX port (default: 12345)
##
## Author: Jeff Malone, 27 Mar 2018
##

set -euo pipefail



RED=$(echo -e "\033[0;31m")    # red
GREEN=$(echo -e "\033[0;32m")    # green
OFF=$(echo -e "\033[m")
OPENSSL_OPTIONS=""
PORT=443

_tempdir=$(mktemp -d); function cleanup() { [[ -n "${_tempfile:-}" && -d "$_tempdir" ]] && rm -rf $_tempdir; }; trap 'cleanup' SIGHUP SIGINT SIGQUIT SIGTERM
_tempfile=$_tempdir/a

# function usage() { sed -r -n -e s/__SCRIPT__/$(basename $0)/ -e '/^##/s/^..// p'   $0 ; }

if [[ $# -gt 1 ]] && [[ -f "$@" ]]; then
    F="$@"
    $0 "$F"
    exit $?
fi
[[ $# -eq 1 && ( "$1" == -h || "$1" == --help ) ]] && usage && exit 0
if [[ $# -eq 0 ]] || [[ $# -eq 1 && "$1" == "-" ]]; then
    MODE=file
    NAME=$_tempdir/b
    cat - > $NAME
else
    NAME="$1"
    [[ $# -eq 1 && -f "$NAME" ]] && MODE=file || MODE=connect
    NAME="$( echo -n $NAME | sed -r \
        -e 's/^#//' \
        -e 's/(^\s+|\s+$)//g' \
        -e 's/^.*(https?:..)([^/ ]+?).*$/\2/'
        )"
    if [[ "$NAME" = *:* ]]; then
        PORT="$( echo -n "$PORT" | sed -r \
            -e 's/.*://' \
            )"
        NAME="$( echo -n "$NAME" | sed -r \
            -e 's/:.*//' \
            )"
    fi
fi
[[ $# -lt 2 ]] && PORT=$PORT || PORT=$2
if [[ $# -lt 3 ]]; then
       IP="$NAME"
    echo "$NAME -> $(dig -t a +short "$NAME" | tail -1)"
elif [[ $MODE = connect ]]; then
    IP=$(dig -t a +short "$NAME" @$3 | tail -1)
    echo "$NAME @$3 -> $IP"
fi

if uname | grep -qx FreeBSD; then
    OPENSSL_OPTIONS=
else
    OPENSSL_OPTIONS="-checkhost $NAME"
fi
{   if [[ $MODE = file ]]; then
        echo "cat $NAME" >&2
        cat "$NAME"
    else
        echo "echo | /usr/bin/openssl s_client -connect $IP:$PORT -servername '$NAME' 2>&1 | less"  >&2
        echo "echo | /usr/bin/openssl s_client -connect $IP:$PORT -servername '$NAME' -starttls smtp 2>&1 | less # for STARTTLS SMTP"  >&2
        echo | \
            /usr/bin/openssl s_client -connect $IP:$PORT -servername "$NAME" 2>&1
    fi
} | tee $_tempfile |
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
    openssl x509 -noout -text -extensions SAN -issuer -subject -alias -dates -email $OPENSSL_OPTIONS 2>&1| \
    grep -EA1 '^[^ ]|Subject Alternative Name' | grep -vE '^--$|^Certificate:$|^Data: *$' | sed -r -e 's/^ +//g' | \
    sed -r \
        -e "/^Hostname \\S+ does match certificate$/s/(.*)/${GREEN}\\0${OFF}/" \
        -e "/^Hostname \\S+ does NOT match certificate$/s/(.*)/${RED}\\0${OFF}/" \
        -e "/certificate has expired/s/(.*)/${RED}\\0${OFF}/"

    { grep -i verify $_tempfile || true; } | \
    sed -r \
        -e "/certificate has expired/s/(.*)/${RED}\\0${OFF}/"

cleanup
exit 0

