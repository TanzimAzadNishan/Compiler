%option noyywrap yylineno

%x STRING
%x SINGLE_LINE_COMMENT
%x MULTI_LINE_COMMENT

%{
#include<bits/stdc++.h>
using namespace std;

ofstream tokenFile;
ofstream logFile;

#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"


int line_count=1;
int error_count=0;
string stringLexeme = "";
string charSeq = "";
int lineNoOfStringOrComment = 0;

SymbolTable* symbolTable = new SymbolTable();

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
}


%}

LETTER [a-zA-Z]
DIGIT [0-9]
ID_FIRST_CHAR [a-zA-Z_]
DIGITS {DIGIT}+
NEWLINE \r?\n
WHITESPACE [ \t\v]
ESCAPE_CHAR [ntafrbv0\'\"\\]

%%

{WHITESPACE} {}

if 		{ 
			tokenFile << "<IF> "; 
			logFile <<"Line no "<<line_count<<": Token <IF> Lexeme "<<yytext<<" found\n\n";
		}
else 	{ 
			tokenFile << "<ELSE> "; 
			logFile <<"Line no "<<line_count<<": Token <ELSE> Lexeme "<<yytext<<" found\n\n";
		}
for 	{ 
			tokenFile << "<FOR> "; 
			logFile <<"Line no "<<line_count<<": Token <FOR> Lexeme "<<yytext<<" found\n\n";
		}
while 	{ 
			tokenFile << "<WHILE> "; 
			logFile <<"Line no "<<line_count<<": Token <WHILE> Lexeme "<<yytext<<" found\n\n";
		}
do 		{ 
			tokenFile << "<DO> "; 
			logFile <<"Line no "<<line_count<<": Token <DO> Lexeme "<<yytext<<" found\n\n";
		}
break 	{ 
			tokenFile << "<BREAK> "; 
			logFile <<"Line no "<<line_count<<": Token <BREAK> Lexeme "<<yytext<<" found\n\n";
		}
int 	{ 
			tokenFile << "<INT> "; 
			logFile <<"Line no "<<line_count<<": Token <INT> Lexeme "<<yytext<<" found\n\n";
		}
char 	{ 
			tokenFile << "<CHAR> "; 
			logFile <<"Line no "<<line_count<<": Token <CHAR> Lexeme "<<yytext<<" found\n\n";
		}
float 	{ 
			tokenFile << "<FLOAT> "; 
			logFile <<"Line no "<<line_count<<": Token <FLOAT> Lexeme "<<yytext<<" found\n\n";
		}
double 	{ 
			tokenFile << "<DOUBLE> "; 
			logFile <<"Line no "<<line_count<<": Token <DOUBLE> Lexeme "<<yytext<<" found\n\n";
		}
void 	{ 
			tokenFile << "<VOID> "; 
			logFile <<"Line no "<<line_count<<": Token <VOID> Lexeme "<<yytext<<" found\n\n";
		}
return 	{ 
			tokenFile << "<RETURN> "; 
			logFile <<"Line no "<<line_count<<": Token <RETURN> Lexeme "<<yytext<<" found\n\n";
		}
switch 	{ 
			tokenFile << "<SWITCH> "; 
			logFile <<"Line no "<<line_count<<": Token <SWITCH> Lexeme "<<yytext<<" found\n\n";
		}
case 	{ 
			tokenFile << "<CASE> "; 
			logFile <<"Line no "<<line_count<<": Token <CASE> Lexeme "<<yytext<<" found\n\n";
		}
default { 
			tokenFile << "<DEFAULT> "; 
			logFile <<"Line no "<<line_count<<": Token <DEFAULT> Lexeme "<<yytext<<" found\n\n";
		}
continue { 
			tokenFile << "<CONTINUE> "; 
			logFile <<"Line no "<<line_count<<": Token <CONTINUE> Lexeme "<<yytext<<" found\n\n";
		}



[+-] {
		tokenFile << "<ADDOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
[*/%] {
		tokenFile << "<MULOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
"++"|"--" {
		tokenFile << "<INCOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
"<"|"<="|">"|">="|"=="|"!=" {
		tokenFile << "<RELOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }	 
= {
		tokenFile << "<ASSIGNOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
"&&"|"||" {
		tokenFile << "<LOGICOP, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <LOGICOP> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }	 	 
! {
		tokenFile << "<NOT, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <NOT> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
\( {
		tokenFile << "<LPAREN, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <LPAREN> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
\) {
		tokenFile << "<RPAREN, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <RPAREN> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
\{ {
		symbolTable->enterScope(7);	
		tokenFile << "<LCURL, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <LCURL> Lexeme "<<yytext<<" found"<<endl<<endl;
	 }
\} {
		symbolTable->exitScope();
		tokenFile << "<RCURL, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <RCURL> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
\[ {
		tokenFile << "<LTHIRD, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <LTHIRD> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
\] {
		tokenFile << "<RTHIRD, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <RTHIRD> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }
, {
		tokenFile << "<COMMA, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <COMMA> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }	 	 	 	 	 	 	 	 
; {
		tokenFile << "<SEMICOLON, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <SEMICOLON> Lexeme "<<yytext<<" found"<<endl<<endl;	
	 }	 	 	 	 	 




{DIGIT}+ {
		bool isInserted = symbolTable->Insert(yytext, "CONST_INT");
		tokenFile << "<CONST_INT, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_INT> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}  
	}
{DIGIT}*(\.{DIGITS})?([Ee][+-]?{DIGITS})? { 
		bool isInserted = symbolTable->Insert(yytext, "CONST_FLOAT"); 
		tokenFile << "<CONST_FLOAT, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		}  
	}
\'[^\\]\' {
		string charLexeme;
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
		}  	
	}	
\'\\{ESCAPE_CHAR}\' {				
		string charLexeme;
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
		}  
 	}
 	 	

{ID_FIRST_CHAR}({LETTER}|{DIGIT}|_)* {
		bool isInserted = symbolTable->Insert(yytext, "ID");
		tokenFile << "<ID, " << yytext << "> ";
		logFile <<"Line no "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found"<<endl<<endl;
		if(isInserted){
			symbolTable->printAllScopeTable();
		}
		else{
			logFile<<yytext<<" already exists in current ScopeTable"<<endl<<endl;
		} 		 
	}
	
	
	
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
	}	
<MULTI_LINE_COMMENT>[^\r\n*/]+ {
		charSeq += yytext;
	}	
<MULTI_LINE_COMMENT>"*/" {
		charSeq += yytext;
		logFile <<"Line no "<<lineNoOfStringOrComment<<": Token <COMMENT> Lexeme "<<charSeq<<" found"<<endl<<endl; 
		BEGIN INITIAL;
	}
<MULTI_LINE_COMMENT>[*/] {
		charSeq += yytext;
	}
<MULTI_LINE_COMMENT><<EOF>> {
		logFile << "Error at line no "<<lineNoOfStringOrComment<<": "<<"Unterminated Comment "<<charSeq<<endl<<endl;
		error_count++;
		
		symbolTable->printAllScopeTable();
		
		logFile<<"Total Lines: "<<line_count<<endl;
		logFile << "Total errors: "<<error_count<<endl; 
		return 0;
	}		 	 					
	
	

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
		 	 	
{NEWLINE} {line_count++;}
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
 	
%%


int main(int argc,char *argv[]){

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
}












