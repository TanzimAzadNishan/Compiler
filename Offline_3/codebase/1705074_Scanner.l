%option yylineno

/*%x STRING
%x SINGLE_LINE_COMMENT
%x MULTI_LINE_COMMENT*/

%{
#include<bits/stdc++.h>
using namespace std;

//ofstream tokenFile;
//ofstream logFile;

#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"

//#define YYSTYPE SymbolInfo*

#include "y.tab.h"


extern YYSTYPE yylval;
extern SymbolTable *symbolTable;
//void yyerror(char *);

int line_count=1;
int error_count=0;


/*string stringLexeme = "";
string charSeq = "";
int lineNoOfStringOrComment = 0;*/

/*SymbolTable* symbolTable = new SymbolTable();

char getActualCharacter(char escapeTracker){
	char ch = ' ';

	if(escapeTracker == 'n'){
		ch = (char) 10;
	}
	else if(escapeTracker == 't'){
		ch = (char) 9;
	}
	else if(escapeTracker == 'a'){
		ch = (char) 7;
	}
	else if(escapeTracker == 'f'){
		ch = (char) 12;
	}
	else if(escapeTracker == 'r'){
		ch = (char) 13;
	}
	else if(escapeTracker == 'b'){
		ch = (char) 8;
	}
	else if(escapeTracker == 'v'){
		ch = (char) 11;
	}
	else if(escapeTracker == '0'){
		ch = (char) 10;
	}
	else if(escapeTracker == '\\'){
		ch = (char) 92;
	}
	else if(escapeTracker == '\''){
		ch = (char) 39;
	}
	else if(escapeTracker == '\"'){
		ch = (char) 34;
	}	
	
	return ch;	
}*/


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
			SymbolInfo *symbolInfo = new SymbolInfo(yytext, "INT");
			yylval.symInfo = symbolInfo; 
			return INT;
		}
char 	{ 
			return CHAR;
		}
float 	{
			SymbolInfo *symbolInfo = new SymbolInfo(yytext, "FLOAT");
			yylval.symInfo = symbolInfo;  
			return FLOAT;
		}
double 	{ 
			return DOUBLE;
		}
void 	{
			SymbolInfo *symbolInfo = new SymbolInfo(yytext, "VOID");
			yylval.symInfo = symbolInfo;  
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
main 	{
			return MAIN;
	 	}		
println {
			return PRINTLN;
		}		



[+-] {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "ADDOP");
		yylval.symInfo = symbolInfo;
		return ADDOP;	
	 }
[*/%] {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "MULOP");
		yylval.symInfo = symbolInfo;
		return MULOP;
	 }
"<"  |
"<=" |
">"  |
">=" |
"==" |
"!=" {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "RELOP");
		yylval.symInfo = symbolInfo;
		return RELOP;	
	 }	 
= {
		return ASSIGNOP;	
	 }
"&&" |
"||" {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "LOGICOP");
		yylval.symInfo = symbolInfo;
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
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "LPAREN");
		yylval.symInfo = symbolInfo;
		return LPAREN;	
	 }
\)   {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "RPAREN");
		yylval.symInfo = symbolInfo;
		return RPAREN;
	 }
\{ {
		//symbolTable->enterScope(7);	
		return LCURL;
	 }
\} {
		//symbolTable->exitScope();
		return RCURL;
	 }
\[   {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "LTHIRD");
		yylval.symInfo = symbolInfo;
		return LTHIRD;	
	 }
\] 	 {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "RTHIRD");
		yylval.symInfo = symbolInfo;
		return RTHIRD;	
	 }
, 	 {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "COMMA");
		yylval.symInfo = symbolInfo;
		return COMMA;
	 }	 	 	 	 	 	 	 	 
;    {
		SymbolInfo *symbolInfo = new SymbolInfo(yytext, "SEMICOLON");
		yylval.symInfo = symbolInfo;
		return SEMICOLON;	
	 }	 	 	 	 	 




{INTEGER} {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_INT");
		yylval.symInfo = symbolInfo;
		return CONST_INT;
		
		/*bool isInserted = symbolTable->Insert(yytext, "CONST_INT");
		tokenFile << "<CONST_INT, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_INT> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}*/  
	}
{NUMBER} {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_FLOAT");
		yylval.symInfo = symbolInfo;
		return CONST_FLOAT; 
		
		/*bool isInserted = symbolTable->Insert(yytext, "CONST_FLOAT"); 
		tokenFile << "<CONST_FLOAT, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}*/  
	}
\'[^\\]\' {
		SymbolInfo *symbolInfo= new SymbolInfo(yytext, "CONST_CHAR");
		yylval.symInfo = symbolInfo;
		return CONST_CHAR;

		/*string charLexeme;
		charLexeme = yytext[1];
		
 		bool isInserted = symbolTable->Insert(yytext, "CONST_CHAR"); 
		tokenFile << "<CONST_CHAR, " << charLexeme << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_CHAR> Lexeme "<<yytext<<" found" << " --> "
				<< "<CONST_CHAR, " << charLexeme << ">" <<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}*/  	
	}	
\'\\{ESCAPE_CHAR}\' {				
		/*string charLexeme;
		charLexeme = getActualCharacter(yytext[2]);
		
 		bool isInserted = symbolTable->Insert(yytext, "CONST_CHAR"); 
		tokenFile << "<CONST_CHAR, " << charLexeme << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_CHAR> Lexeme "<<yytext<<" found" << " --> "
				<< "<CONST_CHAR, " << charLexeme << ">" <<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}*/  
 	}
 	 	

{ID} {
		SymbolInfo *symbolInfo= new  SymbolInfo(yytext, "ID");
		yylval.symInfo = symbolInfo;
		return ID;

		/*bool isInserted = symbolTable->Insert(yytext, "ID");
		tokenFile << "<ID, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}*/ 		 
	}
	
{NEWLINE} {line_count++;}	

 	
%%


int yywrap(void)
{
	return 1;
}


/*int main(int argc,char *argv[]){

    if(argc!=2){
		cout << "Please provide input file name and try again" << endl;
		return 0;
    } 

    FILE *fin=fopen(argv[1],"r");
    
    if(fin==NULL){
		cout << "Cannot open specified file" << endl;
		return 0;
    }
    
    tokenFile.open("1705074_token.txt", ios::out);
    logFile.open("1705074_log.txt", ios::out);
    logFile << "\n";
    
    symbolTable->enterScope(7);
    
    yyin= fin;
    yylineno = 1;
    yylex();
    fclose(yyin);
    
    tokenFile.close();
    logFile.close();
    
    return 0;
}*/


/*


{DIGIT}*(\.)?{DIGITS}?([Ee][+-]?({DIGITS}?\.{DIGITS}?)?)? {
		logFile << "Error at line no "<<line_count<<": "<<"Ill formed number "<<yytext<<endl<<endl;
		error_count++; 
	}
[0-9\.Ee]* { 
		logFile << "Error at line no "<<line_count<<": "<<"Too many decimal points "<<yytext<<endl<<endl;
		error_count++; 
	}	
{DIGIT}({LETTER}|{DIGIT}|_)* {
		logFile << "Error at line no "<<line_count<<": "<<"Invalid prefix on ID or invalid suffix on Number " 					<<yytext<<endl<<endl;
		error_count++; 
	}	
\'\\{ESCAPE_CHAR} {
		logFile << "Error at line no "<<line_count<<": "<<"Unterminated character "<<yytext<<endl<<endl;
		error_count++; 
	}
\'[^\'\r\n]* {
		logFile << "Error at line no "<<line_count<<": "<<"Unterminated character "<<yytext<<endl<<endl;
		error_count++; 
	}
\'[^\'\r\n][^\'\r\n]+\' {
		logFile << "Error at line no "<<line_count<<": "<<"Multi character constant error "<<yytext<<endl<<endl;
		error_count++; 
	}			
\'\' {
	logFile << "Error at line no "<<line_count<<": "<<"Empty character constant error "<<yytext<<endl<<endl;
	error_count++;
}

*/



/*

"/*" {
		lineNoOfStringOrComment = line_count;
		charSeq = "/*";	
		BEGIN MULTI_LINE_COMMENT;
	 }

<MULTI_LINE_COMMENT>{NEWLINE} {
		charSeq += yytext;
		line_count++;
	}	
<MULTI_LINE_COMMENT>\r {
		charSeq += yytext;
	}*/	
//<MULTI_LINE_COMMENT>[^\r\n*/]+ {
		//charSeq += yytext;
	//}
		
//<MULTI_LINE_COMMENT>"*/" {
		/*charSeq += yytext;
		logFile <<"Line no "<<lineNoOfStringOrComment<<": Token <COMMENT> Lexeme "<<charSeq<<" found"<<endl<<endl; 
		BEGIN INITIAL;
	}*/
//<MULTI_LINE_COMMENT>[*/] {
		/*charSeq += yytext;
	}
<MULTI_LINE_COMMENT><<EOF>> {
		logFile << "Error at line no "<<lineNoOfStringOrComment<<": "<<"Unterminated Comment "<<charSeq<<endl<<endl;
		error_count++;
		
		symbolTable->printAllScopeTable();
		
		logFile<<"Total Lines: "<<line_count<<endl;
		logFile << "Total errors: "<<error_count<<endl; 
		return 0;
	}

*/


/*



"//" {
		lineNoOfStringOrComment = line_count;
		charSeq = "//";	
		BEGIN SINGLE_LINE_COMMENT;	
	 }
		
	 	
<SINGLE_LINE_COMMENT>\\{NEWLINE} {
		charSeq += yytext;
		line_count++;
	}
<SINGLE_LINE_COMMENT>{NEWLINE} {
		line_count++;
		logFile <<"Line no "<<lineNoOfStringOrComment<<": Token <COMMENT> Lexeme "<<charSeq<<" found"<<endl<<endl; 
		BEGIN INITIAL;
	}	
<SINGLE_LINE_COMMENT>\r {
		charSeq += yytext;
	}	
<SINGLE_LINE_COMMENT>[^\r\n\\]+ {
		charSeq += yytext;
	}
<SINGLE_LINE_COMMENT>\\ {
		charSeq += yytext;
	}
<SINGLE_LINE_COMMENT><<EOF>> {
		logFile << "Error at line no "<<lineNoOfStringOrComment<<": "<<"Unterminated Comment "<<charSeq<<endl<<endl;
		error_count++;
		
		symbolTable->printAllScopeTable();
		
		logFile<<"Total Lines: "<<line_count<<endl;
		logFile << "Total errors: "<<error_count<<endl; 
		return 0;
	}	

*/

/*


\" 	{
		lineNoOfStringOrComment = line_count;
		stringLexeme = "\"";
		charSeq = "\"";
		BEGIN STRING;
	}


<STRING>\\{NEWLINE} {
		charSeq += yytext;
		line_count++;
	}	
<STRING>{NEWLINE} {
		logFile << "Error at line no "<<lineNoOfStringOrComment<<": "<<"Unterminated String "<<charSeq<<endl<<endl;
		line_count++;
		error_count++; 
		BEGIN INITIAL;
	}	
<STRING>\\ {
		charSeq += yytext;
		stringLexeme += yytext;	
	}	 
<STRING>\" {
		stringLexeme += "\"";
		charSeq += "\"";
		tokenFile << "<STRING, " << stringLexeme << "> ";
		logFile <<"Line no "<<lineNoOfStringOrComment<<": Token <STRING> Lexeme "<<charSeq<<" found"
				<<" --> "<< "<STRING, "<< stringLexeme << ">"<<endl<<endl; 
		BEGIN INITIAL;
	}	
<STRING>[^\\\"\r\n]+ {
		stringLexeme += yytext;
		charSeq += yytext;
	}
<STRING><<EOF>> {
		logFile << "Error at line no "<<lineNoOfStringOrComment<<": "<<"Unterminated String "<<charSeq<<endl<<endl;
		error_count++;
		
		symbolTable->printAllScopeTable();
		
		logFile<<"Total Lines: "<<line_count<<endl;
		logFile << "Total errors: "<<error_count<<endl; 
		return 0;
	}		
<STRING>\\{ESCAPE_CHAR} {
		string charLexeme;
		charLexeme = getActualCharacter(yytext[1]);
		
		stringLexeme += charLexeme;
		charSeq += yytext;		
	} 

*/


/*


<<EOF>> {
			symbolTable->printAllScopeTable();

			logFile<<"Total Lines: "<<line_count<<endl;
			logFile << "Total errors: "<<error_count<<endl; 
			return 0;
		} 	
. {
		logFile << "Error at line no "<<line_count<<": "<<"Unrecognized character "<<yytext<<endl<<endl;
		error_count++;			
	}

*/

































