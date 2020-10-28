# You must set TCHOME to your proper TC Home Directory!
TCHOME=c:\TC

CFLAGS	= -v -O 
INCLUDE = -I$(TCHOME)\include;.
LIB = -L$(TCHOME)\lib;.
CC	= $(TCHOME)\tcc
MODEL  = -mc

.c.obj:
	 $(CC) $(INCLUDE) -c $(CFLAGS) $(MODEL) $*.c

OBJ = lex.obj name.obj main.obj

all: plain.exe improved.exe retval.exe affix.exe retsuff.exe retinf.exe

plain.exe: $(OBJ) plain.obj
	$(CC) -eplain.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) plain.obj

improved.exe: $(OBJ)  improved.obj
	$(CC) -eimproved.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) improved.obj

affix.exe: $(OBJ) affix.obj
	$(CC) -eaffix.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) affix.obj


retval.exe: $(OBJ) retval.obj
	$(CC) -eretval.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) retval.obj


retsuff.exe: $(OBJ) retsuff.obj
	$(CC) -eretsuff.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) retsuff.obj

retinf.exe: $(OBJ) retinf.obj
	$(CC) -eretinf.exe $(LIB) $(MODEL) $(CLIB) $(OBJ) retinf.obj

lex.obj plain.obj retval.obj retinf.obj: lex.h

clean:
	del  *.obj 
	del plain.exe
	del retval.exe
	del improved.exe
	del retsuff.exe
	del retinf.exe
