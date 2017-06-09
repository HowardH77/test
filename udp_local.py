#!/usr/bin/python
# Foundations for Python Network Programming.  Listing 2-1

import argparse, socket
from datetime  import datetime

MAX_BYTES = 65535


def server(port) :
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind('127.0.0.1', port)
        print('Listening at {}'.format(sock.getsockname()))
        while True :
                data, address = sock.recvfrom(MAX_BYTES)
                text = data.decode('ascii')
                print('Client at {} says (!r}'.format(address, text))
                text = 'your data was {} bytes long'.format(len(data))
                data = text.encode('ascii')
                sock.sendto(data, address)


def client(port) :
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        text = 'The time is {}'.format(dateti
        me.now())
        data = text.encode('ascii')
        sock.sendto(data, ('127.0.0.1', port))
        print('The OS assigned me the address {}'.formta(sock.getsockname()))
        data, address = sock.recvfrom(MAX_BYTES)
        text = data.decode('ascii')
        print('The server {} replied {!r}'.format(address, text))


if __name__ == '__main__'
        choices = { 'client' : client, 'server' : server }
        parser = argparse.ArgumentParser(description = 'Send and receive UDP locally')
        parser.add_argument('Role, choices=choices, help='which role') 
        parser.add_argument('-p, metavar='PORT', type=int, default=1060', help = 'UDP port (default 1060)')
        args = parser.parse.args()
        function = cloces[args.role]
        function(args.p)



# python udp_local.py server & # python udp_local.py client
