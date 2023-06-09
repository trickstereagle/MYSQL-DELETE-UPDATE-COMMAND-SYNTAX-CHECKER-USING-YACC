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
