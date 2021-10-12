%option yylineno

%{
#include<bits/stdc++.h>
using namespace std;

extern ofstream logFile;
extern ofstream errorFile;


#include "1705074_Attribute.h"
#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"

#define YYSTYPE SymbolInfo*

#include "y.tab.h"


//extern YYSTYPE yylval;
extern SymbolTable *symbolTable;
//void yyerror(char *);

int line_count=1;
int error_count=0;


%}

LETTER [a-zA-Z]
DIGIT [0-9]
ID (_|{LETTER})({LETTER}|{DIGIT}|_)*
DIGITS {DIGIT}+
NEWLINE \r?\n
WHITESPACE [ \t\r\f\v]
ESCAPE_CHAR [ntafrbv0\'\"\\]
INTEGER {DIGIT}+
NUMBER {DIGIT}*(\.{DIGITS})?([Ee][+-]?{DIGITS})?

%%

{WHITESPACE}+ {}

if 		{ 
			return IF;
		}
else 	{ 
			return ELSE;
		}
for 	{ 
			return FOR;
		}
while 	{ 
			return WHILE;
		}
do 		{ 
			return DO;
		}
int 	{ 
			return INT;
		}
char 	{ 
			return CHAR;
		}
float 	{
			return FLOAT;
		}
double 	{ 
			return DOUBLE;
		}
void 	{ 
			return VOID;
		}
return 	{ 
			return RETURN;
		}
default { 
			return DEFAULT;
		}
continue { 
			return CONTINUE;
		}		
printf {
			return PRINTLN;
		}		



[+-] {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "ADDOP");
		yylval = (YYSTYPE)symbolInfo;
		return ADDOP;	
	 }
[*/%] {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "MULOP");
		yylval = (YYSTYPE)symbolInfo;
		return MULOP;
	 }
"<"  |
"<=" |
">"  |
">=" |
"==" |
"!=" {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "RELOP");
		yylval = (YYSTYPE)symbolInfo;
		return RELOP;	
	 }	 
= {
		return ASSIGNOP;	
	 }
"&&" |
"||" {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "LOGICOP");
		yylval = (YYSTYPE)symbolInfo;
		return LOGICOP;	
	 }
"++" {
		return INCOP;
	 }
"--" {
		return DECOP;	
	 }	 	 	 
! {
		return NOT;	
	 }
\( 	 {
		return LPAREN;	
	 }
\)   {
		return RPAREN;
	 }
\{   {	
		return LCURL;
	 }
\}   {
		return RCURL;
	 }
\[   {
		return LTHIRD;	
	 }
\] 	 {
		return RTHIRD;	
	 }
, 	 {
		return COMMA;
	 }	 	 	 	 	 	 	 	 
;    {
		return SEMICOLON;	
	 }	 	 	 	 	 



{INTEGER} {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_INT", "int");
		yylval = (YYSTYPE)symbolInfo;
		return CONST_INT;  
	}
{NUMBER} {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_FLOAT", "float");
		yylval = (YYSTYPE)symbolInfo;
		return CONST_FLOAT; 
	}
\'[^\\]\' {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_CHAR");
		yylval = (YYSTYPE)symbolInfo;
		return CONST_CHAR; 	
	}	
\'\\{ESCAPE_CHAR}\' {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_CHAR");
		yylval = (YYSTYPE)symbolInfo;
		return CONST_CHAR;
 	}
 	 	

{ID} {
		SymbolInfo *symbolInfo= new  SymbolInfo(yytext, "ID");
		yylval = (YYSTYPE)symbolInfo;
		return ID;		 
	}
	

{DIGIT}*(\.)?{DIGITS}?([Ee][+-]?({DIGITS}?\.{DIGITS}?)?)? {
		logFile << "Error at line no "<<line_count<<": "<<"Ill formed number "<<yytext<<endl<<endl;
		errorFile << "Error at line no "<<line_count<<": "<<"Ill formed number "<<yytext<<endl<<endl;
		error_count++;
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "NUMBER_ERR", "float");
		yylval = (YYSTYPE)symbolInfo;
		return NUMBER_ERR; 
	}
[0-9\.Ee]* { 
		logFile << "Error at line no "<<line_count<<": "<<"Too many decimal points "<<yytext<<endl<<endl;
		errorFile << "Error at line no "<<line_count<<": "<<"Too many decimal points "<<yytext<<endl<<endl;
		error_count++;
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "NUMBER_ERR", "float");
		yylval = (YYSTYPE)symbolInfo;
		return NUMBER_ERR; 
	}	
{DIGIT}({LETTER}|{DIGIT}|_)* {
		logFile << "Error at line no "<<line_count<<": "<<"Invalid prefix on ID or invalid suffix on Number " 					<<yytext<<endl<<endl;
		errorFile << "Error at line no "<<line_count<<": "<<"Invalid prefix on ID or invalid suffix on Number " 					<<yytext<<endl<<endl;
		error_count++; 
	}	
	
{NEWLINE} {line_count++;}	
<<EOF>> {
			return 0;
		} 	
. {
		logFile << "Error at line "<<line_count<<": "<<"Unrecognized character "<<yytext<<endl<<endl;
		errorFile << "Error at line "<<line_count<<": "<<"Unrecognized character "<<yytext<<endl<<endl;
		error_count++;			
	}
 	
%%


int yywrap(void)
{
	return 1;
}




















