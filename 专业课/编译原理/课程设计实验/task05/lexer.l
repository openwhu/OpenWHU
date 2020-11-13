%{
#include <stdio.h>
#include <string.h>
#include "tree.h"
#define YYSTYPE TREE
#ifdef __TURBOC__  
#include "y_tab.h"
#else
#include "y.tab.h"
#endif
extern AST * yylval;
%}

%%
let  return LET;
if   return IF;
then return THEN;
else return ELSE;
fi  return FI;
[a-zA-Z][a-zA-Z0-9]*|"-"|"+"|"*"|"/"|"<"  { 
            char *id = (char *) smalloc(yyleng + 1);
            strcpy(id, yytext);
            yylval = make_string(id);
            return ID ;
           }
"#".*\n ;
[0-9]+  { int i = atoi (yytext);
          yylval = make_const(i);
          return INT;
      }
[ \t\n]+      { ; }

"=" {
      char *id;
      if (is_decl) {is_decl = 0; return '=';}
      id = (char *) smalloc(yyleng + 1);
      strcpy(id, yytext);
      yylval = make_string(id);
      return ID;
}
"@"|"("|")"|"."|";"            { return yytext[0]; }

.             { 
               printf ("illegal character '%c' is skip!\n", 
                       yytext[0]);
              }

<<EOF>>  { if (yyin != stdin) {
     fclose(yyin);
     printf("please input a lambda term with \";\":\n");  
     fflush(stdin);
     yyin = stdin;
     yy_set_interactive(1);
    }
    else {
      yyterminate();
     }
}

%%

int yywrap ()
{
 return 1;
}  
