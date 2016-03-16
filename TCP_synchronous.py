#!/usr/bin/env python

"""
NTUA, National Technical University of Athens
School of Mechanical Engineering
nickkouk, January 2016

This is the main module for the server-side communication. 
The module was written and tested in OSX but it should run without any change
in windows/linux machines as well.

Dependencies:
    - python 2.x

Usage: 
    - It first listens to a predefined Ip/port pair for connections
    - After the connection has succeeded it receives a video. 
    - Decodes the received file using base64 binary decoding
    - Places the output mp4 file in a predefined directory (videos_in/ready/). 

todo:
    - Use the logging function for outputing debugging/information messages to
      the user
    - Implement an authentication procedure for verifying the identity of the
      potential client
    - Feeling adventurous? Rewrite it using classes for additional flexibility,
      robustness

For more information/insight to the server usage refer to
    - http://biotech-ntua.wikispaces.com/Project_20152016_Spermodiagram#
    - https://github.com/bergercookie/Sperm3000_server

"""

# IMPORTS
import socket
import sys
import os
import datetime
import time
import shutil
from base64 import binascii
from watchDog import watchDog

"""
Implement a cross-language communication scheme for communication with matlab.
Python writes to the videos_in/pending_data, videos_in/ready_data (use literal
names as below) directories and reads from the results_out/ready_data,
results_out/ready_data directories.
"""
# Cross-language communication through folders
videos_in = 'videos_in'
results_out = 'results_out'
pending_data = 'pending'
ready_data = 'ready'

parent_dir = "".join([os.curdir, os.sep, videos_in])
pending_videos = "".join([parent_dir, os.sep, pending_data])
ready_videos = "".join([parent_dir, os.sep, ready_data])

parent_dir = "".join([os.curdir, os.sep, results_out])
pending_results = "".join([parent_dir, os.sep, pending_data])
ready_results = "".join([parent_dir, os.sep, ready_data])

# server-client connection settings
CHUNK_SIZE = 1024
filename = 'output.mp4'
port = 9999
num_connections = 5
#addr = "localhost"
addr = socket.gethostname()


print("Setting up the necessary folder structure")
# set up the folder structure if it doesn't exist
list0folders = [fname for fname in os.listdir(os.curdir) if
                os.path.isdir("".join([os.curdir, os.sep, fname]))]
if videos_in not in list0folders:
    os.mkdir(videos_in)
    os.mkdir(pending_videos)
    os.mkdir(ready_videos)
if results_out not in list0folders:
    os.mkdir(results_out)
    os.mkdir(pending_results)
    os.mkdir(ready_results)


# set up the connection
s = socket.socket()
s.bind((addr, port))
s.listen(num_connections)
print("[SERVER] Server is set up. Listening on port {}".format(port))

while True:
    sc, address = s.accept()
    print("[SERVER] Client connected: {}".format(address))
    time_start = time.time()

    # build the filename using the current timestamp (and the client IP?)
    now = datetime.datetime.now()
    filename = str(now).split('.')[0]
    filename = filename.replace(':', '_')
    filename = filename.replace(' ', '_')
    filename = filename.replace('-', '_')

    f_path = "".join([pending_videos, os.sep, filename])
    f = open(f_path, 'wb')

    rec = sc.recv(CHUNK_SIZE) # just read some here.
    print("[SERVER] Received from Client, len = {}".format(len(rec)))
    #print("[SERVER]: Client said: {}".format(rec))
    while (rec):
        f.write(rec)
        print("[SERVER] Written to file.")
        rec = sc.recv(CHUNK_SIZE)
        print("[SERVER] Received from Client, len = {}".format(len(rec)))
        #print("[SERVER]: Client said: {}".format(rec))

    # video has been received
    time_total = time.time() - time_start
    print("[SERVER] Received file.\n\tTransfer time: {}".format(time_total))

    # format the video appropriately
    f = open(f_path)
    conts = f.read()
    f.close()
    # decode and strip of the extra newline
    dec_conts = binascii.a2b_base64(conts)
    f_mp4 = "".join([f_path, '.mp4'])
    fout = open(f_mp4, 'wb')
    fout.write(dec_conts)
    fout.close()

    # move the file to the ready folder
    f_mp4_ready = "".join([ready_videos, os.sep, filename, '.mp4'])
    shutil.move(f_mp4, f_mp4_ready)
    print("[SERVER] Video available to MATLAB.")

    print("[SERVER] Waiting for MATLAB to finish analysis...")
    [changed, changelist] = watchDog(ready_results)
    # todo add flag if analysis was successful or not.
    print("[SERVER] Analysis finished")
    print("[SERVER] Files changed: {}".format(changelist))
    ## test for None just to make sure
    #if changelist:
        #files2send = changelist['added']
        #for a_file in files2send:
            #f_path = "".join(ready_results, os.sep, a_file)
            #print("[SERVER] Sending file to client:\n\t {}".format(f_path))
            #f = open(f_path)
            #conts = f.read()
            #sc.sendall(conts)
            #f.close()

    sc.close()
    print("[SERVER] Closed connection with client.")

s.close()
