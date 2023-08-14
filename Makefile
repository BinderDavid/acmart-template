UNAME = $(shell uname)

ifeq ($(UNAME), Linux)
	OPEN = xdg-open
endif

ifeq ($(UNAME), Darwin)
	OPEN = open
endif

# #############################################################################
# Building
#
# Usage: make
#
# #############################################################################

.PHONY: all
all: review camera-ready

.PHONY: review
review:
	latexmk review.tex

.PHONY: camera-ready
camera-ready:
	latexmk camera-ready.tex

# #############################################################################
# Cleaning
#
# Usage: make clean
#
# #############################################################################

.PHONY: clean
clean:
	latexmk -C
	rm paper.txt

# #############################################################################
# Opening file
#
# Usage: make view
#
# #############################################################################


.PHONY: view
view:
	$(OPEN) camera-ready.pdf &

# #############################################################################
# Spellchecking
#
# Usage: make spell
#
# #############################################################################

# The content of these latexenvironments is ignored by the detex target
DETEXIGNORE = array,eqnarray,equation,longtable,picture,tabular,verbatim,CCSXML
.PHONY: detex
detex:
	@detex -l -e $(DETEXIGNORE) paper.tex > paper.txt

.PHONY: spell
spell: detex
	@cat paper.txt | aspell --lang=en --add-wordlists=Allowed.txt list
	@rm paper.txt

# #############################################################################
# Latexdiff
#
# Usage: make latexdiff
#
# #############################################################################

COMPARISON = 6d26ff0711a3a584d834c53533ecb3af69a43f36
DIFFDIR = diff-base
.PHONY: latexdiff
latexdiff: latexdiff-clean
	@echo - Creating git worktree for commit $(COMPARISON)
	git worktree add $(DIFFDIR) $(COMPARISON)
	@echo - Expanding the files using latexpand
	cd $(DIFFDIR); latexpand camera-ready.tex --output camera-ready.expanded.tex
	latexpand camera-ready.tex --output camera-ready.expanded.tex
	@echo - Comparing the two files with "latexdiff" and writing output to "comparison.tex"
	latexdiff $(DIFFDIR)/camera-ready.expanded.tex camera-ready.expanded.tex > comparison.tex
	@echo - Compiling the generated "comparison.tex"
	latexmk comparison.tex
	@echo - Removing the git worktree
	git worktree remove --force $(DIFFDIR)


.PHONY: latexdiff-clean
latexdiff-clean:
	git worktree remove --force $(DIFFDIR) || true
	# remove expanded tex files
