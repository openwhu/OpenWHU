# You must set TCHOME to your proper TC Home Directory!
TCHOME=c:\TC
GOAL=html2txt
CFLAGS	= -v -O 
INCLUDE = -I$(TCHOME)\include;.
LIB = -L$(TCHOME)\lib;.
CC	= $(TCHOME)\tcc
MODEL  = -mc

.c.obj:
	 $(CC) $(INCLUDE) -c $(CFLAGS) $(MODEL) $*.c

OBJ = lexyy.obj 

all: $(GOAL).exe

$(GOAL).exe: $(OBJ) 
	$(CC) -e$(GOAL).exe $(LIB) $(MODEL) $(CLIB) $(OBJ)
 
lexyy.obj: lexyy.c
lexyy.c: $(GOAL).l
	 flex $(GOAL).l

clean:
	del  *.obj 
	del $(GOAL).exe