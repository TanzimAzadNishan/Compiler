%{
#include<bits/stdc++.h>
using namespace std;

ofstream logFile;
ofstream errorFile;
ofstream asmFile;
ofstream optimizedAsmFile;

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

int labelCount=0;
int tempCount=0;


void printError(string errMsg){
	error_count++;
	errorFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl;
	logFile<<"Error at Line "<< line_count <<" : "<<errMsg<<endl<<endl; 
}

void printLog(string logMsg, string symbolName, bool hasNewLine){
	logFile<<"At line no: "<< line_count <<" : "<<logMsg<<endl<<endl;
	logFile<<symbolName<<endl<<endl;
	if(hasNewLine){
		logFile<<endl;
	}		
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
		
		SymbolInfo* paramSymbol = symbolTable->Lookup(parametersInfo[i]->getName());
		paramSymbol->setAsmSymbol("[bp+" + to_string((parametersInfo.size() - (1+i))*2 + 10) + "]");
													
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


string newLabel()
{
	string label = "L" + to_string(labelCount);
	labelCount++;
	return label;
}

string newTemp()
{
	string tempVar = "t" + to_string(tempCount);
	tempCount++;
	return tempVar;
}

#include "1705074_Util.h"
#include "1705074_Assembly.h"

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
		
		if(error_count == 0){							
			string programCode = $1->getCode();
			string stackDataSegCode = appendStackDataSegment();
			asmFile << stackDataSegCode;
			optimizedAsmFile << stackDataSegCode;

			asmFile << ".CODE\n\n";
			optimizedAsmFile << ".CODE\n\n";

			if(programCode.find("println") != std::string::npos){
				string printlnAsmCode = getAsmOfPrintln();
				asmFile << printlnAsmCode;
				optimizedAsmFile << printlnAsmCode;
			}

			asmFile << programCode;
			optimizedAsmFile << generateOptimizedAsmCode(programCode);

			asmFile << "\nEND MAIN\n";
			optimizedAsmFile << "\nEND MAIN\n";		
		}
				
		delete $1;		
	}
	;

program : program unit
	{
		string newName = $1->getName() + "\n" + $2->getName();
		string code = $1->getCode() + $2->getCode();
		$$ = new SymbolInfo(newName, "program", "undefined", UNDEFINED, "", code);
					
		logFile<<endl;
		printLog("program : program unit", $$->getName(), true);
		delete $1; delete $2;
	} 
	| unit
	{
		$$ = new SymbolInfo($1->getName(), "program", "undefined", UNDEFINED, "", $1->getCode());
 		
		logFile<<endl;
		printLog("program : unit", $$->getName(), true);
		delete $1;	
	}
	;
	
unit : var_declaration
	 {
 		$$ = new SymbolInfo($1->getName(), "unit", "undefined", UNDEFINED, "", $1->getCode());
 		logFile<<endl;
 		printLog("unit : var_declaration", $$->getName(), false);
 		delete $1;				 	
	 } 	
     | func_declaration
     {
     	$$ = new SymbolInfo($1->getName(), "unit", "undefined", UNDEFINED, "", $1->getCode());
 		logFile<<endl;
 		printLog("unit : func_declaration", $$->getName(), false);
 		delete $1;    	
     }
     | func_definition
     {
     	$$ = new SymbolInfo($1->getName(), "unit", "undefined", UNDEFINED, "", $1->getCode());
 		logFile<<endl;
 		printLog("unit : func_definition", $$->getName(), false); 
 		delete $1;    
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
			$$ = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");
			
			printLog("func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON", $$->getName(), 
				false);
				
			delete $1; delete $2; delete $4;							
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			bool isInserted = symbolTable->Insert($2->getName(), "ID", $1->getDataType(), FUNCTION_PROTOTYPE);
			
	  		if(!isInserted){
				printError("Multiple Declaration of " + $2->getName());			  		
	  		}			
		
			string newName = $1->getName() + " " + $2->getName() + "(" + ")" + ";";
			$$ = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");
			
			printLog("func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON", $$->getName(), false);
			delete $1; delete $2;
		}
		| type_specifier ID LPAREN parameter_list RPAREN error SEMICOLON
		{	  				
			string newName = $1->getName() + " " + $2->getName() + "(" + $4->getName() + ")";
			$$ = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");		
			printError("syntax error");
			delete $1; delete $2; delete $4;
		}
		| type_specifier ID LPAREN RPAREN error SEMICOLON
		{		
			string newName = $1->getName() + " " + $2->getName() + "(" + ")";
			$$ = new SymbolInfo(newName, "func_declaration", "undefined", UNDEFINED, "", "");		
			printError("syntax error");
			delete $1; delete $2;
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
			  		
			  		symbolTable->enterScope(30, $2->getName());
			  		if(isConsistent){
				  		SymbolInfo* funcSymbol = symbolTable->Lookup($2->getName());
				  		
						string tempVar1 = $2->getName() + "_ra";
						funcSymbol->setFuncReturnAsmSymbol(tempVar1);

				  		if(!isRedeclared){
				  			funcSymbol->setParameterList(parametersInfo);
				  		}		  			
				  		insertParameters(funcSymbol);
			  		}
				  			 	
				  }	
	   			  compound_statement
		{	
			string newName = $1->getName() + " " + $2->getName() + "(" + $4->getName() + ")" + $7->getName();
			string code = getAsmOfParameterizedFunction($2, $7);

			$$ = new SymbolInfo(newName, "func_definition", "undefined", UNDEFINED, "", code);
			printLog("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement", 
				$$->getName(), false);	
				
			delete $1; delete $2; delete $4; delete $7;		
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
		  		
		  		symbolTable->enterScope(30, $2->getName());
		  		
		  		if($2->getName() != "main"){
					SymbolInfo* currentFuncSymbol = symbolTable->Lookup($2->getName());
					string tempVar1 = $2->getName() + "_ra";
					currentFuncSymbol->setFuncReturnAsmSymbol(tempVar1);
				}		  			 	
		  }	
		  compound_statement		
		{
			string newName = $1->getName() + " " + $2->getName() + "()" + $6->getName();
			string code = getAsmOfNonParamFunction($2, $6);
			
			$$ = new SymbolInfo(newName, "func_definition", "undefined", UNDEFINED, "", code);
			printLog("func_definition : type_specifier ID LPAREN RPAREN compound_statement", $$->getName(), 				false);
			
			delete $1; delete $2; delete $6;					
		}
 		;				


parameter_list : parameter_list COMMA type_specifier ID
		{
			SymbolInfo* paramSymbol = new SymbolInfo($4->getName(), "ID", $3->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			argumentsInfo.push_back(paramSymbol);
			
			for(int i = 0; i < parametersInfo.size()-1; i++){
				if(parametersInfo[parametersInfo.size()-1]->getName() == parametersInfo[i]->getName()){
					printError("Multiple declaration of " + parametersInfo[i]->getName() + " in parameter");
					break;
				}
			}
		
			string newName = $1->getName() + "," + $3->getName() + " " + $4->getName();
			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : parameter_list COMMA type_specifier ID", $$->getName(), false);
			delete $1; delete $3; delete $4;		
		}
		| parameter_list COMMA type_specifier
		{
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $3->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
			argumentsInfo.push_back(paramSymbol);		
		
			string newName = $1->getName() + "," + $3->getName();
			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : parameter_list COMMA type_specifier", $$->getName(), false);
			delete $1; delete $3;
		}
 		| type_specifier ID
 		{
 			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo($2->getName(), "ID", $1->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);			
 		
 			string newName = $1->getName() + " " + $2->getName();
 			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
 			
 			printLog("parameter_list : type_specifier ID", $$->getName(), false);
 			delete $1; delete $2;
 		}
		| type_specifier
		{
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $1->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
			
      		argumentsInfo.clear();
      		argumentsInfo.push_back(paramSymbol);					
		
			$$ = new SymbolInfo($1->getName(), "parameter_list", "undefined", UNDEFINED, "", "");
			
			printLog("parameter_list : type_specifier", $$->getName(), false);
			delete $1;
		}
		| parameter_list COMMA type_specifier error
		{
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $3->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
					
			string newName = $1->getName() + "," + $3->getName();
			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = newName;		
			printError("syntax error");
			
			delete $1; delete $3;
		}
		| parameter_list COMMA error
		{
			string newName = $1->getName() + ",";
			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = newName;		
			printError("syntax error");
			delete $1;
		}
		| type_specifier error
		{
			parametersInfo.clear();
			SymbolInfo* paramSymbol = new SymbolInfo("", "ID", $1->getDataType(), VARIABLE, "", "");
			parametersInfo.push_back(paramSymbol);
					
			$$ = new SymbolInfo($1->getName(), "parameter_list", "undefined", UNDEFINED, "", "");
			paramListErr = $1->getName();
			printError("syntax error");
			
			delete $1;
		}
		| error
		{
			string newName = paramListErr;
			$$ = new SymbolInfo(newName, "parameter_list", "undefined", UNDEFINED, "", "");
			//printError("syntax error p.4");	
		}
 		;

compound_statement : LCURL statements RCURL
			{			
				string newName = "{\n" + $2->getName() + "\n}";
				$$ = new SymbolInfo(newName, "compound_statement", "undefined", UNDEFINED, "", $2->getCode());
				printLog("compound_statement : LCURL statements RCURL", $$->getName(), false);
				delete $2;
				
				freeTempVarOfCurrScope();					
				symbolTable->printAllScopeTable();
				symbolTable->exitScope();									
			}
 		    | LCURL RCURL
 		    {	
				string newName = "{\n}";
				$$ = new SymbolInfo(newName, "compound_statement", "undefined", UNDEFINED, "", "");
				printLog("compound_statement : LCURL RCURL", $$->getName(), false);
				
				freeTempVarOfCurrScope();
				symbolTable->printAllScopeTable();
				symbolTable->exitScope();					 		    
 		    }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
			
			string newName = $1->getName() + " " + $2->getName() + ";";
			$$ = new SymbolInfo(newName, "var_declaration", "undefined", UNDEFINED, "", "");
			
			declListType = "";
			printLog("var_declaration : type_specifier declaration_list SEMICOLON", $$->getName(), false);
			delete $1; delete $2;
		 }
		 | type_specifier declaration_list error SEMICOLON
		 {
			string newName = $1->getName() + " " + $2->getName();
			$$ = new SymbolInfo(newName, "var_declaration", "undefined", UNDEFINED, "", "");
			printError("syntax error");
			delete $1; delete $2;		 	
		 }
 		 ;
 		 
type_specifier : INT 
		{
			declListType = "int";
			
			$$ = new SymbolInfo("int", "type_specifier", "int", UNDEFINED, "", "");
			printLog("type_specifier : INT", $$->getName(), false);
		} 
 		| FLOAT
 		{
 			declListType = "float";
 		
			$$ = new SymbolInfo("float", "type_specifier", "float", UNDEFINED, "", "");
			printLog("type_specifier : FLOAT", $$->getName(), false);		
 		}
 		| VOID
 		{
 			declListType = "void";
 		
			$$ = new SymbolInfo("void", "type_specifier", "void", UNDEFINED, "", "");
			printLog("type_specifier : VOID", $$->getName(), false);	
 		}
 		;
 		
 		
declaration_list : declaration_list COMMA ID 
		  {	
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{		  	
			  		bool isInserted = symbolTable->Insert($3->getName(), "ID", declListType, VARIABLE, "0");
			  		
			  		if(!isInserted){
			  			printError("Multiple Declaration of " + $3->getName());		  		
			  		}
		  		//}
		  
				string newName = $1->getName() + "," + $3->getName();
				$$ = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
				
				printLog("declaration_list : declaration_list COMMA ID", $$->getName(), false);
				delete $1; delete $3;
		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
	 		  	if(declListType == "void"){
	 		  		printError("Variable type cannot be void");
	 		  	}
	 		  	//else{ 		  
	 		  		bool isInserted = symbolTable->Insert($3->getName(), "ID", declListType, ARRAY, $5->getName());
	 		  		
			  		if(!isInserted){
						printError("Multiple Declaration of " + $3->getName());		  		
			  		}
		  		//} 		  		
 		  
				string newName = $1->getName() + "," + $3->getName() + "[" + $5->getName() + "]";
				$$ = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
				
				printLog("declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD", $$->getName(), 					false);
				
				delete $1; delete $3; delete $5;			 	  
 		  }
 		  | ID 
 		  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert($1->getName(), "ID", declListType, VARIABLE, "0");
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + $1->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	
 		  	printLog("declaration_list : ID", $$->getName(), false);
 		  	delete $1;
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	if(declListType == "void"){
 		  		printError("Variable type cannot be void");
 		  	}
 		  	//else{
	 		  	bool isInserted = symbolTable->Insert($1->getName(), "ID", declListType, ARRAY, $3->getName());
	 		  	
		  		if(!isInserted){
					printError("Multiple Declaration of " + $1->getName());		  		
		  		}
	  		//} 		  	
 		  	
 		  
 		  	string newName = $1->getName() + "[" + $3->getName() + "]";
			$$ = new SymbolInfo(newName, "declaration_list", "undefined", UNDEFINED, "", "");
			 		  	
 		  	logFile<<"At line no: "<< line_count <<" : "
 		  		   <<"declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
 		  	logFile<<$3->getName()<<endl<<endl;
 		  	logFile<<$$->getName()<<endl<<endl;
 		  	
 		  	delete $1; delete $3;   		  	
 		  }
 		  | declaration_list error ID 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	delete $1;
 		  }
 		  | declaration_list error ID LTHIRD CONST_INT RTHIRD 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo($1->getName(), "declaration_list", "undefined", UNDEFINED, "", "");
 		  	delete $1;
 		  }
 		  | error ID 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo("", "declaration_list", "undefined", UNDEFINED, "", "");
 		  }
 		  | ID LTHIRD error RTHIRD 
 		  {
 		  	printError("syntax error");
 		  	$$ = new SymbolInfo("", "declaration_list", "undefined", UNDEFINED, "", "");
 		  }
 		  ;
 		  
statements : statement
	   {
	   	   	string documentation = $1->getName();
	   		if($1->getAsmSymbol() == "if" || $1->getAsmSymbol() == "for" || $1->getAsmSymbol() == "while"){
	   			documentation = $1->getAsmSymbol();
	   		}
	   		
	   		string code = "\n;" + documentation + "\n" + $1->getCode();
			$$ = new SymbolInfo($1->getName(), "statements", "undefined", UNDEFINED, "", code);
			printLog("statements : statement", $$->getName(), true);
			delete $1;		   
	   }	
	   | statements statement
	   {
	   		string newName = $1->getName();
	   		if($2->getName() != ""){
	   			newName = $1->getName() + "\n" + $2->getName();
	   		}
	   		
	   		string documentation = $2->getName();
	   		if($2->getAsmSymbol() == "if" || $2->getAsmSymbol() == "for" || $2->getAsmSymbol() == "while"){
	   			documentation = $2->getAsmSymbol();
	   		}
	   		string code = $1->getCode() + "\n;" + documentation + "\n" + $2->getCode();
			$$ = new SymbolInfo(newName, "statements", "undefined", UNDEFINED, "", code);
			
			printLog("statements : statements statement", $$->getName(), true);
			delete $1; delete $2;	   
	   }
	   ;
	   
statement : var_declaration
	  {
			$$ = new SymbolInfo($1->getName(), "statement", "undefined", UNDEFINED, "", "");
			printLog("statement : var_declaration", $$->getName(), true);
			delete $1;		  
	  }
	  | expression_statement
	  {
			$$ = new SymbolInfo($1->getName(), "statement", "undefined", UNDEFINED, "", $1->getCode());
			printLog("statement : expression_statement", $$->getName(), true);
			delete $1; 	  
	  }
	  | {
	  		string scopeName = symbolTable->getCurrentScopeTable()->getName();
	  		string newScopeName = "undefined";
	  		if(scopeName != "undefined" && scopeName != "global"){
	  			newScopeName = scopeName;
	  		}
	  		symbolTable->enterScope(30, newScopeName);
	  } 
	  compound_statement
	  {
			$$ = new SymbolInfo($2->getName(), "statement", "undefined", UNDEFINED, "", $2->getCode());
			printLog("statement : compound_statement", $$->getName(), true);
			delete $2;  
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
		 	string newName = "for(" + $3->getName() + $4->getName() + $5->getName() + ")" + $7->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = $3->getCode();
		 	code += label1 + ":\n";
		 	code += $4->getCode();
		 	code += "cmp " + $4->getAsmSymbol() + ", 0\n";
		 	code += "je " + label2 + "\n";
		 	code += $7->getCode();
		 	code += $5->getCode();
		 	code += "jmp " + label1 + "\n";
		 	code += label2 + ":\n";
		 	
			$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "for", code);
			printLog("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement", 					$$->getName(), true);
			delete $3; delete $4; delete $5; delete $7;		  
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
		 	string newName = "if(" + $3->getName() + ")" + $5->getName();
		 	string label1 = newLabel();
		 	
		 	string code = $3->getCode();
		 	code += "mov ax, " + $3->getAsmSymbol() + "\n";
		 	code += "cmp ax, 0\n";
		 	code += "je " + label1 + "\n";
		 	code += $5->getCode();  	//if
		 	code += label1 + ":\n\n";
		 	
			$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "if", code);
			printLog("statement : IF LPAREN expression RPAREN statement", $$->getName(), true);
			delete $3; delete $5;	  
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
		 	string newName = "if(" + $3->getName() + ")" + $5->getName() + "else" + $7->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = $3->getCode();
		 	code += "mov ax, " + $3->getAsmSymbol() + "\n";
		 	code += "cmp ax, 1\n";
		 	code += "jne " + label1 + "\n";
		 	code += $5->getCode();  	//if
		 	code += "jmp " + label2 + "\n";
		 	code += label1 + ":\n";		//else
		 	code += $7->getCode();
		 	code += label2 + ":\n\n";  
		 	
			$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "if", code);
			printLog("statement : IF LPAREN expression RPAREN statement ELSE statement", $$->getName(), true);
			delete $3; delete $5; delete $7;	  
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
		 	string newName = "while(" + $3->getName() + ")" + $5->getName();
		 	string label1 = newLabel();
		 	string label2 = newLabel();
		 	
		 	string code = label1 + ":\n";
		 	code += $3->getCode();
		 	code += "cmp " + $3->getAsmSymbol() + ", 0\n";
		 	code += "je " + label2 + "\n";
		 	code += $5->getCode();
		 	code += "jmp " + label1 + "\n";
		 	code += label2 + ":\n";
		 	
			$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "while", code);
			printLog("statement : WHILE LPAREN expression RPAREN statement", $$->getName(), true);
			delete $3; delete $5;  
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	  		SymbolInfo* idSymbol = symbolTable->Lookup($3->getName());
	  		string code = "";
	  		
	  		if(idSymbol == NULL){
	  			printError("Undeclared Variable : " + $3->getName());
	  		}
			else{
			 	code += "push " + idSymbol->getAsmSymbol() + "\n";
			 	code += "mov dx, 0\n";
			 	code += "mov cx, 0\n";
			 	code += "call println\n";
		 	}
		 	
		 	string newName = "println(" + $3->getName() + ");";
			$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "", code);
			printLog("statement : PRINTLN LPAREN ID RPAREN SEMICOLON", $$->getName(), true);
			delete $3;  
	  }
	  | RETURN expression SEMICOLON
	  {
	  	string newName = "return " + $2->getName() + ";";
	  	string code = getAsmOfReturn($2);
	  	
		$$ = new SymbolInfo(newName, "statement", "statement", UNDEFINED, "", code);
		printLog("statement : RETURN expression SEMICOLON", $$->getName(), true);
		delete $2;		  
	  }
	  | PRINTLN LPAREN ID RPAREN error SEMICOLON
	  {
	 	string newName = "println(" + $3->getName() + ")";
		$$ = new SymbolInfo(newName, "statement", "undefined", UNDEFINED, "", "");
		printError("syntax error");
		delete $3;	  
	  }
	  | RETURN expression error SEMICOLON
	  {
	  	string newName = "return " + $2->getName();
		$$ = new SymbolInfo("", "statement", "undefined", UNDEFINED, "", "");	  	
	  	printError("syntax error");
	  	delete $2;
	  }
	  ;
	  
expression_statement : SEMICOLON
			{
				$$ = new SymbolInfo(";", "expression_statement", "undefined", UNDEFINED, "", "");
				printLog("expression_statement : SEMICOLON", $$->getName(), false);				
			}			
			| expression SEMICOLON
			{
			 	string newName = $1->getName() + ";";
				$$ = new SymbolInfo(newName, "expression_statement", "undefined", UNDEFINED,
						$1->getAsmSymbol() , $1->getCode());
							
				printLog("expression_statement : expression SEMICOLON", $$->getName(), false);
				delete $1;		
			}
			| error SEMICOLON
			{
				$$ = new SymbolInfo("", "expression_statement", "undefined", UNDEFINED, "", ""); 
				printError("syntax error"); 
			}
			| expression error SEMICOLON
			{
				$$ = new SymbolInfo("", "expression_statement", "undefined", UNDEFINED, "", "");
				printError("syntax error");
				delete $1;
			}
			;
	  
variable : ID
	 {
	 	SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	string asmSymbol = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 	}
	 	else{
	 		printError("Undeclared Variable : " + $1->getName());
	 	}	 	
	 	
		$$ = new SymbolInfo($1->getName(), "variable", dataType, attribute, asmSymbol, "");
		$$->baseProperty = VARIABLE;
		
		printLog("variable : ID", $$->getName(), false);		
		delete $1;
	 }	 		
	 | ID LTHIRD expression RTHIRD
	 {
	 	SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	string asmSymbol = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 		
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
	 	string code = $3->getCode() + "mov bx, " + $3->getAsmSymbol() +"\nadd bx, bx\n";
	 	
		$$ = new SymbolInfo(newName, "variable", dataType, VARIABLE, asmSymbol, code);
		$$->baseProperty = ARRAY;
		
		printLog("variable : ID LTHIRD expression RTHIRD", $$->getName(), false);
		delete $1; delete $3;		 	
	 } 
	 ;
	 
expression : logic_expression
 	   {
			$$ = new SymbolInfo($1->getName(), "expression", $1->getDataType(), $1->getAttribute(), 
					$1->getAsmSymbol(), $1->getCode());

			freeTempVarAfterExpression($1->getAsmSymbol());	
			printLog("expression : logic_expression", $$->getName(), false);
			delete $1;	   
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
			string code = getAsmOfAssignment($1, $3);
			
			$$ = new SymbolInfo(newName, "expression", "undefined", UNDEFINED, $1->getAsmSymbol(), code);
			printLog("expression : variable ASSIGNOP logic_expression", $$->getName(), false);
			delete $1; delete $3;	   	
	   } 	
	   ;
			
logic_expression : rel_expression
		 {
			$$ = new SymbolInfo($1->getName(), "logic_expression", $1->getDataType(), $1->getAttribute(), 
					$1->getAsmSymbol(), $1->getCode());
			$$->isNumber = $1->isNumber;
			$$->baseProperty = $1->baseProperty;
			printLog("logic_expression : rel_expression", $$->getName(), false);
			delete $1;	 
		 } 	
		 | rel_expression LOGICOP rel_expression
		 {
		 	if($1->getDataType() == "void"){
		 		printError("1st operand of LOGICOP operation is void");
		 	}
		 	if($3->getDataType() == "void"){
		 		printError("2nd operand of LOGICOP operation is void");
		 	}
		 	
		 	string tempVar = getDstAddress($1, $3);
		 	string label1 = newLabel();
			string label2 = newLabel();
			
			string code = getAsmOfALU($1, $3);
		 	code += "cmp ax, 0\n";
		 			 	
		 	if($2->getName() == "&&"){
		 		code += "je " + label1 + "\n";
			 	code += "cmp bx, 0\n";
			 	code += "je " + label1 + "\n";
				code += "mov " + tempVar + ", 1\n";
				code += "jmp " + label2 + "\n";
			 	code += label1 + ":\n" + "mov "+ tempVar + ", 0\n";
		 	}
		 	else if($2->getName() == "||"){
		 		code += "jne " + label1 + "\n";
			 	code += "cmp bx, 0\n";
			 	code += "jne " + label1 + "\n";
				code += "mov " + tempVar + ", 0\n";
				code += "jmp " + label2 + "\n";
			 	code += label1 + ":\n" + "mov "+ tempVar + ", 1\n";
		 	}		 	
		 	code += label2 + ":\n\n";
		 
			string newName = $1->getName() + $2->getName() + $3->getName();
			$$ = new SymbolInfo(newName, "logic_expression", "int", VARIABLE, tempVar, code);
			$$->baseProperty = ALU;
			
			printLog("logic_expression : rel_expression LOGICOP rel_expression", $$->getName(), false);
			delete $1; delete $2; delete $3;		 
		 } 	
		 ;
			
rel_expression	: simple_expression
		{
			$$ = new SymbolInfo($1->getName(), "rel_expression", $1->getDataType(), $1->getAttribute(), 
					$1->getAsmSymbol(), $1->getCode());
			$$->isNumber = $1->isNumber;
			$$->baseProperty = $1->baseProperty;
			printLog("rel_expression : simple_expression", $$->getName(), false);
			delete $1;			
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
			string tempVar = getDstAddress($1, $3);
			string label1 = newLabel();
			string label2 = newLabel();
			
			string code = getAsmOfALU($1, $3);
			code += "cmp ax, bx\n";
			
			if($2->getName() == "<"){
				code += "jl " + label1 + "\n";
			}
			else if($2->getName() == "<="){
				code += "jle " + label1 + "\n";
			}
			else if($2->getName() == ">"){
				code += "jg " + label1 + "\n";
			}
			else if($2->getName() == ">="){
				code += "jge " + label1 + "\n";
			}
			else if($2->getName() == "=="){
				code += "je " + label1 + "\n";
			}
			else if($2->getName() == "!="){
				code += "jne " + label1 + "\n";
			}
			
			code += "mov " + tempVar + ", 0\n";
			code += "jmp " + label2 + "\n";
			code += label1 + ":\n" + "mov "+ tempVar + ", 1\n";
			code += label2 + ":\n\n";			
			
			$$ = new SymbolInfo(newName, "rel_expression", "int", VARIABLE, tempVar, code);
			$$->baseProperty = ALU;
			printLog("rel_expression : simple_expression RELOP simple_expression", $$->getName(), false);
			delete $1; delete $2; delete $3;		
		}	
		;
		
simple_expression : term
		  {
			$$ = new SymbolInfo($1->getName(), "simple_expression", $1->getDataType(), $1->getAttribute(), 
					$1->getAsmSymbol(), $1->getCode());
			$$->isNumber = $1->isNumber;
			$$->baseProperty = $1->baseProperty;
			
			printLog("simple_expression : term", $$->getName(), false);
			delete $1;			  
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
						
		 	string tempVar = getDstAddress($1, $3);
			string code = getAsmOfALU($1, $3);
			
			if($2->getName() == "+"){
				code += "add ax, bx\n";
			}
			else{
				code += "sub ax, bx\n";
			}
			code += "mov " + tempVar + ", ax\n";
			
			$$ = new SymbolInfo(newName, "simple_expression", dataType, VARIABLE, tempVar, code);
			$$->baseProperty = ALU;
			printLog("simple_expression : simple_expression ADDOP term", $$->getName(), false);
			
			delete $1; delete $2; delete $3;		  
		  }
		  ;
		  
term :	unary_expression
		{
			$$ = new SymbolInfo($1->getName(), "term", $1->getDataType(), $1->getAttribute(), $1->getAsmSymbol(),
					$1->getCode());
			$$->isNumber = $1->isNumber;
			$$->baseProperty = $1->baseProperty;
			
			printLog("term : unary_expression", $$->getName(), false);
			delete $1;			
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
		 	string tempVar = getDstAddress($1, $3);
		 	string code = getAsmOfALU($1, $3);
			
			if($2->getName() == "*"){
				code += "mul bx\n";
			}
			else if($2->getName() == "/" || $2->getName() == "%"){
				code += "xor dx, dx\n";
				code += "div bx\n";
			}
			
			if($2->getName() == "%"){
				code += "mov " + tempVar + ", dx\n";
			}
			else{
				code += "mov " + tempVar + ", ax\n";
			}
			
			$$ = new SymbolInfo(newName, "term", dataType, VARIABLE, tempVar, code);
			$$->baseProperty = ALU;
			
			printLog("term : term MULOP unary_expression", $$->getName(), false);
			
			delete $1; delete $2; delete $3;		
		}
		;		  
		  
unary_expression : ADDOP unary_expression
		 {
		 	string newName = $1->getName() + $2->getName();
			string code = "";
			string tempVar = getDstAddressForUnary($2);
			
			if($1->getName() == "-"){
				code += getAsmOfUnary($2);
				code += "neg ax\n";
				code += "mov " + tempVar + ", ax\n";
			}
			
			$$ = new SymbolInfo(newName, "unary_expression", $2->getDataType(), VARIABLE, tempVar, code);
			$$->isNumber = $2->isNumber;
			printLog("unary_expression : ADDOP unary_expression", $$->getName(), false);
			
			delete $1; delete $2;	 
		 }  
		 | NOT unary_expression
		 {
		 	string newName = "!" + $2->getName();
		 	string code = "";
			string tempVar = getDstAddressForUnary($2);
			
			code += getAsmOfUnary($2);
			code += "not ax\n";
			code += "mov " + tempVar + ", ax\n";
		 	
			$$ = new SymbolInfo(newName, "unary_expression", $2->getDataType(), VARIABLE, tempVar, code);
			$$->isNumber = $2->isNumber;
			printLog("unary_expression : NOT unary_expression", $$->getName(), false);
			
			delete $2;		 
		 } 
		 | factor
		 {
			$$ = new SymbolInfo($1->getName(), "unary_expression", $1->getDataType(), $1->getAttribute(), 
				$1->getAsmSymbol(), $1->getCode());
			$$->isNumber = $1->isNumber;
			$$->baseProperty = $1->baseProperty;
			printLog("unary_expression : factor", $$->getName(), false);
			delete $1;		 
		 } 
		 ;
	
factor : variable
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), $1->getAttribute(), 
				$1->getAsmSymbol(), $1->getCode());
				
		$$->baseProperty = $1->baseProperty;			
		printLog("factor : variable", $$->getName(), false);		
		delete $1;	
	} 
	| ID LPAREN argument_list RPAREN
	{
		SymbolInfo* idSymbol = symbolTable->Lookup($1->getName());
	 	string dataType = "undefined";
	 	Attribute attribute = UNDEFINED;
	 	string asmSymbol = "";
	 	string code = "";
	 	
	 	if(idSymbol != NULL){
	 		dataType = idSymbol->getDataType();
	 		attribute = idSymbol->getAttribute();
	 		asmSymbol = idSymbol->getAsmSymbol();
	 		
	 		if(attribute == FUNCTION_PROTOTYPE){
	 			printError("Callee Function has no body");	 	
	 		}
		 	else if(attribute != FUNCTION && attribute != FUNCTION_PROTOTYPE){
		 		printError("A function call cannot be made with non-function type identifier");
		 	}
		 	else{
		 		code = getAsmOfFunctionCall(idSymbol, $3);
		 		checkArgConsistency(idSymbol, false);
		 		argumentsInfo.clear();
		 	}	 		
	 	}
	 	else{
	 		printError("Undeclared Function : " + $1->getName());
	 	}
	 	
	 	string newName = $1->getName() + "(" + $3->getName() + ")";
	 	
		$$ = new SymbolInfo(newName, "factor", dataType, attribute, asmSymbol, code);
		printLog("factor : ID LPAREN argument_list RPAREN", $$->getName(), false);
		delete $1; delete $3;		
	}
	| LPAREN expression RPAREN
	{
	 	string newName = "(" + $2->getName() + ")";
		$$ = new SymbolInfo(newName, "factor", $2->getDataType(), $2->getAttribute(), 
			$2->getAsmSymbol(), $2->getCode());
		printLog("factor : LPAREN expression RPAREN", $$->getName(), false);
		delete $2;		
	}
	| CONST_INT
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE, $1->getName(), "");
		$$->isNumber = true;
		printLog("factor : CONST_INT", $$->getName(), false);
		delete $1;	
	} 
	| CONST_FLOAT
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE, $1->getName(), "");
		$$->isNumber = true;
		printLog("factor : CONST_FLOAT", $$->getName(), false);
		delete $1;	
	}
	| variable INCOP
	{
	 	string newName = $1->getName() + "++";
	 	string tempVar = getDstAddressForUnary($2);
	 	
	 	string code = getAsmOfUnary($1);
	 	code += "add " + $1->getAsmSymbol() + ", 1\n";
	 	code += "mov " + tempVar + ", ax\n";
	 	
		$$ = new SymbolInfo(newName, "factor", $1->getDataType(), $1->getAttribute(), tempVar, code);
		printLog("factor : variable INCOP", $$->getName(), false);
		delete $1;	
	} 
	| variable DECOP
	{
	 	string newName = $1->getName() + "--";
	 	string tempVar = getDstAddressForUnary($2);
	 	
	 	string code = getAsmOfUnary($1);
	 	code += "sub " + $1->getAsmSymbol() + ", 1\n";
	 	code += "mov " + tempVar + ", ax\n";
	 	
		$$ = new SymbolInfo(newName, "factor", $1->getDataType(), $1->getAttribute(), tempVar, code);
		printLog("factor : variable DECOP", $$->getName(), false);
		delete $1;		
	}
	| NUMBER_ERR
	{
		$$ = new SymbolInfo($1->getName(), "factor", $1->getDataType(), VARIABLE, "", "");
	} 
	;
	
argument_list : arguments
			  {
					$$ = new SymbolInfo($1->getName(), "argument_list", "undefined", UNDEFINED, "", $1->getCode());
					printLog("argument_list : arguments", $$->getName(), false);
					delete $1;			  
			  }
			  |
			  {
					$$ = new SymbolInfo("", "argument_list", "undefined", UNDEFINED, "", "");
					printLog("argument_list :", $$->getName(), false);			  
			  }
			  ;
	
arguments : arguments COMMA logic_expression
		  {
	      		SymbolInfo* expSymbol = new SymbolInfo($3->getName(), $3->getType(), $3->getDataType(),
	      												$3->getAttribute(), $3->getAsmSymbol(), $3->getCode());
	      		argumentsInfo.push_back(expSymbol);		  
		  
			 	string newName = $1->getName() + "," + $3->getName();
			 	string code = $3->getCode()	+ $1->getCode();
				$$ = new SymbolInfo(newName, "arguments", "undefined", UNDEFINED, "", code);
				
				printLog("arguments : arguments COMMA logic_expression", $$->getName(), false);
				delete $1; delete $3;		  
		  }
	      | logic_expression
	      {
	      		argumentsInfo.clear();
	      		SymbolInfo* expSymbol = new SymbolInfo($1->getName(), $1->getType(), $1->getDataType(),
	      												$1->getAttribute(), $1->getAsmSymbol(), $1->getCode());
	      		argumentsInfo.push_back(expSymbol);
				$$ = new SymbolInfo($1->getName(), "arguments", "undefined", UNDEFINED, "", $1->getCode());
				printLog("arguments : logic_expression", $$->getName(), false);
				delete $1;			      
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
	asmFile.open("code.asm", ios::out);
    optimizedAsmFile.open("optimized_code.asm", ios::out);
	
	symbolTable->enterScope(30, "global");

	yyin= fin;
	yyparse();
	
	fclose(yyin);
	
	logFile.close();
	errorFile.close();
	asmFile.close();
    optimizedAsmFile.close();
	
	return 0;
}
		  			       
