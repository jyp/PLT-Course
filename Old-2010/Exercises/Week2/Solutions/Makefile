Answers.view: Answers.pdf
	evince $<

Answers.pdf: Answers.tex
	pdflatex $<

Answers.dvi: Answers.tex
	latex $<

Answers.tex: Answers.lhs *.lhs
	lhs2TeX $< > $@

