
all: All.pdf AllNoAnswers.pdf

.PHONY: all

%.pdf: %.tex
	pdflatex -shell-escape $<

AllNoAnswers.pdf: AllNoAnswers.tex

AllNoAnswers.tex: All.tex
	runghc Preprocessor.hs False $< $@

