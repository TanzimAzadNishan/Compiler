%{
#include<bits/stdc++.h>
using namespace std;

ofstream logFile;

#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"

//#define YYSTYPE SymbolInfo*


int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;

SymbolTable *symbolTable = new SymbolTable();
bool spaceNeededAtBeg = false;


void yyerror(char *s)
{
	//write your code
}

void printNonTerminal(vector<SymbolInfo*>* nonTerminal){
	vector<SymbolInfo*>::iterator itr;
	
	for(itr = nonTerminal->begin(); itr != nonTerminal->end(); itr++){
		logFile<<(*itr)->getName();
		
		if(spaceNeededAtBeg == true && itr == nonTerminal->begin()){
			logFile<<" ";
			spaceNeededAtBeg = false;
		}			
	}	
}

void pushIntoVector(vector<SymbolInfo*>* parent, vector<SymbolInfo*>* child){
	vector<SymbolInfo*>::iterator itr;
	
	for(itr = child->begin(); itr != child->end(); itr++){
		parent->push_back(*itr);			
	}	
}


%}

%union{
	SymbolInfo* symInfo;
	int ival;
	double dval;
	vector<SymbolInfo*>* symbols;			
}

%token		IF ELSE FOR WHILE DO CHAR DOUBLE RETURN DEFAULT CONTINUE MAIN PRINTLN
%token <symInfo> INT FLOAT VOID LTHIRD RTHIRD LPAREN RPAREN
%token <symInfo> 	ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP
%token 		LCURL RCURL
%token		NOT
%token <symInfo> COMMA SEMICOLON
%token <symInfo> 	ID CONST_INT CONST_FLOAT CONST_CHAR
%type <symInfo> type_specifier
%type <symbols> declaration_list var_declaration func_declaration unit program parameter_list

//%left 
//%right

//%nonassoc 


%%

start : program
	{
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit
	{
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"program : program unit"<<endl<<endl;
		
		spaceNeededAtBeg = true;
		printNonTerminal($1);
		logFile<<endl;
		
		spaceNeededAtBeg = true;
		printNonTerminal($2);
		
		pushIntoVector($$, $2);
		
		logFile<<endl<<endl<<endl;
	} 
	| unit
	{
		//$$ = $1;
		$$ = new vector<SymbolInfo*>();
 		pushIntoVector($$, $1);
 		
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"program : unit"<<endl<<endl;
		
		spaceNeededAtBeg = true;
		printNonTerminal($1);
		logFile<<endl<<endl<<endl;		
	}
	;
	
unit : var_declaration
	 {
 		$$ = $1;
 		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"unit : var_declaration"<<endl<<endl;
		
		spaceNeededAtBeg = true;
		printNonTerminal($1);
		logFile<<endl<<endl;				 	
	 } 	
     | func_declaration
     {
     	$$ = $1;
 		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"unit : func_declaration"<<endl<<endl;
		
		spaceNeededAtBeg = true;
		printNonTerminal($1);
		logFile<<endl<<endl;     	
     }
     | func_definition
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
		 	$$ = new vector<SymbolInfo*>();
 		  	$$->push_back($1);
 		  	$$->push_back($2);
 		  	$$->push_back($3);
 		  	$$->push_back($4);
 		  	$$->push_back($5);
 		  	
			logFile<<"At line no: "<< line_count <<" : "
				   <<"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON"<<endl<<endl;
				   
			logFile<<$1->getName()<<" "<<$2->getName()<<"();"<<endl<<endl;
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
		| type_specifier ID LPAREN RPAREN compound_statement
 		;				


parameter_list  : parameter_list COMMA type_specifier ID
		| parameter_list COMMA type_specifier
 		| type_specifier ID
 		{
 			
 		}
		| type_specifier
		{
		 	$$ = new vector<SymbolInfo*>();
 		  	$$->push_back($1);
			logFile<<"At line no: "<< line_count <<" : "<<"parameter_list : type_specifier"<<endl<<endl;
			logFile<<$1->getName()<<endl<<endl;
		}
 		;

 		
compound_statement : LCURL statements RCURL
 		    | LCURL RCURL
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {

 		  	$$ = new vector<SymbolInfo*>();
 		  	$$->push_back($1);
 		  	
			logFile<<"At line no: "<< line_count <<" : "
					<<"var_declaration : type_specifier declaration_list SEMICOLON"<<endl<<endl;
			
			logFile<<$1->getName()<<" ";
					
			/*vector<SymbolInfo*>::iterator itr;
			for(itr = $2->begin(); itr != $2->end(); itr++){
				$$->push_back(*itr);
			}*/
			
			pushIntoVector($$, $2);
			
			printNonTerminal($2);
			
			$$->push_back($3);
			logFile<<";"<<endl<<endl;					
		 }
 		 ;
 		 
type_specifier : INT 
		{
			$$ = $1;
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : INT"<<endl<<endl;
			logFile<<$1->getName()<<endl<<endl;
		} 
 		| FLOAT
 		{
			$$ = $1;
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : FLOAT"<<endl<<endl;
			logFile<<$1->getName()<<endl<<endl; 		
 		}
 		| VOID
 		{
			$$ = $1;
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : VOID"<<endl<<endl;
			logFile<<$1->getName()<<endl<<endl; 		
 		}
 		;
 		
 		
declaration_list : declaration_list COMMA ID 
		  {
				$$->push_back($2);
				$$->push_back($3);
								
				logFile<<"At line no: "<< line_count <<" : "<<"declaration_list : declaration_list COMMA ID"
					   <<" : "<<endl<<endl;
				
				printNonTerminal($$);
				logFile<<endl<<endl;
				
		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
				$$->push_back($2);
				$$->push_back($3);
				$$->push_back($4);
				$$->push_back($5);
								
				logFile<<"At line no: "<< line_count <<" : "
					   <<"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD"<<" : "<<endl<<endl;
				
				printNonTerminal($$);
				logFile<<endl<<endl; 		  
 		  }
 		  | ID 
 		  {
 		  	symbolTable->Insert($1->getName(), "ID");
 		  	$$ = new vector<SymbolInfo*>();
 		  	$$->push_back($1);
 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "<<"declaration_list : ID"<<endl<<endl;
 		  	logFile<<$1->getName()<<endl<<endl;
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	$$ = new vector<SymbolInfo*>();
 		  	$$->push_back($1);
 		  	$$->push_back($2);
 		  	$$->push_back($3);
 		  	$$->push_back($4); 
 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "
 		  		   <<"declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
 		  	logFile<<$3->getName()<<endl<<endl;
 		  	logFile<<$1->getName()<<"["<<$3->getName()<<"]"<<endl<<endl;	   		  	
 		  }
 		  ;
 		  
statements : statement
	   | statements statement
	   ;
	   
statement : var_declaration
	  | expression_statement
	  | compound_statement
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  | IF LPAREN expression RPAREN statement
	  | IF LPAREN expression RPAREN statement ELSE statement
	  | WHILE LPAREN expression RPAREN statement
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  | RETURN expression SEMICOLON
	  ;
	  
expression_statement 	: SEMICOLON			
			| expression SEMICOLON 
			;
	  
variable : ID 		
	 | ID LTHIRD expression RTHIRD 
	 ;
	 
expression : logic_expression	
	   | variable ASSIGNOP logic_expression 	
	   ;
			
logic_expression : rel_expression 	
		 | rel_expression LOGICOP rel_expression 	
		 ;
			
rel_expression	: simple_expression 
		| simple_expression RELOP simple_expression	
		;
				
simple_expression : term 
		  | simple_expression ADDOP term 
		  ;
					
term :	unary_expression
     |  term MULOP unary_expression
     {
     	if(a == i){
     		
     	}
     }
     ;

unary_expression : ADDOP unary_expression  
		 | NOT unary_expression 
		 | factor 
		 ;
	
factor	: variable 
	| ID LPAREN argument_list RPAREN
	| LPAREN expression RPAREN
	| CONST_INT 
	| CONST_FLOAT
	| variable INCOP 
	| variable DECOP
	;
	
argument_list : arguments
			  |
			  ;
	
arguments : arguments COMMA logic_expression
	      | logic_expression
	      ;
 

%%
int main(int argc,char *argv[])
{

    if(argc!=2){
		cout << "Please provide input file name and try again" << endl;
		return 0;
    } 


    FILE *fin=fopen(argv[1],"r");
    
    if(fin==NULL){
		cout << "Cannot open specified file" << endl;
		return 0;
    }
	
	logFile.open("1705074_log.txt", ios::out);
	
	symbolTable->enterScope(30);

	yyin= fin;
	yyparse();
	
	fclose(yyin);
	
	logFile.close();
	
	return 0;
}





















