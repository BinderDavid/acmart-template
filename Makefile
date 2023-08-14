UNAME = $(shell uname)

ifeq ($(UNAME), Linux)
	OPEN = xdg-open
endif

ifeq ($(UNAME), Darwin)
	OPEN = open
endif

.PHONY: view
view:
	$(OPEN) paper.pdf &

.PHONY: clean
clean:
	latexmk -C
	rm paper.txt


# The content of these latexenvironments is ignored by the detex target
DETEXIGNORE = array,eqnarray,equation,longtable,picture,tabular,verbatim,CCSXML
.PHONY: detex
detex:
	@detex -l -e $(DETEXIGNORE) paper.tex > paper.txt

.PHONY: spell
spell: detex
	@cat paper.txt | aspell --lang=en --add-wordlists=Allowed.txt list
	@rm paper.txt
