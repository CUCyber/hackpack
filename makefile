SHELL=/bin/bash

OUTFILE=hackpack.pdf
ROOT=/documents/

TEMPLATE=./cyber.latex

OUTFILE_HTML=hackpack.html

FILTER_HTML=./html.py
TEMPLATE_HTML=./cyber.html

HIGHLIGHT_STYLE=tango

FIND=./find.py

WEBSITE=../website
SERVE=./serve.py

SOURCES!="$(FIND)" -e 'LICENSE.md' -e 'README.md' -f general -f checklists -l appendix -g index.md .

all: $(OUTFILE)

open: $(OUTFILE)
	xdg-open "$(OUTFILE)" &>/dev/null & disown

website: $(WEBSITE)$(ROOT)$(OUTFILE_HTML)

serve: $(WEBSITE)$(ROOT)$(OUTFILE_HTML)
	$(SERVE) $(WEBSITE)

update: $(WEBSITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(ROOT)$(OUTFILE_HTML)
	git -C "$(WEBSITE)" add ".$(ROOT)$(OUTFILE)" ".$(ROOT)$(OUTFILE_HTML)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

clean:
	rm -f "$(OUTFILE)" "$(OUTFILE_HTML)"

$(OUTFILE): $(SOURCES)
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE)" $(SOURCES)

$(OUTFILE_HTML): $(SOURCES)
	pandoc --filter="$(FILTER_HTML)" --template="$(TEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE_HTML)" $(SOURCES)

$(WEBSITE)$(ROOT)$(OUTFILE): $(OUTFILE)
	cp "$(OUTFILE)" "$(WEBSITE)$(ROOT)"

$(WEBSITE)$(ROOT)$(OUTFILE_HTML): $(OUTFILE_HTML)
	cp "$(OUTFILE_HTML)" "$(WEBSITE)$(ROOT)"

.PHONY: all open update clean
