ALL:
	make compile
	make prepare
	make rcpp
	make roxygen
	make clean
	make build
	make check
	make install

win:
	make prepare
	make rcpp
	make roxygen
	make clean
	make buildwin
	make check
	make install

docs:
	make compile
	make prepare
	make rcpp
	make roxygen

compile: inst/ADMB/src/densfuns.cpp inst/ADMB/src/detfuns.cpp inst/ADMB/src/secr.tpl
	if [ $(shell hostname) == "heton" ]; then cd inst/ADMB/src; admb -O secr.tpl; rm -rfv secr.cpp secr.htp secr.o secr.obj; cd ../bin/linux; rm -rfv secr; mv ../../src/secr ./secr; fi
	if [ $(shell hostname) == "albatross.mcs.st-and.ac.uk" ]; then cd inst/ADMB/src; admb -O secr.tpl; rm -rfv secr.cpp secr.htp secr.o secr.obj; cd ../bin/mac; rm -rfv secr; mv ../../src/secr ./secr; fi
	if [ $(shell hostname) == "Zeeba" ]; then cd inst/ADMB/src; admb -O secr.tpl; rm -rfv secr.cpp secr.htp secr.o secr.obj; cd ../bin/windows; rm -rfv secr.exe; mv ../../src/secr.exe ./secr.exe; fi

prepare:
	rm -rfv man
	rm -fv NAMESPACE src/*.o src/RcppExports.cpp src/admbsecr.so src/symbols.rds R/RcppExports.R

rcpp:
	R --slave -e "library(Rcpp); compileAttributes()"

roxygen:
	R --slave -e "library(roxygen2); roxygenise('.')"

build:
	R CMD build .
	mv admbsecr_1.0.2.tar.gz .Rbuildignore/

buildwin:
	rm -rfv .Rbuildignore
	R CMD build .
	mkdir .Rbuildignore
	mv admbsecr_1.0.2.tar.gz .Rbuildignore/

check:
	R CMD check .Rbuildignore/admbsecr_1.0.2.tar.gz --no-tests

install:
	R CMD INSTALL . --install-tests

pdf:
	R CMD Rd2pdf --pdf . &
	rm ..pdf

clean:
	rm -rfv ..Rcheck/ ..pdf
	rm -rfv src/*.o src/*.so src/*.rds
	rm -rfv src-i386/ src-x64/ src/admbsecr.dll
	rm -rfv admbsecr.Rcheck

