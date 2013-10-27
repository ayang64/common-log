
%{

#define YYPARSE_PARAM scanner
#define YYLEX_PARAM   scanner

#include <stdio.h>



%}

%locations
%defines
%pure-parser
%verbose

%union {
	double val;
}

%token FOO INTEGER

%%

document : 	INTEGER
						| document INTEGER
						;


integer	: INTEGER
					{ printf("INTEGER!\n"); }
%%
