CC=gcc -Wall 
.c.o:
	echo rebuilding $*.o from $*.c
	$(CC) -g3 -c $<

all: reg2dfa

reg2dfa: ast.o  parser.o main.c
	$(CC) -g3 -o ./reg2dfa $^

#nfa.o: ast.h nfa.c
ast.o: ast.c ast.h
parser.c: ast.h

clean: 
	rm -f *.o 

