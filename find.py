#!/usr/bin/env python3
import argparse
import os
import os.path

parser = argparse.ArgumentParser(description='find all relevant files to include in a hackpack')
parser.add_argument('-e', '--exclude', action='append', dest='exclude', default=[], help='file to exclude')
parser.add_argument('dir', nargs='?', default='.', help='scan directory')

args = parser.parse_args()

for idx, name in enumerate(args.exclude):
    args.exclude[idx] = os.path.join(args.dir, name)

docs = []

for root, dirs, files in os.walk(args.dir):
    # handle index.md first
    try:
        idx = files.index('index.md')

        path = os.path.join(root, 'index.md')
        if path not in args.exclude:
            docs.append(path)

            del files[idx]
    except ValueError:
        pass

    # sort remaining files
    files.sort()

    # handle other files in directory before subdirectories
    for name in files:
        if name.endswith('.md'):
            path = os.path.join(root, name)
            if path not in args.exclude:
                docs.append(path)

    # handle subdirectories in order
    dirs.sort()

    # handle appendix last
    try:
        idx = dirs.index('appendix')

        path = os.path.join(root, 'appendix')
        if path not in args.exclude:
            del dirs[idx]

            dirs.append('appendix')
    except ValueError:
        pass

print(' '.join(docs))
