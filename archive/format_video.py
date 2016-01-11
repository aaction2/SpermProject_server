#!/usr/bin/env python

from base64 import binascii

# open the file and read the contents
fin = open('output')
conts = fin.read()
fin.close()

# decode and strip of the extra newline
dec_conts = binascii.a2b_base64(conts)
#dec_conts = dec_conts.rstrip()

# write it to a file with '.mp4' suffix.
fout = open('output_decoded.mp4', 'wb')
fout.write(dec_conts)
fout.close()

print('Done...')

