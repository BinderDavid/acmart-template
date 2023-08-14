UNAME = $(shell uname)

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

ifeq ($(UNAME), Linux)
	OPEN = xdg-open
endif

ifeq ($(UNAME), Darwin)
	OPEN = open
endif

.PHONY: view
view:
	$(OPEN) paper.pdf &

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
