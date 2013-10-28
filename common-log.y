%{
#define YYPARSE_PARAM scanner
#define YYLEX_PARAM   scanner

#include <stdio.h>
#include "common-log.tab.h"
#include "common-log.yy.h"

%}

%defines
%pure-parser
%verbose
%lex-param   { yyscan_t scanner }

%union {
	double val;
}

%token INTEGER SPACE IPADDRESS ERRORADDRESS IDENTIFIER BSTRING QSTRING

%%
document : 	logline
						| document logline
						;

logline	:		hostname '-' username BSTRING QSTRING INTEGER INTEGER QSTRING QSTRING
						| hostname '-' username BSTRING QSTRING INTEGER '-' QSTRING QSTRING
						;

hostname:		IPADDRESS
						| IDENTIFIER
						;
			
username:		IDENTIFIER
						| '-'
						;
%%
int
main(int argc, char *argv[])
{
	yydebug = 1;
	yyscan_t scanner;
	yylex_init(&scanner);
	yyparse(scanner);
	yylex_destroy(scanner);
}
