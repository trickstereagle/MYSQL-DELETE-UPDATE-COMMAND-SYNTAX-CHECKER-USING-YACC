<h1 style="text-align: center;"> Compiler Design Project </h1>
<br>
<h2 style = "text-align : center;"> MYSQL : DELETE and UPDATE </h2>
<br>
<h3 style="text-align: center;"> By <br> Abhishek Gupta (Roll No. 01) <br> Divyansh Gupta (Roll No. 19) </h3>
<h3 style="text-align: right;"> Submitted to : Dr. Ankit Rajpal </h3>

<div>
<h2>AIM : </h2>
The objective is to design a compiler for MySQL language to check the syntax of DELETE and UPDATE operations. The compiler consists of two components viz. Lexical analyser and Syntax analyser. Lexical analyzer will scan the input code and generate tokens that will be consumed by the syntax analyser to create a parse tree.</div>


## Lex Code : 

``` c
%{
#include <stdio.h>
#include "y.tab.h"

%}

%%
(d|D)(e|E)(l|L)(e|E)(t|T)(e|E)        return DELETE;    // delete case insensitive
(f|F)(r|R)(o|O)(m|M)                  return FROM;      // from case insensitive
(u|U)(p|P)(d|D)(a|A)(t|T)(e|E)        return UPDATE;    // update case insensitive
(s|S)(e|E)(t|T)                       return SET;      // set case insensitive
(w|W)(H|h)(e|E)(r|R)(e|E)             return WHERE;     // where case insensitive  
(A|a)(n|N)(d|D)                       return ANDOR;     // and case insensitive  
(o|O)(r|R)                            return ANDOR;     // or case insensitive
(s|S)(e|E)(l|L)(e|E)(c|C)(t|T)        return SELECT;
(i|I)(n|N)                            return IN;
[-+]?[0-9]+[.]?[0-9]*                 return NUMBER;
[\"](.)+[\"]                          return TEXT;
[\'](.)+[\']                          return TEXT;
"*"                                   return ALL;
"="                                   return ASSIGN;
"<"                                   return CONDITION;
">"                                   return CONDITION;
"<="                                  return CONDITION;
">="                                  return CONDITION;
"<>"                                  return CONDITION;
"("                                   return P_OPEN;
")"                                   return P_CLOSE;
"!="                                  return CONDITION;
[a-zA-Z][a-zA-Z0-9_]*                 return IDENTIFIER;
","                                   return COMMA;
\n                                    return NEWLINE;
";"                                   return SEMICOLON;
[ \t]|" "                                       ;
.                                     return *yytext;
%%


```


<br>

## YACC code : 

```c
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror (char *str);
int yylex();

%}

%token UPDATE DELETE FROM IDENTIFIER SET ASSIGN WHERE ANDOR CONDITION SEMICOLON TEXT NUMBER COMMA NEWLINE ;
%token IN P_OPEN SELECT P_CLOSE ALL;
%%
line:       line_up | 
            line_del |
            error {
                yyerror(" : Invalid Operation. \n               Only DELETE and UPDATE operations are allowed.\n");
                return 1;
            }
            ;
line_up:    update { 
                printf("Syntax Correct\n");
                return 0;
                } 
            ;
line_del:   delete { 
                printf("Syntax Correct\n");
                return 0;
                }
            ;
delete:     DELETE from 
	        ;

from:       FROM table where semicolon NEWLINE| 
            FROM table semicolon NEWLINE | 
            error { 
                    yyerror(" : MISSING KEYWORD \"FROM\".\n");
                    return 1;
                }
	        ;
update:     UPDATE table set 
		    ; 
table:      IDENTIFIER | 
		    error { 
                    yyerror(" : MISSING TABLE NAME.\n");
                    return 1;
                }
		    ; 
set:        SET column where semicolon NEWLINE  | 
		    SET column semicolon NEWLINE |
		    error { 
                    yyerror(" : MISSING KEYWORD \"SET\".\n");
                    return 1;
                }
		    ;
column:     IDENTIFIER ASSIGN TEXT | 
    		IDENTIFIER ASSIGN NUMBER | 
		    IDENTIFIER ASSIGN TEXT COMMA column | 
		    IDENTIFIER ASSIGN NUMBER COMMA column |
	    	error { 
                    yyerror(" : Incorrect statement for SET clause\n");
                    return 1;
                }
		    ;
where:      WHERE IDENTIFIER IN subquery | WHERE condition |
		    error { 
                    yyerror(" : MISSING CLAUSE \"WHERE\".\n");
                    return 1;
                }
		    ;
subquery :  P_OPEN SELECT col FROM IDENTIFIER where P_CLOSE | P_OPEN SELECT col FROM IDENTIFIER P_CLOSE |
			error{
					yyerror(" : Incorrect Subquery\n");
					return 1;
			}
            ;
col :       ALL | IDENTIFIER | NUMBER |
            error{
                    yyerror(" : Incorrect \"SELECT\" statement\n");
                    return 1;
            }
            ; 
condition:  IDENTIFIER operator IDENTIFIER |
			IDENTIFIER operator TEXT |
			IDENTIFIER operator NUMBER |
			IDENTIFIER operator IDENTIFIER ANDOR condition |
			IDENTIFIER operator TEXT ANDOR condition |
			IDENTIFIER operator NUMBER ANDOR condition |
			NUMBER operator NUMBER |
			NUMBER operator NUMBER ANDOR condition |
			error {
				    yyerror(" : Incorrect statement for WHERE clause\n");			
				    return 1;
			    }
			;
operator :  CONDITION | ASSIGN 
            ;
semicolon:  SEMICOLON | 
            error {
                    yyerror(" : Missing Semicolon \";\"\n"); 
                    return 1;
                }
            ;
%%

int main() {
	printf("\nSQL >> ");
	yyparse();              
	return 0;    
}


void yyerror (char *s) {       
  printf("%s",s);
  return;
}

int yywrap() {
	return 1;
}
```

## GOTO graph : 


![[grp.svg]]

## Test Cases : 

![[1.png]]


![[2.png]]



## Limitations : 
<br>

1. It does not handle conditions in parenthesis.
```sql
	DELETE FROM class WHERE (name = "XYZ");
```
```
	Syntax Error : Incorrect statement for WHERE clause
```
2. Semicolon is mandatory at the end of the query.  

<br><br><h1 style = "text-align: center;"> ThankYou </h2>
