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

SITE_NAME=CU Cyber
SITE_URL=https://cucyber.net
SITE_TWITTER=@CU_Cyber
SITE_DESCRIPTION=CU Cyber is a student led organization at Clemson University that focuses on the technical and social aspects of cyber security

WEBSITE=../website
SITE=/_site

SOURCES!="./$(FIND)" -e 'LICENSE.md' -e 'README.md' -e "$(OUTDIR)" -f general -f checklists -l appendix -g index.md .

all: $(OUTFILE)

open: $(OUTFILE)
	which xdg-open >/dev/null 2>&1 && (setsid xdg-open "$(OUTFILE)" >/dev/null 2>&1 &) || open "$(OUTFILE)" >/dev/null 2>&1

website: $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)

serve: $(OUTDIR)$(ROOT)$(OUTFILE_HTML) $(OUTDIR)/images/ $(OUTDIR)/fonts/ $(OUTDIR)/css/ $(OUTDIR)/js/
	"./$(SERVE)" "$(OUTDIR)"

update: $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE) $(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)
	git -C "$(WEBSITE)" add ".$(SITE)$(ROOT)$(OUTFILE)" ".$(SITE)$(ROOT)$(OUTFILE_HTML)"
	git -C "$(WEBSITE)" commit -m "update hackpack"
	git -C "$(WEBSITE)" push

clean:
	rm -f "$(OUTFILE)" "$(OUTFILE_HTML)"
	rm -rf "$(OUTDIR)"

$(OUTFILE): $(SOURCES)
	pandoc --template="$(TEMPLATE)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE)" $(SOURCES)

$(OUTFILE_HTML): $(SOURCES)
	pandoc --filter="$(FILTER_HTML)" --template="$(TEMPLATE_HTML)" --highlight-style="${HIGHLIGHT_STYLE}" --standalone --toc --output "$(OUTFILE_HTML)" --metadata=root:"$(ROOT)" --metadata=path:"$$(dirname "$(ROOT)$(OUTFILE_HTML)")" --metadata=file:"$(ROOT)$(OUTFILE_HTML)" --metadata=site_name:"$(SITE_NAME)" --metadata=site_url:"$(SITE_URL)" --metadata=site_twitter:"$(SITE_TWITTER)" --metadata=site_description:"$(SITE_DESCRIPTION)" $(SOURCES)

$(OUTDIR)$(ROOT)$(OUTFILE_HTML): $(OUTFILE_HTML)
	mkdir -p "$(OUTDIR)$(ROOT)"
	cp "$(OUTFILE_HTML)" "$(OUTDIR)$(ROOT)$(OUTFILE_HTML)"

$(OUTDIR)/%/: $(WEBSITE)/%/
	rsync -av --delete "$^" "$@"
	touch "$@"

$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE): $(OUTFILE)
	cp "$(OUTFILE)" "$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE)"

$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML): $(OUTFILE_HTML)
	cp "$(OUTFILE_HTML)" "$(WEBSITE)$(SITE)$(ROOT)$(OUTFILE_HTML)"

.PHONY: all open update clean
