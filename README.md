Clemson Cyber Defense Hackpack
==============================

This is the team hackpack for the Clemson Cyber Defense Team.  It is a resource
for blue teams competing in red vs blue cyber defense completions.

How do I get set up?
--------------------

We will use the following tools to maintain and build the hackpack:

-   `git` - for tracking changes
-   `awk` - text processing tool needed for version directives
-   `pdflatex` - The Hackpack body is written in LaTeX
-   `make` - Make is to automate compilation and testing of the documents
-   `perl` - required to support renaming in version directives
-   `find` - the gnu version of find is required supporting extended posix
	regular expressions for supporting version directives.  On OSX the
	`findutils` package from homebrew can be used

Contribution Guidelines
-----------------------

For all projects and improvements:

1.  Clone the repo
2.  Choose an issue from the issue tracker
3.  Checkout a new branch with the topic as the name
4.  Push the branch to the repo
5.  When the branch is complete, create a pull request in Bitbucket
6.  When the pull request is reviewed and approved, the code will be merged by
    one of the admins into master.

If you have any questions related to the issues in the tracker, comment on the
issues and CC one of the admins.


#### Folder Structure and File Naming conventions
All examples assume a topic called `foo` and a sample script `bar` on operating
system `os`:

General guidelines:

-	All file names should be lowercase with `-` (hyphens) separating the words
	in a file.  For example, `ten-commandments.tex` instead of
	`TenCommandments.tex`
-	All scripts should be in a subdirectory called `scripts`
	and in a further subdirectory based on the script name.  For example if the
	topic `foo` has a script `bar` the path to the code sample could be `foo/problems/bar/bar.sh`.
-	In the _rare_ circumstance that your finished product is only one `tex` file,
	place it in `general` instead
-	See how the `firewall` material is laid out for reference.  It is in
	`firewalls/` directory

Naming conventions:

-	`foo` the name of the branch where `foo` is being worked on
-	`foo.tex` the hackpack documentation on the algorithm
-	`bar.sh` A script written in bash.
-	`bar.ps1` A script written in Microsoft Powershell.
-	`bar.py` A script written in python. Scripts should be written in Python 3.
-	`bar.in`  sample input for `foo.{sh,ps1,py}` if applicable
-	`bar.out` sample output for `foo.{sh,ps1,py}` if applicable
-	`bar.example` files such as `.vimrc` that do not have an extension normally
-	`bar.bats` Automated test case written in bats for the script `bar` that
	shows that it is correct
	_Do Not Include ISO Images In The Repo_.  This is to make them easier to spot them in the gitignore.
-	`Dockerfile-bar-os` Docker environment that can be used to test bar on os.
-	`Vagrentfile-bar-os` Vagerantfile that defines an environment that could be use to test bar on os.

#### Writing Documentation 
For each item in the Hackpack, please include the following in clearly delineated subsections:

1.  Name and Brief Description of the topic
2.  A list of possible uses, applications, and best practices.
3.	Sample scripts and con fig files where applicable
4.  Please use the `\acmlisting` for code listings.  A caption and label should
	be specified.  If applicable, line ranges should be specified to limit the
	amount of text displayed.
5.  It would be preferred if each set of sample code had some lessons learned to
	point out some key elements of the implementation
6.  References using BibTeX where applicable
7.  Should be "compiled" properly by make
8.  Each sentence must be on a separate line.
9.  The condensed version of the hackpack should have the following removed:
    
    -   Introductions to the topic.
    -   Guidelines directing the reader to different sections of the hackpack.
    -   As much as possible, index tags should __NOT__ be removed.

#### Writing Code
Code Must meet the following standards:

1.  Code should be indented with tabs and not exceed 80 characters per line.
2.  Code must be delivered with the passing unit tests.
    where applicable
3.  Code must be concise but not at the expense of readability
4.  Source code must solve a problem:  It should solve a specific problem and
    include all relevant IO and supporting code.  The script should not be in
    a vacuum.
5.  The condensed hackpack version should have the following removed:

    -   Comments that are not _critical_ to the readers understanding
        understanding

#### Writing Tests
All code must have tests that meet the following requirements

1.	All tests should be written using the [bats framework][]  See the
	`firewalls/iptables` section for an example.
2.  Testing files should be postfixed by `-test` prior to the extension.  For
    example,  `foo.cpp` test files should be called `foo-test.cpp` and
    `foo-test.in` respectively
3.  Tests should be runnable by calling `make test` in the directory of the source

    -   The tests should return 0 in the case that all test cases passed
    -   The tests should return 2 in the case that any test cases failed
4.	For destructive tests such as applying configurations: a Dockerfile or
	Vagrentfile should be included along side tests, and
	tests should be run in this enviroment.

#### Different Versions of the Hack Pack

The hack pack is from one source built into two versions: one slim (`hackpack`)
and one tome-like (`hackpack++`, or as denoted in the build scripts,
`hackpackpp`). But how? By a combination of `awk` and dark magicks, authors can
use an extremely limited set of C-preprocessor-like `#ifdef`s to denote a block
of text or code as part of one version or the other. Here's an example:

	// #ifdef hackpackpp
	cout << "This is the Hack Pack: plusplus edition!" << endl;
	// #endif
	// #ifdef hackpack
	cout << "This is just the regular hack pack." << endl;
	// #endif

The first `cout` will only appear in the hackpack++'s code listing, and the
second will only appear in the normal hackpack. Note that the `#ifdefs` are
commented out: as long as the line _ends with the if directive_, they'll work
properly. You might want to comment them out so that they don't break the compilers.
Make sure you have a new line after each directive somewhere!

Here's a list of filetypes where the if directives will work:

-   `.tex`
-   `.cpp`
-   `.py`
-	`example`

#### Building the Hack Pack

The hack pack uses a Makefile for building our PDF output. Here's a rundown of
the make rules you'll probably be using:

-   `make clean` wipes out the build directory if you don't have a version of
    `latexmk` that supports the `-outdir` flag, and cleans it up with `latexmk -c`
    if you do.
-   `make hackpack` builds the slim version of the hackpack into `build/hackpack.pdf`.
-   `make hackpackpp` builds the bulky version of the hackpack into `build/hackpack.pdf`.
-   `make show` launches `evince` (a pdf viewer) to preview the hackpack.

[bats framework]: https://github.com/sstephenson/bats
[Dockerfile]: https://docs.docker.com/reference/builder/
[Vagrentfile]: https://docs.vagrantup.com/v2/vagrantfile/index.html
