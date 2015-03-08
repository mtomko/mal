all: step1.native

step1.byte: ocaml/*.ml ocaml/*.mli ocaml/*.mly ocaml/*.mll
	ocamlbuild -use-menhir -tag thread -use-ocamlfind -quiet -pkg core ocaml/step1.byte

step1.native: ocaml/*.ml ocaml/*.mli ocaml/*.mly ocaml/*.mll
	ocamlbuild -use-menhir -tag thread -use-ocamlfind -quiet -pkg core ocaml/step1.native

.PHONY: clean
clean:
	rm -rf ocaml/*.byte ocaml/*.native *.native *.byte _build
 
