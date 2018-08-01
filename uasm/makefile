CC_FLAGS = -Wimplicit-function-declaration

uasm: scanner parser
	cc $(CC_FLAGS) -lfl -o uasm uasm.tab.c lex.yy.c

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

