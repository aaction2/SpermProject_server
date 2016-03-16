#!/usr/bin/env/python

"""
NTUA, National Technical University of Athens
School of Mechanical Engineering
nickkouk, January 2016
"""

import os
import time


def watchDog(folder_path='.', timeout=None):
    """ Monitor a folder until a change in that folder takes place

    The function should return true when the folder contents are modified
    unless the specified timeout goes off when it should return true

    SOURCE:
    http://timgolden.me.uk/python/win32_how_do_i/watch_directory_for_changes.html

    TODO: Doesn't account for *updated* files (although you could get fancy
    with os.stat) 
    """

    sleep_time = 2 # seconds
    before = dict([(f, None) for f in os.listdir(folder_path)])
    
    # set the while condition
    if timeout:
        max_time = timeout + time.time()
        cond = lambda: max_time > time.time()
    else:
        cond = lambda: True

    while cond():
        time.sleep(sleep_time)
        after = dict([(f, None) for f in os.listdir(folder_path)])
        added = [f for f in after if f not in before]
        removed = [f for f in before if f not in after]

        if len(added) != 0 or len(removed) != 0:
            changes = {'added': added, 'removed': removed}
            return (True, changes)
        before = after

    # if we reached this point, timeout has passed
    return (False, None)
