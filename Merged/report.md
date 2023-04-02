# Compiler Design Project

## MYSQL : DELETE and UPDATE
### By Abhishek Gupta (Roll No. 01) & Divyansh Gupta (Roll No. 19)

## Aim
The aim of this project is to design a compiler for MySQL language to execute DELETE and UPDATE operations. The compiler will analyze the syntax and generate an executable file. The lexical analyzer will scan the input code and generate tokens that will be used by the parser to create a parse tree. 

## Lex Code:
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
[0-9]+                                return NUMBER;
[\"](.)+[\"]                          return TEXT;
['](.)+[']                            return TEXT;
"="                                   return ASSIGN;
"<"                                   return CONDITION;
">"                                   return CONDITION;
"<="                                  return CONDITION;
">="                                  return CONDITION;
"<>"                                  return CONDITION;
"!="                                  return CONDITION;
[a-zA-Z][a-zA-Z0-9_]*                 return IDENTIFIER;
","                                   return COMMA;
\n                                    return NEWLINE;
";"                                   return SEMICOLON;
[ \t]|" "                                       ;
.                                     return *yytext;
%%
```
## YACC code
```c
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror (char *str);
int yylex();

%}

%token UPDATE DELETE FROM IDENTIFIER SET ASSIGN WHERE ANDOR CONDITION SEMICOLON TEXT NUMBER COMMA NEWLINE ;
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

from:       FROM table where | 
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
set:        SET column where | 
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
where:      WHERE condition semicolon NEWLINE |
		    error { 
                    yyerror(" : MISSING CLAUSE \"WHERE\".\n");
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
## GOTO graph

<img src = grp.svg style="border: 2px solid black;" title="GOTO Graph">

## Test Cases
