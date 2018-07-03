#!/usr/bin/env bash


[[ -z "$1" ]] && echo "Inception A" && exit 1
SCRIPT="$1"
LOG="$2"
exec > >(tee "$LOG")
exec 2>&1

# puppet module to capsule
if [[ "$SCRIPT" = */puppet-envs/modules/* ]]; then
    last_host_fp=~/.tmp/vimf6-last_host
    last_capsule_fp=~/.tmp/vimf6-last_capsule
    all_capsule_fp=~/.tmp/vimf6-all_capsule

    k=0
    if [[ -f $last_capsule_fp ]]; then
        last_capsule=$(<$last_capsule_fp)
        # all_proposals="$(grep -vw $last_capsule $all_capsule_fp)"
    else
        last_capsule=""
    fi
    # all_proposals="$(<$all_capsule_fp)"

    readarray pA < $all_capsule_fp

    # echo "$all_proposals"
    # exit 0
    choice=-1
    #echo "$all_proposals" |
    #while read line; do
    for k in "${!pA[@]}" # iterate over an array
    do
        printf "%2i %s\n" $k ${pA[$k]}
    done
    while :; do
        echo -en "\nChoose your capsule [$last_capsule]: "
        read response
        if [[ -z $response ]]; then
            if [[ -n $last_capsule ]]; then
                capsule=$last_capsule
                break
            fi
            continue
        fi
        capsule=${pA[$response]}
        [[ -n "$capsule" ]] && break
    done

    echo -e "\ncapsule is $capsule\n"
    # optional PATH assignment to override version in ~/bin, to test work copy
    # export PATH=~/git/ksgitlab/cfc/ide-infra/scripts:$PATH
    puppet-file-to-capsule.sh $capsule $SCRIPT && echo -n $capsule > $last_capsule_fp
    if [[ -f $last_host_fp ]]; then
        last_host=$(<$last_host_fp)
    else
        last_host=""
    fi
    echo -en "\nWould you like to execute a puppet agent run [${last_host^^},y,n]: "
    read response
    case $response in \
    n|N) exit 0 ;;
    y|Y|"")
        target=$last_host
        ssh $target true || { echo "FATAL: not a (a) host $target"; exit 1; }
        ;;
    *)
        target=$response
        ssh $target true && echo $target > $last_host_fp || { echo "FATAL: not a (b) host $target"; exit 1; }
        ;;
    esac
    echo # ex: set paste! wrap! number!=:
    echo "ssh $target sudo /opt/puppetlabs/puppet/bin/puppet agent -t"
    ssh $target sudo /opt/puppetlabs/puppet/bin/puppet agent -t
    echo ":AnsiEsc/F3 is your friend to colorize input"

    exit 0
fi


# executables
if [[ -x "$SCRIPT" ]]; then
    $SCRIPT
    echo "vimf6.sh -x exit code is $?"
    exit 0
fi

# shebang
FIRSTLINE=$(head -n 1 $SCRIPT)
if [[ $FIRSTLINE =~ ^#!.* ]]; then
    CMD=$(echo "$FIRSTLINE" | sed -r -e 's/^..//')
    $CMD $SCRIPT
    echo "vimf6.sh shebang exit code is $?"
    exit 0
fi

# by extension
case "$SCRIPT" in \
vimf6.sh)
    echo "Inception B"
    exit 0
    ;;
*sh)  bash $SCRIPT;;
*py)  python2 $SCRIPT;;
*pl)  perl $SCRIPT;;
*php) php $SCRIPT;;
*md)
    f=~/.local/bin/grip
    if [[ ! -x "$f" ]]; then
        echo "$0 FATAL $f, run pip install --user grip"
        exit 1
    fi
    if pgrep grip &>/dev/null; then
        echo "$0 INFO killing current existing grip session with PID $(pgrep grip)"
        pkill -9 grip
    fi
    echo "$0 starting background grip preview should starting in new browser tab"
    nohup ~/.local/bin/grip --quiet --title "$SCRIPT" -b $SCRIPT &>/dev/null &
    exit 0
    ;;
*txt)
    echo "($(basename $0)): ignored for filetype $SCRIPT"
    exit 0
    ;;
*.plantuml)
    f=~/.tmp/bip.svg
    echo $f
    date
    cat $SCRIPT | docker run --rm -i think/plantuml > $f
    chromium-browser --incognito --new-window --app=file://$f
    date
    exit 0
    echo "please ensure to have run
docker run -d -p 8081:8080 plantuml/plantuml-server:jetty
        "
        echo wget -O/tmp/bip.svg "http://localhost:8081/svg/$(cat $SCRIPT | base64 | tr -d '\n')"
    ;;
$HOME/.config/i3/config)
    cd $HOME/.config/i3/
    i3 restart && sleep 5 && compton-i3-restart-reset-opacity.sh
    echo "i3 restarted A"
    ;;
$HOME/.config/i3/config.*)
    cd $HOME/.config/i3/
    ./stdhome-templating-config.sh
    i3 restart || true
	{ sleep 6 && compton-i3-restart-reset-opacity.sh; } &
    echo "i3 restarted B"
    ;;
*/Dockerfile)
	DIR=$(dirname $SCRIPT)
	if [[ -f $DIR/build.sh ]]; then
		bash $DIR/build.sh
	elif [[ -f $DIR/../build.sh ]]; then
		bash $DIR/../build.sh
	else
		docker build -f $SCRIPT
	fi
	;;
*)
    echo "($(basename $0)): unimplemented case for script $SCRIPT"
    exit 1
    ;;
esac
echo "vimf6.sh by extension exit code is $?" # to review if we have case exit corde or real interpreter
