
all: All.pdf AllNoAnswers.pdf AllWithAnswers.pdf

.PHONY: all

%.pdf: %.tex
	pdflatex -shell-escape $<

AllNoAnswers.pdf: AllNoAnswers.tex

AllWithAnswers.tex: All.tex
	runghc Preprocessor.hs True $< $@

AllNoAnswers.tex: All.tex
	runghc Preprocessor.hs False $< $@

