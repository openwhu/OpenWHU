CC=gcc
.c.o:
	echo rebuilding $*.o from $*.c
	$(CC) -ggdb -c $<

all: plain improved retval affix retsuff retinf

plain: lex.o plain.o main.o 
	$(CC) -o ./plain plain.o lex.o main.o

retval: lex.o retval.o main.o  name.o
	$(CC) -o ./$@ $^

IMPROVED=improved
${IMPROVED}: lex.o ${IMPROVED}.o main.o name.o 
	$(CC) -o ./${IMPROVED} ${IMPROVED}.o lex.o main.o  name.o


affix: lex.o affix.o main.o 
	$(CC) -o ./affix name.o affix.o lex.o main.o

retsuff: lex.o retsuff.o main.o 
	$(CC) -o ./retsuff name.o retsuff.o lex.o main.o

retinf: lex.o retinf.o main.o 
	$(CC) -o ./retinf name.o retinf.o lex.o main.o
lex.o: lex.h
	$(CC) -c lex.c

clean: 
	rm -f *.o plain retval $(IMPROVED)  retsuff retinf affix

# DO NOT DELETE

