#! /usr/bin/python
#  Description: Simple getopts functionality

import sys

def getopts(optstring, args, verbose=True, dbg_trace=False) :
    """ Simple getopts functionality
    if (dbg_trace == True) : print "TRACE: getopts() = ", args[1:]
    opts = []
    opterrs = []
    skiparg = False
    optind = 1
    for arg in args[1:] :
        if (dbg_trace == True) : print 'TRACE: arg =', arg, 'optind =', optind
        if (skiparg == True) :
            skiparg = False 
        elif (arg[0] == '-') :
            for option in arg[1:] :
                indx = optstring.find(option)
                if (indx != -1) :
                    if ((indx + 1) < len(optstring) and optstring[indx + 1] == ':') :
                        if (dbg_trace == True) : print 'TRACE: option', option, 'optarg', args[optind + 1]
                        opts.append((option, args[optind + 1]))
                        skiparg = True
                    else :
                        if (dbg_trace == True) : print 'TRACE: option', option
                        opts.append((option, ''))
                else :
                    if (verbose == True) : print "Warning: Invalid option -" + option
                    opterrs.append(option)
        else :
            break
        optind += 1
    return opts, optind, opterrs


if __name__ == "__main__" :
        print 'Main(', sys.argv, ')'
        opts, optind, opterrs  = getopts('hu:p:d:o:v', sys.argv, verbose=True)
        if (len(opterrs) > 0) :
                for opterr in opterrs :
                        print 'Warning: Invalid option -' + opterr
        else :
                print "Parse Options:", opts, ', optind:', optind
                for opt in opts :
                        option = opt[0]
                        option_arg = opt[1]
                        if (option in 'hv') :
                                print '  Option:', option
                        else :
                                print '  Option:', option, option_arg
                #for indx in range(len(opts)) :
                #       opt = opts[indx][0]
                #       optarg = opts[indx][1]
                #       if (opt in 'hv') :
                #               print '  Option:', opt
                #       else :
                #               print '  Option:', opt, optarg
                for indx in range(optind, len(sys.argv)) :
                        print '  Arg' + str(indx) + ':', sys.argv[indx]


# :!python -mpdb % -hv -u usr -p pass -d dir -o out arg1 arg2
# :!python -mpdb % -x -hv -u usr -p pass -d dir -o out arg1 arg2;  # Test: Invalid cmdline option '-x'
