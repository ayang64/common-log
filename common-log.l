%{
#include <stdio.h>
#include <stdlib.h>

#include "common-log.tab.h"

#define TOKEN(n)		({ /* fprintf(stderr, "flex: %s (%s)\n", #n, yytext); */ return n;}) 
%}

%option 8bit
%option stack
%option yylineno
%option noyywrap
%option bison-bridge
%option bison-locations
%option reentrant

%option outfile="common-log.yy.c" header="common-log.yy.h"

%x QUOTED_STRING BRACKET_STRING
%%
\[[^]]+]				{	yylval->string = strndup(yytext + 1, yyleng - 2); TOKEN(BSTRING); }
\"(\\.|[^"])*\"	{ yylval->string = strndup(yytext + 1, yyleng - 2); TOKEN(QSTRING); }
[0-9]+					{ yylval->string = strdup(yytext); TOKEN(INTEGER); }
[[:alnum:]][[:alnum:][:punct:]]+	{ yylval->string = strdup(yytext);	TOKEN(IDENTIFIER); }
-								{ yylval->string = strdup(yytext);	TOKEN(IDENTIFIER); }
[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}	{
								unsigned octet[4];
								sscanf(yytext, "%d.%d.%d.%d",
									&octet[0], &octet[1], &octet[2], &octet[3]);

								size_t i = 0;
								for (; i < 4; i++)
									if (octet[i] > 0x100)
										break;

								if (i == 4)
									TOKEN(IPADDRESS);
								else
									TOKEN(ERRORADDRESS);
							}
[[:space:]]+	/* ignore spaces. */ ;	
.							{ return yytext[0]; }
\n						;
%%

