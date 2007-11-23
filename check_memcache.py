#! /usr/bin/env python
'''
check_memcache.py 
set the temporary key and delete

'''
import memcache
import signal
import os

from optparse import OptionParser
pid = str(os.getpid())
# option
parser = OptionParser()
parser.add_option("-H","--hostname",dest="hostaddress",
                  help="Host Address", metavar="hostaddr")
parser.add_option("-t","--timeout",dest="timeout",
                  help="timeout x seconds", metavar="timo", default=10)
parser.add_option("-p","--port",dest="port",
                  help="port number", metavar="pt" , default=11211)
(opts,args)=parser.parse_args()

if not opts.hostaddress:
    parser.print_help()
    parser.error("Please specify Host")
    exit(2)

svr = u""
svr = str(opts.hostaddress) + ":" + str(opts.port)
mc = memcache.Client([ svr ], debug=1)
#mc = memcache.Client({opts.hostaddress}:{opts.port}, debug=1)
#mc = memcache.Client(["ocnblg-tc01-int:112"], debug=1)
if not mc.set(pid,"nagios value"):
    raise ValueError,"CRITICAL - cannot set the value"
    exit(2)
else:
    if not mc.get(pid) == 'nagios value':
        raise ValueError, "CRITICAL - cannot get the value"
        exit(2)
    else:
	mc.delete(pid)
	print "OK - memcached alive"
        exit 
