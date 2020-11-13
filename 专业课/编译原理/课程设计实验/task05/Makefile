
CC = gcc

all: lambda
COMOBJ = y.tab.o lex.yy.o emalloc.o tree.o

# ------------------------------------------------------------

.c.o:
	 $(CC)  -pg -g3 -Wall $(INCLUDE) -c $(CFLAGS) $(MODEL) $*.c

#------------------------------------------------------------

lex.yy.c:  lexer.l
	flex  lexer.l

y.tab.c y.tab.h:  grammar.y
	byacc -tvd grammar.y
#------------------------------------------------------------

lambda:  $(COMOBJ) 
	$(CC) -pg -g3 -o lambda $(LIB) $(MODEL) $(COMOBJ) $(CLIB)

# ----------------------------------------------------------------------

clean: 
	rm *.o y.tab.c y.tab.h lex.yy.c
#

emalloc.o: emalloc.c
lex.yy.o: lex.yy.c tree.h y.tab.h
tree.o: tree.c tree.h 
y.tab.o: y.tab.c tree.h 


