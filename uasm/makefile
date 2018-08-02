uasm: scanner parser
	cc -ggdb -lfl -o uasm uasm.tab.c lex.yy.c

parser:
	bison -v -d uasm.y

scanner:
	flex uasm.l

test: uasm
	cat test.us | ./uasm

run: uasm
	./uasm

clean:
	rm lex.yy.c 

