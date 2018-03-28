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

# function usage() { sed -r -n -e s/__SCRIPT__/$(basename $0)/ -e '/^##/s/^..// p'   $0 ; }

[[ $# -eq 1 && ( $1 == -h || $1 == --help ) ]] && usage && exit 0
NAME=$1
[[ $# -eq 1 && -f "$NAME" ]] && MODE=file || MODE=connect
[[ $# -lt 2 ]] && PORT=443 || PORT=$2
if [[ $# -lt 3 ]]; then
   	IP=$NAME
	echo "$NAME -> $(dig -t a +short $NAME | tail -1)"
elif [[ $MODE = connect ]]; then
	IP=$(dig -t a +short $NAME @$3 | tail -1)
	echo "$NAME @$3 -> $IP"
fi

{ if [[ $MODE = file ]]; then
	echo "cat $NAME" >&2
	cat $NAME
  else
	echo "/usr/bin/openssl s_client -connect $IP:$PORT -servername $NAME"  >&2
	echo '' | \
		/usr/bin/openssl s_client -connect $IP:$PORT -servername $NAME 2>/dev/null
  fi
} |
    /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | \
    /usr/bin/openssl x509 -noout -text -extensions SAN -issuer -subject -alias -dates -email -checkhost $NAME 2>&1| \
	grep -EA1 '^[^ ]|Subject Alternative Name' | grep -vE '^--$|^Certificate:$|^Data: *$' | sed -r -e 's/^ +//g'
exit 0

