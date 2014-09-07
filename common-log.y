%{
#include <stdio.h>
#include "common-log.tab.h"
#include "common-log.yy.h"

%}

%defines
%locations
%pure-parser
%lex-param   { void * scanner }
%parse-param { void * scanner }
%parse-param { const char *pattern }
%parse-param { size_t nfields }
%parse-param { int fields[nfields] }
%verbose

%destructor { free($<string>$); } QSTRING BSTRING INTEGER IPADDRESS IDENTIFIER

%union {
	double val;
	char *string, *address;
}

%token INTEGER SPACE IPADDRESS ERRORADDRESS IDENTIFIER BSTRING QSTRING

%%
document : 	logline
						| document logline
						;

logline	:		hostname identity username BSTRING QSTRING INTEGER size QSTRING QSTRING
						{
							const char	*f[] = { $<string>1, $<string>2, $<string>3, $<string>4, $<string>5, $<string>6, $<string>7, $<string>8, $<string>9 };
							for (size_t i = 0; i < nfields; i++)
								printf("%s ", f[fields[i]]);

							printf("\n");
						}
						| error
						{
							/*
								We're here because either our input fd closed or there is a
								syntax error in the log file. Either way, it is a fatal error.
								Lets exit().
							 */
							exit(0);
						}
						;

size:				INTEGER
						| IDENTIFIER
						;

hostname:		IPADDRESS
						| IDENTIFIER
						;

identity:		IDENTIFIER
						;

username:		IDENTIFIER
						| QSTRING
						| INTEGER
						;
%%
int
main(int argc, char *argv[])
{
	int arg, fields[64];
	char *pattern = strdup("time hostname referrer");

	while ((arg = getopt(argc, argv, "f:")) != -1) {
		switch (arg) {
			case 'f':
				pattern = optarg;
				break;
		}
	}

	size_t n = 0;
	char *token;
	while ((token = strsep(&pattern, " ")) != NULL) {
		if (strcmp(token,"hostname") == 0) {
			fields[n] = 0;
		} else if (strcmp(token,"identity") == 0) {
			fields[n] = 1;
		} else if (strcmp(token,"username") == 0) {
			fields[n] = 2;
		} else if (strcmp(token,"time") == 0) {
			fields[n] = 3;
		} else if (strcmp(token,"request") == 0) {
			fields[n] = 4;
		} else if (strcmp(token,"result") == 0) {
			fields[n] = 5;
		} else if (strcmp(token,"size") == 0) {
			fields[n] = 6;
		} else if (strcmp(token,"referrer") == 0) {
			fields[n] = 7;
		} else if (strcmp(token,"client") == 0) {
			fields[n] = 8;
		}
		n++;
	}

	/*	yydebug = 1; */
	yyscan_t scanner;
	yylex_init(&scanner);
	yyparse(scanner, pattern, n, fields);
	yylex_destroy(scanner);
}
