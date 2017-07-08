#!/usr/bin/env python3
import json
import sys

from pandocfilters import walk, Header, Link, Para, Str


depth = 0
jump = Para([Link(['', [], []], [Str('Jump to Top')], ('#', 'top'))])


def add_to_headers(key, val, fmt, meta):
    global depth

    if key == 'Header':
        lvl, attr, inline = val

        if lvl > depth:
            depth += 1
            return
        elif lvl < depth:
            depth = lvl

        if lvl <= 3:
            return [jump, Header(lvl, attr, inline)]


def jump_to_top(doc, fmt):
    doc = walk(doc, add_to_headers, fmt, doc['meta'] if 'meta' in doc else {})

    doc['blocks'].append(jump)

    return doc


if __name__ == "__main__":
    json.dump(jump_to_top(json.load(sys.stdin), sys.argv[1] if len(sys.argv) > 1 else ''), sys.stdout)
