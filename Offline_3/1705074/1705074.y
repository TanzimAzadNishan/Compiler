%{
#include<bits/stdc++.h>
using namespace std;

ofstream logFile;
ofstream errorFile;

#include "1705074_Attribute.h"
#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"

#define YYSTYPE SymbolInfo*


int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error_count;

SymbolTable *symbolTable = new SymbolTable();
vector<SymbolInfo*> parametersInfo;
string declListType = "";
vector<SymbolInfo*> argumentsInfo;
string paramListErr;


void printError(string errMsg){
	error_count++;
	errorFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl;
	logFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl; 
}

void yyerror(char *s)
{
	cout<<"syntax error"<<endl;
	return;
}

void insertParameters(SymbolInfo* funcSymbol){
	for(int i = 0; i < parametersInfo.size(); i++){
		if(parametersInfo[i]->getName() == ""){
			printError(to_string(i+1)+"th parameter's name not given in function definition of "
					+ funcSymbol->getName());
		}
		symbolTable->Insert(parametersInfo[i]->getName(), parametersInfo[i]->getType(), 
								parametersInfo[i]->getDataType(), VARIABLE);			
	}
}

bool checkArgConsistency(SymbolInfo* funcSymbol, bool isDefinition){
	bool isConsistent = true;
	vector<SymbolInfo*> funcParameters = funcSymbol->getParameterList();
	int smallerVecSize = argumentsInfo.size();
	
	//cout<<line_count<<"	"<<argumentsInfo.size()<<" "<< funcSymbol->getNoOfParamters()<<endl;
	
	if(argumentsInfo.size() != funcSymbol->getNoOfParamters()){

		if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
			printError("Total number of arguments mismatch with declaration in function " + funcSymbol->getName());
		}	     
		else{
			printError("Total number of arguments mismatch in function " + funcSymbol->getName());
		}
		
		if(argumentsInfo.size() > funcSymbol->getNoOfParamters()){
			smallerVecSize = funcSymbol->getNoOfParamters();
		}
		isConsistent = false;		     
	}
	
	for(int i = 0; i < smallerVecSize; i++){
		if(argumentsInfo[i]->getAttribute() != funcParameters[i]->getAttribute()){
		
			if(argumentsInfo[i]->getAttribute() == ARRAY){
				printError("Type Mismatch, " + argumentsInfo[i]->getName()+ " is an array");
			}
			else if(funcParameters[i]->getAttribute() == ARRAY){
				printError("Type Mismatch, " + funcParameters[i]->getName()+ " is an array");
			}
			else {
				printError("Type Mismatch");
			}
			isConsistent = false;
			break;		
		}
		else if(argumentsInfo[i]->getDataType() != funcParameters[i]->getDataType()){
			if(isDefinition){
				printError(to_string(i+1) + "th argument mismatch in function " + funcSymbol->getName());
				isConsistent = false;
				break;
			}
		   	else if(funcParameters[i]->getDataType() != "float" && argumentsInfo[i]->getDataType() != "int"){
		   		
		   		printError(to_string(i+1) + "th argument mismatch in function " + funcSymbol->getName());
				isConsistent = false;
				break;
			}				
		}		
	}
	
	return isConsistent;
}


%}


%token IF ELSE FOR WHILE DO CHAR INT FLOAT VOID DOUBLE RETURN DEFAULT CONTINUE PRINTLN
%token LTHIRD RTHIRD LCURL RCURL LPAREN RPAREN
%token NOT COMMA SEMICOLON
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP
%token ID CONST_INT CONST_FLOAT CONST_CHAR NUMBER_ERR

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

start : program
	{
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"start : program"<<endl<<endl<<endl<<endl;
		
		logFile<<"Symbol Table :"<<endl<<endl;
		symbolTable->printAllScopeTable();

		logFile<<"Total Lines: "<<line_count<<endl<<endl;
		logFile << "Total errors: "<<error_count<<endl<<endl;
		errorFile << "Total errors: "<<error_count<<endl<<endl;		
	}
	;

program : program unit
	{
		string newName = $1->getName() + "\n" + $2->getName();
		$$ = new SymbolInfo(newName, "program");
					
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"program : program unit"<<endl<<endl;
		
		logFile<<$$->getName()<<endl<<endl<<endl;
	} 
	| unit
	{
		$$ = new SymbolInfo($1->getName(), "program");
 		
		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"program : unit"<<endl<<endl;
		
		logFile<<$$->getName()<<endl<<endl<<endl;	
	}
	;
	
unit : var_declaration
	 {
 		$$ = new SymbolInfo($1->getName(), "unit");
 		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"unit : var_declaration"<<endl<<endl;
		
		logFile<<$$->getName()<<endl<<endl;				 	
	 } 	
     | func_declaration
     {
     	$$ = new SymbolInfo($1->getName(), "unit");
 		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"unit : func_declaration"<<endl<<endl;
		
		logFile<<$$->getName()<<endl<<endl;	    	
     }
     | func_definition
     {
     	$$ = new SymbolInfo($1->getName(), "unit");
 		logFile<<endl;
		logFile<<"At line no: "<< line_count <<" : "<<"unit : func_definition"<<endl<<endl;
		
		logFile<<$$->getName()<<endl<<endl;     
     }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			bool isInserted = symbolTable->Insert($2->getName(), "ID", $1->getDataType(), FUNCTION_PROTOTYPE);
			
			if(!isInserted){
				printError("Multiple Declaration of " + $2->getName());		  		
	  		}
	  		else{
		  		SymbolInfo* funcProtoSymbol = symbolTable->Lookup($2->getName());
		  		funcProtoSymbol->setParameterList(parametersInfo);	  		
	  		}
			
			string newName = $1->getName() + " " + $2->getName() + "(" + $4->getName() + ")" + ";";
			$$ = new SymbolInfo(newName, "func_declaration");			
 		  	
			logFile<<"At line no: "<< line_count <<" : "
				   <<"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl;			
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			bool isInserted = symbolTable->Insert($2->getName(), "ID", $1->getDataType(), FUNCTION_PROTOTYPE);
			
	  		if(!isInserted){
				printError("Multiple Declaration of " + $2->getName());			  		
	  		}			
		
			string newName = $1->getName() + " " + $2->getName() + "(" + ")" + ";";
			$$ = new SymbolInfo(newName, "func_declaration");			
 		  	
			logFile<<"At line no: "<< line_count <<" : "
				   <<"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl;
		}
		| type_specifier ID LPAREN parameter_list RPAREN error SEMICOLON
		{	  				
			string newName = $1->getName() + " " + $2->getName() + "(" + $4->getName() + ")";
			$$ = new SymbolInfo(newName, "func_declaration");		
			printError("syntax error");
		}
		| type_specifier ID LPAREN RPAREN error SEMICOLON
		{		
			string newName = $1->getName() + " " + $2->getName() + "(" + ")";
			$$ = new SymbolInfo(newName, "func_declaration");		
			printError("syntax error");
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN
				  {
			  		bool isConsistent = true;
			  		bool isRedeclared = false;
			  		
			  		SymbolInfo* funcSymbol = symbolTable->Lookup($2->getName());
			  		if(funcSymbol != NULL){
			  		
			  			if(funcSymbol->getAttribute() == FUNCTION){
			  				printError("Multiple Definition of function : "+$2->getName());
			  				isRedeclared = true;						  
			  			}
			  			else if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
				  			isConsistent = checkArgConsistency(funcSymbol, true);
				  			argumentsInfo.clear();
				  			
				  			if($1->getDataType() != funcSymbol->getDataType()){
				  				isConsistent = false;
				  				printError("Return type mismatch with function declaration in function "
				  							+ $2->getName());
				  			}
			  			}
			  			else{
			  				printError("Multiple declaration of " + $2->getName());
			  			}
			  		}
			  		if(isConsistent && !isRedeclared){
			  			symbolTable->Remove($2->getName());
			  			symbolTable->Insert($2->getName(), "ID", $1->getDataType(), FUNCTION);
			  		}
			  		else{
			  			//printError("Function definition is not consistent with declaration");				  	
			  		}
			  		
			  		symbolTable->enterScope(30);
			  		if(isConsistent){
				  		SymbolInfo* funcSymbol = symbolTable->Lookup($2->getName());
				  		if(!isRedeclared){
				  			funcSymbol->setParameterList(parametersInfo);
				  		}
				  		insertParameters(funcSymbol);				  			
			  		}
				  			 	
				  }	
	   			  compound_statement
		{	
			string newName = $1->getName() + " " + $2->getName() + "(" + $4->getName() + ")" + $7->getName();
			$$ = new SymbolInfo(newName, "func_definition");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement"
				   <<endl<<endl;
		
			logFile<<$$->getName()<<endl<<endl;			
		}
		| type_specifier ID LPAREN RPAREN
		  {
		  		bool isConsistent = true;
		  		bool isRedeclared = false;
		  		argumentsInfo.clear();
		  		
		  		SymbolInfo* funcSymbol = symbolTable->Lookup($2->getName());
		  		if(funcSymbol != NULL){
		  		
		  			if(funcSymbol->getAttribute() == FUNCTION){
						printError("Multiple Definition of function : " + $2->getName());
						isRedeclared = true;					  
		  			}		  		
		  			else if(funcSymbol->getAttribute() == FUNCTION_PROTOTYPE){
			  			isConsistent = checkArgConsistency(funcSymbol, true);
			  			argumentsInfo.clear();
		  			}
		  		}
		  		if(isConsistent && !isRedeclared){
		  			symbolTable->Remove($2->getName());
		  			symbolTable->Insert($2->getName(), "ID", $1->getDataType(), FUNCTION);
		  		}
		  		else{
					//printError("Function definition is not consistent with declaration");				  	
		  		}
		  		
		  		symbolTable->enterScope(30);			  			 	
		  }	
		  compound_statement		
		{
			string newName = $1->getName() + " " + $2->getName() + "()" + $6->getName();
			$$ = new SymbolInfo(newName, "func_definition");			
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"func_definition : type_specifier ID LPAREN RPAREN compound_statement"<<endl<<endl;
		
			logFile<<$$->getName()<<endl<<endl;			
		}
 		;				


parameter_list : parameter_list COMMA type_specifier ID
		{
			SymbolInfo* paramSymbol = new SymbolInfo($4->getName(), "ID", $3->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
			argumentsInfo.push_back(paramSymbol);
			
			for(int i = 0; i < parametersInfo.size()-1; i++){
				if(parametersInfo[parametersInfo.size()-1]->getName() == parametersInfo[i]->getName()){
					printError("Multiple declaration of " + parametersInfo[i]->getName() + " in parameter");
					break;
				}
			}
		
			string newName = $1->getName() + "," + $3->getName() + " " + $4->getName();
			$$ = new SymbolInfo(newName, "parameter_list");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"parameter_list : parameter_list COMMA type_specifier ID"<<endl<<endl;
		
			logFile<<$$->getName()<<endl<<endl;			
		}
		| parameter_list COMMA type_specifier
		{
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $3->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
			
			argumentsInfo.push_back(paramSymbol);		
		
			string newName = $1->getName() + "," + $3->getName();
			$$ = new SymbolInfo(newName, "parameter_list");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"parameter_list : parameter_list COMMA type_specifier"<<endl<<endl;
		
			logFile<<$$->getName()<<endl<<endl;	
		}
 		| type_specifier ID
 		{
 			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo($2->getName(), "ID", $1->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);			
 		
 			string newName = $1->getName() + " " + $2->getName();
 			$$ = new SymbolInfo(newName, "parameter_list");
 			
 			logFile<<"At line no: "<< line_count <<" : "<<"parameter_list : type_specifier ID"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;
 		}
		| type_specifier
		{
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $1->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);					
		
			$$ = new SymbolInfo($1->getName(), "parameter_list");
			
			logFile<<"At line no: "<< line_count <<" : "<<"parameter_list : type_specifier"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;
		}
		| parameter_list COMMA type_specifier error
		{
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $3->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
					
			string newName = $1->getName() + "," + $3->getName();
			$$ = new SymbolInfo(newName, "parameter_list");
			paramListErr = newName;		
			printError("syntax error");
		}
		| parameter_list COMMA error
		{
			string newName = $1->getName() + ",";
			$$ = new SymbolInfo(newName, "parameter_list");
			paramListErr = newName;		
			printError("syntax error");
		}
		| type_specifier error
		{
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $1->getDataType(), VARIABLE);
			parametersInfo.push_back(paramSymbol);
					
			$$ = new SymbolInfo($1->getName(), "parameter_list");
			paramListErr = $1->getName();
			printError("syntax error");
		}
		| error
		{
			string newName = paramListErr;
			$$ = new SymbolInfo(newName, "parameter_list");
			//printError("syntax error p.4");	
		}
 		;

compound_statement : LCURL statements RCURL
			{			
				string newName = "{\n" + $2->getName() + "\n}";
				$$ = new SymbolInfo(newName, "compound_statement");	
		 		  	
				logFile<<"At line no: "<< line_count <<" : "
						<<"compound_statement : LCURL statements RCURL"<<endl<<endl;
				
				logFile<<$$->getName()<<endl<<endl;
				
				symbolTable->printAllScopeTable();
				symbolTable->exitScope();									
			}
 		    | LCURL RCURL
 		    {	
				string newName = "{\n}";
				$$ = new SymbolInfo(newName, "compound_statement");	
		 		  	
				logFile<<"At line no: "<< line_count <<" : "
						<<"compound_statement : LCURL RCURL"<<endl<<endl;
				
				logFile<<$$->getName()<<endl<<endl;

				symbolTable->printAllScopeTable();
				symbolTable->exitScope();					 		    
 		    }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
			
			string newName = $1->getName() + " " + $2->getName() + ";";
			$$ = new SymbolInfo(newName, "var_declaration");
			
			declListType = "";	
	 		  	
			logFile<<"At line no: "<< line_count <<" : "
					<<"var_declaration : type_specifier declaration_list SEMICOLON"<<endl<<endl;
			
			logFile<<$$->getName()<<endl<<endl;					
		 }
		 | type_specifier declaration_list error SEMICOLON
		 {
			string newName = $1->getName() + " " + $2->getName();
			$$ = new SymbolInfo(newName, "var_declaration");
			printError("syntax error");		 	
		 }
 		 ;
 		 
type_specifier : INT 
		{
			declListType = "int";
			
			$$ = new SymbolInfo("int", "type_specifier", "int");
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : INT"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;
		} 
 		| FLOAT
 		{
 			declListType = "float";
 		
			$$ = new SymbolInfo("float", "type_specifier", "float");
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : FLOAT"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl; 		
 		}
 		| VOID
 		{
 			declListType = "void";
 		
			$$ = new SymbolInfo("void", "type_specifier", "void");
			logFile<<"At line no: "<< line_count <<" : "<<"type_specifier : VOID"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;		
 		}
 		;
 		
 		
declaration_list : declaration_list COMMA ID 
		  {	
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{		  	
			  		bool isInserted = symbolTable->Insert($3->getName(), "ID", declListType, VARIABLE);
			  		
			  		if(!isInserted){
			  			printError("Multiple Declaration of " + $3->getName());		  		
			  		}
		  		//}
		  
				string newName = $1->getName() + "," + $3->getName();
				$$ = new SymbolInfo(newName, "declaration_list");
								
				logFile<<"At line no: "<< line_count <<" : "<<"declaration_list : declaration_list COMMA ID"
					   <<endl<<endl;
				
				logFile<<$$->getName()<<endl<<endl;
		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{ 		  
	 		  		bool isInserted = symbolTable->Insert($3->getName(), "ID", declListType, ARRAY);
	 		  		
			  		if(!isInserted){
						printError("Multiple Declaration of " + $3->getName());		  		
			  		}
		  		//} 		  		
 		  
				string newName = $1->getName() + "," + $3->getName() + "[" + $5->getName() + "]";
				$$ = new SymbolInfo(newName, "declaration_list");			
								
				logFile<<"At line no: "<< line_count <<" : "
					   <<"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD"<<endl<<endl;
				
				logFile<<$$->getName()<<endl<<endl; 	  
 		  }
 		  | ID 
 		  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert($1->getName(), "ID", declListType, VARIABLE);
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + $1->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list");
 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "<<"declaration_list : ID"<<endl<<endl;
 		  	logFile<<$$->getName()<<endl<<endl;
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert($1->getName(), "ID", declListType, ARRAY);
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + $1->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  
 		  	string newName = $1->getName() + "[" + $3->getName() + "]";
			$$ = new SymbolInfo(newName, "declaration_list");
 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "
 		  		   <<"declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
 		  	logFile<<$3->getName()<<endl<<endl;
 		  	logFile<<$$->getName()<<endl<<endl;   		  	
 		  }
 		  | declaration_list error ID 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list");
 		  }
 		  | declaration_list error ID LTHIRD CONST_INT RTHIRD 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list");
 		  }
 		  | error ID 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo("", "declaration_list");
 		  }
 		  | ID LTHIRD error RTHIRD 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo("", "declaration_list");
 		  }
 		  ;
 		  
statements : statement
	   {
			$$ = new SymbolInfo($1->getName(), "statements");
			logFile<<"At line no: "<< line_count <<" : "<<"statements : statement"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl<<endl;		   
	   }	
	   | statements statement
	   {
	   		string newName = $1->getName();
	   		if($2->getName() != ""){
	   			newName = $1->getName() + "\n" + $2->getName();
	   		}
			$$ = new SymbolInfo(newName, "statements");
			
			logFile<<"At line no: "<< line_count <<" : "<<"statements : statements statement"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl<<endl;	   
	   }
	   ;
	   
statement : var_declaration
	  {
			$$ = new SymbolInfo($1->getName(), "statement");
			logFile<<"At line no: "<< line_count <<" : "<<"statement : var_declaration"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl<<endl;		  
	  }
	  | expression_statement
	  {
			$$ = new SymbolInfo($1->getName(), "statement");
			logFile<<"At line no: "<< line_count <<" : "<<"statement : expression_statement"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl<<endl;	 	  
	  }
	  | {symbolTable->enterScope(30);} compound_statement
	  {
			$$ = new SymbolInfo($2->getName(), "statement");
			logFile<<"At line no: "<< line_count <<" : "<<"statement : compound_statement"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl<<endl;		  
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
		 	string newName = "for(" + $3->getName() + $4->getName() + $5->getName() + ")" + $7->getName();
			$$ = new SymbolInfo(newName, "statement");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"
				   <<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl<<endl;		  
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
		 	string newName = "if(" + $3->getName() + ")" + $5->getName();
			$$ = new SymbolInfo(newName, "statement");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"statement : IF LPAREN expression RPAREN statement"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl<<endl;		  
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
		 	string newName = "if(" + $3->getName() + ")" + $5->getName() + "else" + $7->getName();
			$$ = new SymbolInfo(newName, "statement");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"statement : IF LPAREN expression RPAREN statement ELSE statement"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl<<endl;	  
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
		 	string newName = "while(" + $3->getName() + ")" + $5->getName();
			$$ = new SymbolInfo(newName, "statement");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"statement : WHILE LPAREN expression RPAREN statement"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl<<endl;	  
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	  		SymbolInfo* idSymbol = symbolTable->Lookup($3->getName());
	  		if(idSymbol == NULL){
	  			printError("Undeclared Variable : " + $3->getName());
	  		}
	  
		 	string newName = "printf(" + $3->getName() + ");";
			$$ = new SymbolInfo(newName, "statement");
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl<<endl;	  
	  }
	  | RETURN expression SEMICOLON
	  {
	  	string newName = "return " + $2->getName() + ";";
		$$ = new SymbolInfo(newName, "statement");
		
		logFile<<"At line no: "<< line_count <<" : "<<"statement : RETURN expression SEMICOLON"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl<<endl;		  
	  }
	  | PRINTLN LPAREN ID RPAREN error SEMICOLON
	  {
	 	string newName = "printf(" + $3->getName() + ")";
		$$ = new SymbolInfo(newName, "statement");
		printError("syntax error");	  
	  }
	  | RETURN expression error SEMICOLON
	  {
	  	string newName = "return " + $2->getName();
		$$ = new SymbolInfo("", "statement");	  	
	  	printError("syntax error");
	  }
	  ;
	  
expression_statement : SEMICOLON
			{
				$$ = new SymbolInfo(";", "expression_statement");
				logFile<<"At line no: "<< line_count <<" : "<<"expression_statement : SEMICOLON"<<endl<<endl;
				logFile<<$$->getName()<<endl<<endl;					
			}			
			| expression SEMICOLON
			{
			 	string newName = $1->getName() + ";";
				$$ = new SymbolInfo(newName, "expression_statement");
				
				logFile<<"At line no: "<< line_count <<" : "
					   <<"expression_statement : expression SEMICOLON"<<endl<<endl;
					   
				logFile<<$$->getName()<<endl<<endl;				
			}
			| error SEMICOLON
			{
				$$ = new SymbolInfo("", "expression_statement"); 
				printError("syntax error"); 
			}
			| expression error SEMICOLON
			{
				$$ = new SymbolInfo("", "expression_statement");
				printError("syntax error");
			}
			;
	  
variable : ID
	 {
	 	SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 	}
	 	else{
	 		printError("Undeclared Variable : " + $1->getName());
	 	}	 	
	 	
		$$ = new SymbolInfo($1->getName(), "variable", dataType, attribute);
		logFile<<"At line no: "<< line_count <<" : "<<"variable : ID"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;	 
	 }	 		
	 | ID LTHIRD expression RTHIRD
	 {
	 	SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		
	 		if(idSymbol->getAttribute() != ARRAY){
	 			printError($1->getName() + " not an array. Index must be used with array");
	 		}
		 	if($3->getDataType() == "float"){
		 		printError("Expression inside third brackets not an integer");
		 	}	 			
	 	}
	 	else{
	 		printError("Undeclared Variable : " + $1->getName());
	 	}
	 	 		 
	 	string newName = $1->getName() + "[" + $3->getName() + "]";
		$$ = new SymbolInfo(newName, "variable", dataType, VARIABLE);
		
		logFile<<"At line no: "<< line_count <<" : "<<"variable : ID LTHIRD expression RTHIRD"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		 	
	 } 
	 ;
	 
expression : logic_expression
 	   {
			$$ = new SymbolInfo($1->getName(), "expression", $1->getDataType(), $1->getAttribute());
			logFile<<"At line no: "<< line_count <<" : "<<"expression : logic_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;	 	   
 	   }	
	   | variable ASSIGNOP logic_expression
	   {
	   		if($3->getDataType() == "void" && $3->getAttribute() == FUNCTION){
	   			printError("Void function used in expression");
	   		}
	   		else if(($1->getAttribute() == ARRAY || $3->getAttribute() == ARRAY) 
				&& $1->getAttribute() != $3->getAttribute()) {
				
					if($1->getAttribute() == ARRAY){ printError("Type Mismatch, "+$1->getName()+" is an array"); } 	
					if($3->getAttribute() == ARRAY){ printError("Type Mismatch, "+$3->getName()+" is an array"); } 
			}
			else if($1->getDataType() != $3->getDataType()){
				if($1->getDataType() == "void" || $3->getDataType() == "void"){
					printError("Type Mismatch");
				}
				else if(($1->getDataType() != "undefined" && $3->getDataType() != "undefined") &&
				($1->getDataType() != "float" && $3->getDataType() != "int")){
					printError("Type Mismatch");
				}
			}
	   		
			string newName = $1->getName() + "=" + $3->getName();
			$$ = new SymbolInfo(newName, "expression", "undefined", UNDEFINED);
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"expression : variable ASSIGNOP logic_expression"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl;		   	
	   } 	
	   ;
			
logic_expression : rel_expression
		 {
			$$ = new SymbolInfo($1->getName(), "logic_expression", $1->getDataType(), $1->getAttribute());
			logFile<<"At line no: "<< line_count <<" : "<<"logic_expression : rel_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;		 
		 } 	
		 | rel_expression LOGICOP rel_expression
		 {
		 	if($1->getDataType() == "void"){
		 		printError("1st operand of LOGICOP operation is void");
		 	}
		 	if($3->getDataType() == "void"){
		 		printError("2nd operand of LOGICOP operation is void");
		 	}
		 
			string newName = $1->getName() + $2->getName() + $3->getName();
			$$ = new SymbolInfo(newName, "logic_expression", "int", VARIABLE);
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"logic_expression : rel_expression LOGICOP rel_expression"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl;			 
		 } 	
		 ;
			
rel_expression	: simple_expression
		{
			$$ = new SymbolInfo($1->getName(), "rel_expression", $1->getDataType(), $1->getAttribute());
			logFile<<"At line no: "<< line_count <<" : "<<"rel_expression : simple_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;			
		} 
		| simple_expression RELOP simple_expression
		{
		 	if($1->getDataType() == "void"){
		 		printError("1st operand of RELOP operation is void");
		 	}
		 	if($3->getDataType() == "void"){
		 		printError("2nd operand of RELOP operation is void");
		 	}		
		
			string newName = $1->getName() + $2->getName() + $3->getName();
			$$ = new SymbolInfo(newName, "rel_expression", "int", VARIABLE);
			
			logFile<<"At line no: "<< line_count <<" : "
				   <<"rel_expression : simple_expression RELOP simple_expression"<<endl<<endl;
				   
			logFile<<$$->getName()<<endl<<endl;			
		}	
		;
		
simple_expression : term
		  {
			$$ = new SymbolInfo($1->getName(), "simple_expression", $1->getDataType(), $1->getAttribute());
			logFile<<"At line no: "<< line_count <<" : "<<"simple_expression : term"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;			  
		  } 
		  | simple_expression ADDOP term
		  {
		  	string newName = $1->getName() + $2->getName() + $3->getName();
			
			string dataType = "int";
			if($1->getDataType() == "float" || $3->getDataType() == "float"){
				dataType = "float";
			}
			if($1->getDataType() == "void" || $3->getDataType() == "void"){
				printError("operation on void type");
			}
			
			$$ = new SymbolInfo(newName, "simple_expression", dataType, $1->getAttribute());
			
			logFile<<"At line no: "<< line_count <<" : "<<"simple_expression : simple_expression ADDOP term"
				   <<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;			  
		  }
		  ;
		  
term :	unary_expression
		{
			$$ = new SymbolInfo($1->getName(), "term", $1->getDataType(), $1->getAttribute());
			logFile<<"At line no: "<< line_count <<" : "<<"term : unary_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;				
		}
		| term MULOP unary_expression
		{
		 	string dataType = "undefined";
		 	if($2->getName() == "%"){
		 		if($1->getDataType() == "float" || $3->getDataType() == "float"){
		 			printError("Non-Integer operand on modulus operator");
				}
				else{
					dataType = "int"; 
				}    
		 	}
		 	else{
				dataType = "int";
				if($1->getDataType() == "float" || $3->getDataType() == "float"){
					dataType = "float";
				}     	
		 	}
		 	
			if($3->getDataType() == "void" && $3->getAttribute() == FUNCTION){
	   			printError("Void function used in expression");
	   		}
	   		else if($1->getDataType() == "void" || $3->getDataType() == "void"){
				printError("operation on void type");
			}
		 	else if($3->getAttribute() == VARIABLE && $3->isNumber && stof($3->getName()) == 0.0){
		 		if($2->getName() == "%"){
		 			printError("Modulus by Zero");
		 		}
		 		else if($2->getName() == "/"){
		 			printError("Divide by Zero");
		 		}
		 	}		
		
		 	string newName = $1->getName() + $2->getName() + $3->getName();
			
			$$ = new SymbolInfo(newName, "term", dataType, $1->getAttribute());
			
			logFile<<"At line no: "<< line_count <<" : "<<"term : term MULOP unary_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;			
		}		  
		  
unary_expression : ADDOP unary_expression
		 {
		 	string newName = $1->getName() + $2->getName();
			$$ = new SymbolInfo(newName, "unary_expression", $2->getDataType(), $2->getAttribute());
			$$->isNumber = $2->isNumber;
			
			logFile<<"At line no: "<< line_count <<" : "<<"unary_expression : ADDOP unary_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;		 
		 }  
		 | NOT unary_expression
		 {
		 	string newName = "!" + $2->getName();
			$$ = new SymbolInfo(newName, "unary_expression", $2->getDataType(), $2->getAttribute());
			$$->isNumber = $2->isNumber;
			
			logFile<<"At line no: "<< line_count <<" : "<<"unary_expression : ADDOP unary_expression"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;		 
		 } 
		 | factor
		 {
			$$ = new SymbolInfo($1->getName(), "unary_expression", $1->getDataType(), $1->getAttribute());
			$$->isNumber = $1->isNumber;
			logFile<<"At line no: "<< line_count <<" : "<<"unary_expression : factor"<<endl<<endl;
			logFile<<$$->getName()<<endl<<endl;			 
		 } 
		 ;
	
factor : variable
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), $1->getAttribute());
		logFile<<"At line no: "<< line_count <<" : "<<"factor : variable"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		
	} 
	| ID LPAREN argument_list RPAREN
	{
		SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 		
	 		if(attribute == FUNCTION_PROTOTYPE){
	 			printError("Callee Function has no body");	 	
	 		}
		 	else if(attribute != FUNCTION && attribute != FUNCTION_PROTOTYPE){
		 		printError("A function call cannot be made with non-function type identifier");
		 	}
		 	else{
		 		checkArgConsistency(idSymbol, false);
		 		argumentsInfo.clear();
		 	}	 		
	 	}
	 	else{
	 		printError("Undeclared Function : " + $1->getName());
	 	}		
		
	 	string newName = $1->getName() + "(" + $3->getName() + ")";
		$$ = new SymbolInfo(newName, "factor", dataType, attribute);
		
		logFile<<"At line no: "<< line_count <<" : "<<"factor : ID LPAREN argument_list RPAREN"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;			
	}
	| LPAREN expression RPAREN
	{
	 	string newName = "(" + $2->getName() + ")";
		$$ = new SymbolInfo(newName, "factor", $2->getDataType(), $2->getAttribute());
		
		logFile<<"At line no: "<< line_count <<" : "<<"factor : LPAREN expression RPAREN"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		
	}
	| CONST_INT
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE);
		$$->isNumber = true;
		logFile<<"At line no: "<< line_count <<" : "<<"factor : CONST_INT"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;	
	} 
	| CONST_FLOAT
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE);
		$$->isNumber = true;
		logFile<<"At line no: "<< line_count <<" : "<<"factor : CONST_FLOAT"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		
	}
	| variable INCOP
	{
	 	string newName = $1->getName() + "++";
		$$ = new SymbolInfo(newName, "factor", $1->getDataType(), $1->getAttribute());
		
		logFile<<"At line no: "<< line_count <<" : "<<"factor : variable INCOP"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		
	} 
	| variable DECOP
	{
	 	string newName = $1->getName() + "--";
		$$ = new SymbolInfo(newName, "factor", $1->getDataType(), $1->getAttribute());
		
		logFile<<"At line no: "<< line_count <<" : "<<"factor : variable DECOP"<<endl<<endl;
		logFile<<$$->getName()<<endl<<endl;		
	}
	| NUMBER_ERR
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE);
	} 
	;
	
argument_list : arguments
			  {
					$$ = new SymbolInfo($1->getName(), "argument_list");
					logFile<<"At line no: "<< line_count <<" : "<<"argument_list : arguments"<<endl<<endl;
					logFile<<$$->getName()<<endl<<endl;				  
			  }
			  |
			  {
					$$ = new SymbolInfo("", "argument_list");
					logFile<<"At line no: "<< line_count <<" : "<<"argument_list :"<<endl<<endl;
					logFile<<$$->getName()<<endl<<endl;				  
			  }
			  ;
	
arguments : arguments COMMA logic_expression
		  {
	      		SymbolInfo* expSymbol = new SymbolInfo($3->getName(), $3->getType(), $3->getDataType(),
	      												$3->getAttribute());
	      		argumentsInfo.push_back(expSymbol);		  
		  
			 	string newName = $1->getName() + "," + $3->getName();
				$$ = new SymbolInfo(newName, "arguments");
				
				logFile<<"At line no: "<< line_count <<" : "<<"arguments : arguments COMMA logic_expression"
				       <<endl<<endl;
				       
				logFile<<$$->getName()<<endl<<endl;			  
		  }
	      | logic_expression
	      {
	      		argumentsInfo.clear();
	      		SymbolInfo* expSymbol = new SymbolInfo($1->getName(), $1->getType(), $1->getDataType(),
	      												$1->getAttribute());
	      		argumentsInfo.push_back(expSymbol);	
	      
				$$ = new SymbolInfo($1->getName(), "arguments");
				logFile<<"At line no: "<< line_count <<" : "<<"arguments : logic_expression"<<endl<<endl;
				logFile<<$$->getName()<<endl<<endl;		      
	      }
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
	errorFile.open("1705074_error.txt", ios::out);
	
	symbolTable->enterScope(30);

	yyin= fin;
	yyparse();
	
	fclose(yyin);
	
	logFile.close();
	errorFile.close();
	
	return 0;
}
		  			       
