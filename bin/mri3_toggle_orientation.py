#!/usr/bin/env python3

import sys
import os
try:
    import mri3
except:
    sys.path.append(os.path.expanduser('~/py'))
    import mri3
import time

def t(w, cmd):
    pid = str(os.getpid())
    fp = os.path.expanduser('~/.tmp/tmp/mri3_toggle-orientation-{}'.format(w.id))
    try:
        with open(fp, 'w') as f:
            f.write(pid)
    except BaseException as e:
        pass
    w.command(cmd)
    w.command('border pixel 10')

    time.sleep(5)
    newpid = pid
    try:
        with open(fp, 'r') as f:
            newpid = f.read()
        if newpid == pid:
            w.command('border none')
            os.unlink(fp)
    except:
        w.command('border none')

w = mri3.get_root().find_focused()
ws = w.workspace()
p = w.parent
debug = 1
if debug: mri3.debug(ws)


if len(p.nodes) == 1:
    if 0 and p == ws:
        if p.orientation is None or p.orientation == 'none':
            if debug: print(6)
            t(w, 'split horizontal')
        elif p.orientation == 'horizontal':
            if debug: print(7)
            t(w, 'split vertical')
        else:
            if debug: print(8)
            t(w, 'split horizontal')
    elif p.orientation is None or p.orientation == 'none':
        if debug: print(1)
        t(w, 'split horizontal')
    elif p.orientation == 'horizontal':
        if debug: print(2)
        t(w, 'split vertical')
    elif p.orientation == 'vertical':
        if mri3.remove_single_child_containers(p):
            if debug: print(9)
            w.command('border none')
        else:
            if debug: print(10)
            t(w, 'split horizontal')
    else:
        if debug: print(4)
        pass
else:
    if debug: print(5)
    t(w, 'split horizontal')