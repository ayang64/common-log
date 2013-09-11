%{

#include <stdio.h>
#include <stdlib.h>
#include "buf.h"

#define TOKEN(n)		({	fprintf(stderr, "%s (%s)\n", #n, yytext); })

struct buf *string;
%}

%option 8bit
%option stack
%option yylineno
%option yywrap
%option reentrant

%option outfile="common-log.yy.c" header="common-log.yy.h"

%x QSTRING BSTRING

%%

<BSTRING>{
]							{
								BEGIN(INITIAL);
								fprintf(stderr,"<<< %s >>>\n", string->data);
								TOKEN(BSTRING);
							}	

[^\]]*				{ buf_strcat(string,yytext, yyleng); }

}

<QSTRING>{
\"						{
								BEGIN(INITIAL);
								fprintf(stderr,"''' %s '''\n", string->data);
								TOKEN(QSTRING);
							}	

[^\"]*						{ buf_strcat(string,yytext, yyleng); }
}

\"						{
								buf_reset(string);
								BEGIN(QSTRING);
							}

[\[]						{
								buf_reset(string);
								BEGIN(BSTRING);
							}

[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}	{
								unsigned octet[4];
								sscanf(yytext, "%d.%d.%d.%d", &octet[0], &octet[1], &octet[2], &octet[3]);

								size_t i = 0;
								for (; i < 4; i++)
									if (octet[i] > 0x100)
										break;

								if (i == 4)
									TOKEN(IPADDRESS);
								else
									TOKEN(ERRORADDRESS);
							}

[^\"\[[:space:]]+		{	TOKEN(IDENTIFIER); }

[[:space:]]+	{
								TOKEN(SPACE);
							}
.							;
\n						;

%%

int
main(int argc, char *argv[])
{
	string = buf_new();

	yyscan_t	scanner;

	yylex_init(&scanner);
	yylex(scanner);
	yylex_destroy(scanner);

	exit(0);
}

