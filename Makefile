fName=main
authors=authors

clean:
	rm -f *.aux
	rm -f *.bcf
	rm -f *.bbl
	rm -f *.blg
	rm -f *lof
	rm -f *.log
	rm -f *.out
	rm -f *.toc
	rm -f  $(fName).pdf
openDLT:
	open  $(fName).pdf
pdfDLT: 
	make clean
	rm $(fName).aux; pdflatex $(fName).tex
	bibtex $(fName)
	pdflatex  $(fName).tex
	pdflatex  $(fName).tex
fastDLT: 
	pdflatex  $(fName).tex
fastTR: 
	pdflatex  $(fName).tex

pdf:
	make pdfDLT
open:
	make openDLT


pdf-authors:
	pdflatex  $(authors).tex
