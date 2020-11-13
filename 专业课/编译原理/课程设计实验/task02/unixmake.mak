GOAL=html2txt
CC=gcc
.c.o:
	echo rebuilding $*.o from $*.c
	$(CC) -ggdb -c $<

all: $(GOAL)

$(GOAL): lex.yy.c 
	$(CC) -o ./$(GOAL) lex.yy.c

lex.yy.c: $(GOAL).l
	flex $(GOAL).l

clean: 
	rm -f *.o  lex.yy.c 

# DO NOT DELETE

