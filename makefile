SHELL=/bin/bash

OUTFILE=hackpack.pdf

TEMPLATE=./cyber.latex

OUTFILE_HTML=hackpack.html

FILTER_HTML=./html.py
TEMPLATE_HTML=./cyber.html

HIGHLIGHT_STYLE=tango

FIND=./find.py

WEBSITE=../website
DIRECTORY=documents/

SOURCES!="$(FIND)" -e 'LICENSE.md' -e 'README.md' -f general -f checklists -l appendix -g index.md .

all: $(OUTFILE)

open: $(OUTFILE)
	xdg-open "$(OUTFILE)" &>/dev/null & disown

update: $(WEBSITE)/$(DIRECTORY)$(OUTFILE) $(WEBSITE)/$(DIRECTORY)$(OUTFILE_HTML)

clean:
	rm -f "$(OUTFILE)" "$(OUTFILE_HTML)"

$(OUTFILE): $(SOURCES)
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE)" $(SOURCES)

$(OUTFILE_HTML): $(SOURCES)
	pandoc --filter="$(FILTER_HTML)" --template="$(TEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE_HTML)" $(SOURCES)

$(WEBSITE)/$(DIRECTORY)$(OUTFILE): $(OUTFILE) $(OUTFILE_HTML)
	cp "$(OUTFILE)" "$(OUTFILE_HTML)" "$(WEBSITE)/$(DIRECTORY)"

	git -C "$(WEBSITE)" add "$(DIRECTORY)$(OUTFILE)" "$(DIRECTORY)$(OUTFILE_HTML)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

.PHONY: all open update clean
