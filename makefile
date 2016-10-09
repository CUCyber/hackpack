OUTFILE='./hackpack.pdf'

FIND='./find.py'

TEMPLATE='cyber.latex'

WEBSITE='../website'

all: $(OUTFILE)

open: $(OUTFILE)
	setsid xdg-open $(OUTFILE) &>/dev/null

update: $(WEBSITE)/$(OUTFILE)

clean:
	rm -rf $(BUILDDIR)
	rm -f $(OUTFILE)

$(OUTFILE):
	pandoc --template=$(TEMPLATE) --standalone --toc --output $(OUTFILE) $$($(FIND) -e 'LICENSE.md' -e 'README.md' .)

$(WEBSITE)/$(OUTFILE):
	cp $(OUTFILE) $(WEBSITE)/

.PHONY: all open update clean
