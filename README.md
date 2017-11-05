CU Cyber Hackpack
=================

In this repository are the markdown sources to the hackpack used by CU Cyber in general and at competitions. An up-to-date build of the hackpack is available in HTML at [https://cucyber.net/documents/hackpack.html](https://cucyber.net/documents/hackpack.html) and in PDF at [https://cucyber.net/documents/hackpack.pdf](https://cucyber.net/documents/hackpack.pdf).


## Dependencies

* make
* git
* python3
* pandoc
* pandocfilters
* texlive-latexextra


### Debian/Ubuntu/Kali

```sh
$ sudo apt install make git python3 pandoc python3-pandocfilters texlive-latex-extra
```


### RedHat/CentOS

```sh
$ sudo yum install epel-release
$ sudo yum install make git python34 pandoc texlive-collection-latexextra
$ sudo pip3 install pandocfilters
```


### Fedora

```sh
$ sudo dnf install make git pandoc python3-pandocfilters texlive-collection-latexextra
```


### Arch

```sh
$ sudo pacman -S make git pandoc python-pandocfilters texlive-latexextra
```


### Gentoo

```sh
$ sudo emerge dev-vcs/git dev-lang/python:3.4 app-text/pandoc dev-texlive/texlive-latexextra
$ sudo pip3 install pandocfilters
```


### macOS

Requires [Homebrew](https://brew.sh/) and [Homebrew Cask](https://caskroom.github.io/). Use `gmake` instead of `make`.

```sh
$ brew install make git python3 pandoc
$ brew cask install mactex
$ pip3 install pandocfilters
```


## Downloading

```sh
$ git clone https://github.com/CUCyber/hackpack.git
```


## Building

To build the entire hackpack into a single pdf file, edit the 'makefile' as desired and run `make`.


## Testing

To build the entire hackpack and open the pdf file, edit the 'makefile' as desired and run `make open`.


## Updating

To build the entire hackpack and upload it to the website automatically, edit the 'makefile' as desired and for the website git repository location and run `make update`. You must have push access to the repository at the specified directory.


## Cleaning

To clean out any generated files, run `make clean`.
