/*name.c XL·ÖÎöÆ÷ */

#include <stdio.h>

char  *Names[] = { "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
		   "t8", "t9", "t10", "t11", "t12", "t13", "t14", "t15" };

char  **Namep  = Names;

extern int yylineno;

char  *newname()
{
  if( Namep >= &Names[ sizeof(Names)/sizeof(*Names) ] ) {
    fprintf( stderr, "%d: Expression too complex\n", yylineno );
    exit( 1 );
  }

  return( *Namep++ );
}

freename(s)
char    *s;
{
  if( Namep > Names )
    *--Namep = s;
  else
    fprintf (stderr, "%d: (Internal error) Name stack underflow\n",
	     yylineno );
}
