/* plain.c 	XL分析器*/
/* Basic parser, shows the structure but there's no code generation */

#include <stdio.h>
#include "lex.h"

statements()
{
    /*  statements -> expression SEMI
     *             |  expression SEMI statements
     */

    expression();

    if( match( SEMI ) )
	advance();
    else
        fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );

    if( !match(EOI) )
        statements();			/* 处理下个语句 */
}

expression()
{
    /* expression -> term expression' */

    term();
    expr_prime();
}

expr_prime()
{
    /* expression' -> PLUS term expression'
     *              | epsilon
     */

    if( match( PLUS ) )
    {
        advance();
        term();
        expr_prime();
    }
}

term()
{
    /* term -> factor term' */

    factor();
    term_prime();
}

term_prime()
{
    /* term' -> TIMES factor term'
     *       |   epsilon
     */

    if( match( TIMES ) )
    {
        advance();
        factor();
        term_prime();
    }
}

factor()
{
    /* factor   ->    NUM_OR_ID
     *          |     LP expression RP
     */

    if( match(NUM_OR_ID) )
        advance();

    else if( match(LP) )
    {
        advance();
        expression();
        if( match(RP) )
            advance();
        else
            fprintf( stderr, "%d: Mismatched parenthesis\n", yylineno);
    }
    else
	fprintf( stderr, "%d Number or identifier expected\n", yylineno );
}
