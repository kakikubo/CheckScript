#! /usr/bin/env python
'''

  2007 Kakikubo Teruo
  check_memcached.py 

  Check Memcached Server plugin. 
  This Plugin requires the memcached-Python API. 
  This Plugin was tested only in the python 2.5 

'''
import memcache
import signal
import os,sys

from optparse import OptionParser

pid = str(os.getpid())
# option
parser = OptionParser()
parser.add_option("-H","--hostname",dest="hostaddress",
                  help="Host Address", metavar=" <hostaddr>")
parser.add_option("-t","--timeout",dest="timeout",
                  help="timeout x seconds", metavar=" <timeout>", default=10)
parser.add_option("-p","--port",dest="port",
                  help="port number", metavar=" <port number>" , default=11211)
(opts,args)=parser.parse_args()

if not opts.hostaddress:
    parser.print_help()
    parser.error("UNKNOWN - Please specify Host")
    exit(2)

svr = u""
svr = str(opts.hostaddress) + ":" + str(opts.port)
mc = memcache.Client([ svr ], debug=0)

def handler(signum, frame):
    print "CRITICAL - timeout after " + str(opts.timeout) + " seconds"
    sys.exit(2)

signal.signal(signal.SIGALRM, handler)
signal.alarm(int(opts.timeout))

if not mc.set(pid,"nagios value"):
    print "CRITICAL - cannot set the value"
    sys.exit(2)
else:
    if not mc.get(pid) == 'nagios value':
        print "CRITICAL - cannot get the value"
        sys.exit(2)
    else:
	mc.delete(pid)
	print "OK - memcached alive"
        sys.exit(0)

