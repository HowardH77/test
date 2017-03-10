#! /usr/bin/python
#  very simple diff written in python

def debug_print(item) : print "DEBUG:", item


def readfile(filename) :
        # Q: with statement
        # with open(filename, 'r') as fd :
        #       l = map(lambda ln : ln[:-1], fd.readlines())
        fd = open(filename, 'r')
        l = map(lambda ln : ln[:-1], fd.readlines())
        fd.close()
        return l


def diff_2items(item1, item2) :
        if (item1 != item2) :
                return [item1, item2]
        return ['', '']   # Todo: remove hack

def print_diff_item(list) :
        if (list[0] != '' and list[1] != '') :
                print '<', list[0]
                print '>', list[1]
                print

def diff_2files(file1, file2) :
        diffs = map(diff_2items, file1, file2)
        map(print_diff_item, diffs)



import sys
file1 = readfile(sys.argv[1])
# map(debug_print, file1)
file2 = readfile(sys.argv[2])
# map(debug_print, file2)

diff_2files(file1, file2)

