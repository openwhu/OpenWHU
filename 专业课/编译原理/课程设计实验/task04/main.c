
/************************************************************/
/*      copyright hanfei.wang@gmail.com                     */
/*             2012.02.24                                  */
/************************************************************/

#include <ctype.h>
#include <stdlib.h>
#include "ast.h"


int main(void)
{
  printf("Please input a regular expression\n");
  printf("the Epsilon is represented by exlamation mark '!':\n");
  
  next_token ();
  
  start();

  return 0;
}
