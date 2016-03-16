#!/usr/bin/env python

# source: https://docs.python.org/2/library/socketserver.html

"""
Wed Mar 16 20:56:19 EET 2016, nickkouk

This is an experimental file for testing whether the python server side is
indeed working correctly. No real use in the communicatio with the Android.
"""

import socket
import sys

HOST, PORT = "localhost", 9998
filename = '40x_1st.mp4'

# maybe I shouldn't specify a CHUNK_SIZE as Python can handle it accordingly and
# increase the speed of the connection
# CHUNK_SIZE = 10000

s = socket.socket()
s.connect(('nick.lan', 9998))
f = open(filename, "rb") 

out = f.read(1024)
while (out):
    s.send(out)
    print("[CLIENT] Sent packet.")
    out = f.read()
    print("len(out) =  {}".format(len(out)))
    print("[CLIENT] Read from file.")

print("[CLIENT] Closing connection")
s.close()
