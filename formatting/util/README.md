C++ Manual Page Compiler
========================

Trim and convert C++ man pages (from '[cppman](https://github.com/aitjcize/cppman)') to a TeX file.


Installation
------------

Install 'cppman' and cache all man pages from 'cppreference.com'.

```sh
$ pip install --user cppman
$ cppman -s 'cppreference.com' -c
```


Usage
-----

Configure the program by editing the `manpages` variable with all of the desired sections and associated man pages and the `sections` variable with all of the desired sections from the pages (common across all man pages - for classes and functions/methods).

```sh
$ ./convertcppman.py cppstdlib.tex
```
