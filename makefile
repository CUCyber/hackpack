SHELL=/bin/bash

OUTFILE=hackpack.pdf

TEMPLATE=./cyber.latex
HIGHLIGHT_STYLE=tango

FIND=./find.py

WEBSITE=../website

SOURCES!="$(FIND)" -e 'LICENSE.md' -e 'README.md' -f general -f checklists -l appendix -g index.md .

all: $(OUTFILE)

open: $(OUTFILE)
	xdg-open "$(OUTFILE)" &>/dev/null & disown

update: $(WEBSITE)/$(OUTFILE)

clean:
	rm -f "$(OUTFILE)"

$(OUTFILE): $(SOURCES)
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE)" $(SOURCES)

$(WEBSITE)/$(OUTFILE): $(OUTFILE)
	cp $(OUTFILE) $(WEBSITE)/documents/

	git -C "$(WEBSITE)" add documents/"$(OUTFILE)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

.PHONY: all open update clean
