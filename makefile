SHELL=/bin/bash

OUTFILE=hackpack.pdf
OUTDIR=public
ROOT=/documents/

TEMPLATE=template.latex

OUTFILE_HTML=hackpack.html

FILTER_HTML=filter.py
TEMPLATE_HTML=template.html

HIGHLIGHT_STYLE=tango

FIND=find.py
SERVE=serve.py

WEBSITE=../website

SOURCES!="./$(FIND)" -e 'LICENSE.md' -e 'README.md' -e "$(OUTDIR)" -f general -f checklists -l appendix -g index.md .

all: $(OUTFILE)

open: $(OUTFILE)
	which xdg-open >/dev/null 2>&1 && (setsid xdg-open "$(OUTFILE)" >/dev/null 2>&1 &) || open "$(OUTFILE)" >/dev/null 2>&1

website: $(WEBSITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(ROOT)$(OUTFILE_HTML)

serve: $(OUTDIR)$(ROOT)$(OUTFILE_HTML) $(OUTDIR)/images/ $(OUTDIR)/fonts/ $(OUTDIR)/css/ $(OUTDIR)/js/
	"./$(SERVE)" "$(OUTDIR)"

update: $(WEBSITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(ROOT)$(OUTFILE_HTML)
	git -C "$(WEBSITE)" add ".$(ROOT)$(OUTFILE)" ".$(ROOT)$(OUTFILE_HTML)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

clean:
	rm -f "$(OUTFILE)" "$(OUTFILE_HTML)"
	rm -rf "$(OUTDIR)"

$(OUTFILE): $(SOURCES)
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE)" $(SOURCES)

$(OUTFILE_HTML): $(SOURCES)
	pandoc --filter="$(FILTER_HTML)" --template="$(TEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE_HTML)" $(SOURCES)

$(OUTDIR)$(ROOT)$(OUTFILE_HTML): $(OUTFILE_HTML)
	mkdir -p "$(OUTDIR)$(ROOT)"
	cp "$(OUTFILE_HTML)" "$(OUTDIR)$(ROOT)$(OUTFILE_HTML)"

$(OUTDIR)/%/: $(WEBSITE)/%/
	rsync -av --delete "$^" "$@"
	touch "$@"

$(WEBSITE)$(ROOT)$(OUTFILE): $(OUTFILE)
	cp "$(OUTFILE)" "$(WEBSITE)$(ROOT)$(OUTFILE)"

$(WEBSITE)$(ROOT)$(OUTFILE_HTML): $(OUTFILE_HTML)
	cp "$(OUTFILE_HTML)" "$(WEBSITE)$(ROOT)$(OUTFILE_HTML)"

.PHONY: all open update clean
