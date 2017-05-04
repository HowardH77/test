#! /usr/bin/python

import sys

def print_hexdump(buf, buflen) :
    printable = '~`!@#$%^&*()-_=+[]{}\|;:\'\"<>,.?/'
    print_buf = ''
    for ch in buf :
        print "%02x " % ord(ch),   # Note trailing comma (newline suppressed)
        if (ch.isalnum() or ch in printable) :
            print_buf += ch
        else :
            print_buf += ' ' 
    for indx in range(buflen - len(buf)) : print '   ',
    print ' ' + print_buf
            
                
if __name__ == "__main__" :
        fd = open(sys.argv[1], 'r')
        buflen = 16     
        buf = fd.read(buflen)
        while (buf != '') :
                print_hexdump(buf, buflen)
                buf = fd.read(buflen)
        fd.close()      

                
#!% %         
