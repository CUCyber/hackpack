SHELL=/bin/bash

OUTFILE=hackpack.pdf
OUTFILE_HTML=hackpack.html

OUTDIR=public
WEBDIR=website
ROOT=/documents/

TEMPLATE=template.latex
FILTER_HTML=filter.py
TEMPLATE_HTML=template.html
WEBTEMPLATE_HTML=website.html

HIGHLIGHT_STYLE=tango

FIND=find.py
SERVE=serve.py

WEBSITE=../website
SITE=

SOURCES!="./$(FIND)" -e 'LICENSE.md' -e 'README.md' -e "$(OUTDIR)" -e "$(WEBDIR)" -f general -f checklists -l appendix -g index.md .

all: $(OUTDIR)/$(OUTFILE)

open: $(OUTDIR)/$(OUTFILE)
	which xdg-open >/dev/null 2>&1 && (setsid xdg-open "$(OUTDIR)/$(OUTFILE)" >/dev/null 2>&1 &) || open "$(OUTDIR)/$(OUTFILE)" >/dev/null 2>&1

open-html: $(OUTDIR)/$(OUTFILE_HTML)
	which xdg-open >/dev/null 2>&1 && (setsid xdg-open "$(OUTDIR)/$(OUTFILE_HTML)" >/dev/null 2>&1 &) || open "$(OUTDIR)/$(OUTFILE_HTML)" >/dev/null 2>&1

website: $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)

serve: $(OUTDIR)/$(OUTFILE) $(OUTDIR)/$(OUTFILE_HTML)
	"./$(SERVE)" "$(OUTDIR)"

update: $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)
	git -C "$(WEBSITE)" add ".$(SITE)$(ROOT)$(OUTFILE)" ".$(SITE)$(ROOT)$(OUTFILE_HTML)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

clean:
	rm -rf "$(OUTDIR)"
	rm -rf "$(WEBDIR)"

$(OUTDIR)/$(OUTFILE): $(SOURCES)
	mkdir -p "$(OUTDIR)"
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTDIR)/$(OUTFILE)" $(SOURCES)

$(OUTDIR)/$(OUTFILE_HTML): $(SOURCES)
	mkdir -p "$(OUTDIR)"
	pandoc --filter="$(FILTER_HTML)" --template="$(TEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTDIR)/$(OUTFILE_HTML)" --metadata=root:/ --metadata=path:/ --metadata=file:"$(OUTFILE_HTML)" $(SOURCES)

$(WEBDIR)$(ROOT)$(OUTFILE_HTML): $(SOURCES)
	mkdir -p "$(WEBDIR)$(ROOT)"
	pandoc --filter="$(FILTER_HTML)" --template="$(WEBTEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(WEBDIR)$(ROOT)$(OUTFILE_HTML)" --metadata=root:"$(ROOT)" --metadata=path:"$$(dirname "$(ROOT)$(OUTFILE_HTML)")" --metadata=file:"$(ROOT)$(OUTFILE_HTML)" $(SOURCES)

$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE): $(OUTDIR)/$(OUTFILE)
	mkdir -p "$(WEBSITE)$(SITE)$(ROOT)"
	cp "$(OUTDIR)/$(OUTFILE)" "$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE)"

$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML): $(WEBDIR)$(ROOT)$(OUTFILE_HTML)
	mkdir -p "$(WEBSITE)$(SITE)$(ROOT)"
	cp "$(WEBDIR)$(ROOT)$(OUTFILE_HTML)" "$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)"

.PHONY: all open open-html serve update clean
