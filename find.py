#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import argparse
import itertools

def parse_args():
    """parse arguments"""
    parser = argparse.ArgumentParser(description='find all relevant files to include in a hackpack')

    parser.add_argument('-e', '--exclude', action='append', dest='exclude', default=[], help='file to exclude')
    parser.add_argument('-f', '--first', action='append', dest='first', default=[], help='folders to place first')
    parser.add_argument('-g', '--first-file', action='append', dest='first_file', default=[], help='files to place first')
    parser.add_argument('-l', '--last', action='append', dest='last', default=[], help='folders to place last')
    parser.add_argument('-m', '--last-file', action='append', dest='last_file', default=[], help='files to place last')
    parser.add_argument('dir', nargs='?', default='.', help='scan directory')

    return parser.parse_args()

def find_files(first_dirs, first_files, last_files, last_dirs, root_dir, excludes):
    excludes = set(excludes)

    for root, dirs, files in os.walk(root_dir):
        all_files = set(files) - excludes
        #use lists to preserve order and to allow multiple iterations
        ffiles = [i for i in first_files if i in all_files]
        lfiles = [i for i in last_files if i in all_files]
        rfiles = sorted((all_files - set(ffiles)) - set(lfiles))

        for doc in itertools.chain(ffiles,rfiles,lfiles):
            if doc.endswith(".md"):
                yield os.path.join(root,doc)

        all_dirs = set(dirs)
        fdirs = [i for i in first_dirs if i in all_dirs]
        ldirs = [i for i in last_dirs if i in all_dirs]
        rdirs = sorted((all_dirs - set(fdirs)) - set(ldirs))

        #dirs must be modified in-place for os.walk
        dirs[:] = itertools.chain(fdirs,rdirs,ldirs)

def main():
    args = parse_args()
    files = find_files(args.first, args.first_file, args.last_file,
                       args.last, args.dir, args.exclude)
    print(' '.join(files))

if __name__ == "__main__":
    main()
