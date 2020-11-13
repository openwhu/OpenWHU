/* lex.h      XL·ÖÎöÆ÷*/
#define EOI           0		/*  end of input                */
#define SEMI          1		/*       ;                      */
#define PLUS          2		/*       +                      */
#define TIMES         3		/*       *                      */
#define LP            4		/*       (                      */
#define RP            5		/*       )                      */
#define NUM_OR_ID     6		/* decimal number or identifier */
#define MINUS         7
#define DIVISION      8
extern char *yytext;		/* in lex.c                     */
extern int  yyleng;
extern int  yylineno;
