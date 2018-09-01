#!/usr/bin/env python3
import io
import json
import sys

from pandocfilters import walk, Header, Link, Para, Str


# record how many headers deep we are
depth = 0
# create node that is a block paragraph with a link that says 'Jump to Top' and hrefs '#top'
jump = Para([Link(['', [], []], [Str('Jump to Top')], ('#top', 'top'))])


# add jumps before headers of the document
def add_to_headers(key, val, fmt, meta):
    global depth

    # when we are at a header node
    if key == 'Header':
        # get details of header
        lvl, attr, inline = val

        # if we are at the first header of a larger section
        if lvl > depth:
            # record the depth and do not place a jump
            depth += 1
            return
        elif lvl < depth:
            # bring depth down to level
            depth = lvl

        # if the header is noteworthy, put a jump before it
        if lvl <= 3:
            return [jump, Header(lvl, attr, inline)]


# add jumps in all necessary places in the document
def jump_to_top(doc, fmt):
    # add jumps throughout the document
    doc = walk(doc, add_to_headers, fmt, doc['meta'] if 'meta' in doc else doc[0]['unMeta'])

    # add a jump at the bottom of the document
    try:
        doc['blocks'].append(jump)
    except TypeError:
        doc[1].append(jump)

    return doc


if __name__ == '__main__':
    # read JSON in, parse it with an optional format argument, and write JSON out
    json.dump(jump_to_top(json.load(io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')), sys.argv[1] if len(sys.argv) > 1 else ''), io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8'))
