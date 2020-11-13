
CFLAGS	= -v -O 
INCLUDE = -I\tc\include;. 
LIB = -L\tc\lib
CC	= \tc\tcc

MODEL  = -mc
CLIB	 = 
all: lambda.exe
COMOBJ = emalloc.obj tree.obj lexyy.obj y_tab.obj 

# ------------------------------------------------------------

.c.obj:
	 $(CC) $(INCLUDE) -c $(CFLAGS) $(MODEL) $*.c

#------------------------------------------------------------

lexyy.c:  lexer.l tree.h y_tab.c
	flex  lexer.l

y_tab.c:  grammar.y tree.h
	byacc -tvd grammar.y
#------------------------------------------------------------

lambda.exe:   $(COMOBJ) 
        $(CC) -elambda.exe $(LIB) $(MODEL) $(COMOBJ) $(CLIB)
	del lexyy.c 
	del y_tab.c 
	del y_tab.obj
	del y_tab.h

# ----------------------------------------------------------------------

clean: 
	del lambda.exe
	del lexyy.c 
	del y_tab.c 
	del y_tab.obj
	del y_tab.h
	del lexyy.obj
	del *.obj
#
lexyy.obj:	lexyy.c y_tab.h
y_tab.obj:	y_tab.c y_tab.h
y_tab.h:	grammar.y
tree.obj: 	tree.c tree.h
