%{
#include <stdio.h>
#include <stdlib.h>

#include "common-log.tab.h"
#include "buf.h"

#define TOKEN(n)		({ /* fprintf(stderr, "flex: %s (%s)\n", #n, yytext); */ return n;}) 

struct buf *string = NULL;
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

<BRACKET_STRING>{
]							{
								BEGIN(INITIAL);
								yylval->string = strdup(string->data);
								TOKEN(BSTRING);
							}	

[^\]]*				{ buf_strcat(&string,yytext, yyleng); }

}

<QUOTED_STRING>{
\"						{
								BEGIN(INITIAL);
								yylval->string = strdup(string->data);
								TOKEN(QSTRING);
							}	

[^\"]*				{ buf_strcat(&string,yytext, yyleng); }
}

\"						{
								buf_reset(string);
								BEGIN(QUOTED_STRING);
							}

[\[]					{
								buf_reset(string);
								BEGIN(BRACKET_STRING);
							}

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


[0-9]+				{	TOKEN(INTEGER); }

[a-z0-9][^\"\[[:space:]]+		{	TOKEN(IDENTIFIER); }

[[:space:]]+	;	

.							{ return yytext[0]; }

\n						;

%%

