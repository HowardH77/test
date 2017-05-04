#! /usr/bin/python
#  Simple getopts functionality

import sys

def getopts(optstring, args) :
    ret_list = []
    ## print "TRACE: getopts() = ", args[1:]
    skiparg = False
    optindx = 1
    for arg in args[1:] :
        ## print 'TRACE: arg =', arg, 'optindx =', optindx
        if (skiparg == True) :
            skiparg = False
        elif (arg[0] == '-') :
            for opt in arg[1:] : 
                indx = optstring.find(opt)
                if (indx != -1) :
                    if ((indx + 1) < len(optstring) and optstring[indx + 1] == ':') :
                        ## print 'TRACE: option', opt, 'optarg', args[optindx + 1]
                        ret_list.append((opt, args[optindx + 1]))
                        skiparg = True
                    else :
                        ## print 'TRACE: option', opt
                        ret_list.append((opt, ''))
                else :
                    print "Warning: Invalid option ", opt
        else :
            break 
        optindx += 1
    return ret_list, optindx
    
    
if __name__ == "__main__" :
        print 'Main(', sys.argv, ')'
        options, optindx = getopts('hu:p:d:o:v', sys.argv)
        print "Parse Options:", options, ', optindx:', optindx
        for indx in range(len(options)) :
                opt = options[indx][0]
                optarg = options[indx][1]
                if (opt in 'hv') :
                        print '  Option:', opt
                else :
                        print '  Option:', opt, optarg
        for indx in range(optindx, len(sys.argv)) :
                print '  Arg ' + str(indx) + ':', sys.argv[indx]


# :!python -mpdb % -h -v -u usr -p pass -d dir -o out arg1 arg2
