#!/usr/bin/awk

# MAKE SURE YOU MAKE BACKUPS BEFORE DESTRUCTIVELY RUNNING THIS SCRIPT ON ANYTHING!

# Preprocesses anything you want for use in differing hackpack versions.
# Run to standard output with:
#     awk -v V=(hackpack|hackpackpp) -f <this file> <file to process>
#
# Specifically, the script parses out #ifdef blocks. For example:
#
#     #ifdef hackpack
#        Slim and streamlined!
#     #endif
#     #ifdef hackpackpp
#        A tome of knowledge!
#     #endif
#
# ...would parse to just one of the two inner lines, depending on which option you
# pass in to the variable V.
#
# Written by Austin Anderson (@ProtractorNinja) with help from Stack Overflow.

BEGIN { doPrint = 1; }
/#ifdef hackpack *$/    { getline; doPrint = (V == "hackpack"); }
/#ifdef hackpackpp *$/  { getline; doPrint = (V == "hackpackpp"); }
/#endif *$/             { getline; doPrint = 1; }
{ if (doPrint) print $0; }
