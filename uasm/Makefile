uasm: uasm.tab.c lex.yy.c main.c ast.c
	cc -ggdb -lfl -o uasm uasm.tab.c lex.yy.c main.c ast.c

uasm.tab.c uasm.tab.h: uasm.y
	bison -v -d uasm.y

lex.yy.c: uasm.l
	flex uasm.l

test: uasm
	cat test.us | ./uasm

run: uasm
	./uasm

clean:
	rm -rf lex.yy.c uasm.output uasm.tab.c uasm.tab.h uasm.dSYM

