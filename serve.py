#!/usr/bin/env python
from __future__ import print_function

import subprocess
import sys
import time
import os

try:
    from http.server import SimpleHTTPRequestHandler
    from http.server import HTTPServer
except ImportError:
    from SimpleHTTPServer import SimpleHTTPRequestHandler
    from BaseHTTPServer import HTTPServer

outdir = sys.argv[1]
reldir = os.path.relpath('.', outdir)

os.chdir(outdir)

try:
    from watchdog.events import PatternMatchingEventHandler
    from watchdog.observers import Observer

    class MakeHandler(PatternMatchingEventHandler):
        def __init__(self, interval):
            PatternMatchingEventHandler.__init__(self, patterns=[os.path.join('*.res', '*'), '*.md'], ignore_patterns=[os.path.join(reldir, outdir, '*'), os.path.join('*', 'LICENSE.md'), os.path.join('*', 'README.md'), os.path.join('*', '.git', '*')], ignore_directories=True, case_sensitive=False)
            self.last = time.time()
            self.interval = interval

        def on_any_event(self, event):
            cur = time.time()
            if cur < self.last + self.interval:
                return

            print('rebuilding')
            subprocess.call(['make', '-C', reldir, 'website'], stdout=open('/dev/null'), stderr=subprocess.STDOUT)
            self.last = cur

    observer = Observer()
    observer.schedule(MakeHandler(interval=1), reldir, recursive=True)
    observer.start()
except ImportError:
    pass

print('serving "{}" at http://localhost:8080/'.format(outdir))

httpd = HTTPServer(('localhost', 8080), SimpleHTTPRequestHandler)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print('shutting down')
