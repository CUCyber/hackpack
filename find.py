#!/usr/bin/env python3
import argparse
import os
import os.path

parser = argparse.ArgumentParser(description='find all relevant files to include in a hackpack')
parser.add_argument('-e', '--exclude', action='append', dest='exclude', default=[], help='file to exclude')
parser.add_argument('-f', '--first', action='append', dest='first', default=[], help='folders to place first')
parser.add_argument('-l', '--last', action='append', dest='last', default=[], help='folders to place last')
parser.add_argument('-g', '--first-file', action='append', dest='first_file', default=[], help='files to place first')
parser.add_argument('-m', '--last-file', action='append', dest='last_file', default=[], help='files to place last')
parser.add_argument('dir', nargs='?', default='.', help='scan directory')

args = parser.parse_args()

for idx, name in enumerate(args.exclude):
    args.exclude[idx] = os.path.join(args.dir, name)

args.first.reverse()
args.first_file.reverse()

docs = []

for root, dirs, files in os.walk(args.dir):
    # handle files in order
    files.sort()

    # move first files
    for name in args.first_file:
        try:
            idx = files.index(name)

            path = os.path.join(root, name)
            if path not in args.exclude:
                del files[idx]

                files.insert(0, name)
        except ValueError:
            pass

    # move last files
    for name in args.last_file:
        try:
            idx = files.index(name)

            path = os.path.join(root, name)
            if path not in args.exclude:
                del files[idx]

                files.append(name)
        except ValueError:
            pass

    # handle files in directory before subdirectories
    for name in files:
        if name.endswith('.md'):
            path = os.path.join(root, name)
            if path not in args.exclude:
                docs.append(path)

    # handle subdirectories in order
    dirs.sort()

    # move first directories
    for name in args.first:
        try:
            idx = dirs.index(name)

            path = os.path.join(root, name)
            if path not in args.exclude:
                del dirs[idx]

                dirs.insert(0, name)
        except ValueError:
            pass

    # move last directories
    for name in args.last:
        try:
            idx = dirs.index(name)

            path = os.path.join(root, name)
            if path not in args.exclude:
                del dirs[idx]

                dirs.append(name)
        except ValueError:
            pass

print(' '.join(docs))
