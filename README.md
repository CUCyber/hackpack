CU Cyber Hackpack
=================

In this repository are the markdown sources to the hackpack used by CU Cyber in general and at competitions. An up-to-date build of the hackpack is available at [https://cucyber.net/hackpack.pdf]().


## Dependencies

* git
* python3
* pandoc
* texlive-latexextra


### Debian/Ubuntu/Kali

```sh
$ sudo apt install git python3 pandoc texlive-latex-extra
```


### RedHat/CentOS

```sh
$ sudo yum install epel-release
$ sudo yum install git python34 pandoc texlive-collection-latexextra
```


### Fedora

```sh
$ sudo dnf install git pandoc texlive-collection-latexextra
```


### Arch

```sh
$ sudo pacman -S git pandoc texlive-latexextra
```


### Gentoo

```sh
$ sudo emerge git python:3.4 pandoc texlive-latexextra
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
