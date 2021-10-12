

string getTempVar(string asmSymbol1, string asmSymbol2, bool isNum1, bool isNum2){
 	if(!isNum1 && asmSymbol1 != "" && asmSymbol1.at(0) == 't'){
 		return asmSymbol1;
 	}
 	else if(!isNum2 && asmSymbol2 != "" && asmSymbol2.at(0) == 't'){
 		return asmSymbol2;
 	}
 	else{
		if(symbolTable->reusableVar.size() == 0){
            string tempVar = newTemp();
            symbolTable->getCurrentScopeTable()->localTempVars.push(tempVar);
			return tempVar;
		}

		string tempVar = symbolTable->reusableVar.front();
		symbolTable->reusableVar.pop();
		return tempVar;
 	}
}

void freeTempVarOfCurrScope(){
    /*ScopeTable* currScopeTable = symbolTable->getCurrentScopeTable();

    while(!currScopeTable->localTempVars.empty()){
        symbolTable->reusableVar.push(currScopeTable->localTempVars.front());
        currScopeTable->localTempVars.pop();
    }*/
}


string appendStackDataSegment(){
	string code = "";
	code += ".MODEL SMALL\n\n";
	code += ".STACK 100H\n\n";
	code += ".DATA\n\n";

	while(!symbolTable->dataSegment.empty()){
		string varName = symbolTable->dataSegment.front().first;
		int length = symbolTable->dataSegment.front().second.second;

		if(length == 0){
			code += varName + " DW ?\n";
		}
		else{
			code += varName + " DW " + to_string(length) + " DUP (?)\n";
		}
		symbolTable->dataSegment.pop();
	}
	for(int i = 0; i < tempCount; i++){
		code += "t" + to_string(i) + " DW ?\n";
	}

	code += "\n\n";
	return code;
}


string getAsmOfPrintln(){

	string code = "println proc\n\n";
	code += "push ax \npush bx \npush cx \npush dx \npush bp \n";

    code += "mov bp, sp\n";
    code += "mov ax, [bp+12]\n";

	code += "mov bx, ax\n";
	code += "or bx, bx\n";
	code += "jge Take_Remainder\n";
	code += "neg bx\n";
	code += "mov ah, 2\n";
	code += "mov dl, 2DH\n";
	code += "int 21H\n";
	code += "mov dx, 0\n";
	code += "mov cx, 0\n";
	code += "mov ax, bx\n";

	code += "Take_Remainder:\n\n";
	code += "cmp cx, 0\n";
	code += "je Divide\n\n";
	code += "cmp ax, 0\n";
	code += "je Display\n\n";
	code += "Divide:\n";
	code += "mov bx, 10\n";
	code += "div bx\n";
	code += "push dx\n";
	code += "inc cx\n";
	code += "xor dx, dx\n";
	code += "jmp Take_Remainder\n\n";
	code += "Display:\n";
	code += "mov ah, 2\n\n";
	code += "Pop_and_Print:\n";
	code += "pop dx\n";
	code += "add dx, 48D\n";
	code += "int 21h\n";
	code += "loop Pop_and_Print\n";
	code += "mov dl, 0Ah\n";
	code += "int 21h\n";
	code += "mov dl, 0Dh\n";
	code += "int 21h\n";
	code += "pop bp \npop dx \npop cx \npop bx \npop ax \n";
	code += "ret 2\n";
	code += "println endp\n\n";

	return code;
}


string getAsmOfFunctionCall(SymbolInfo* idSymbol, SymbolInfo* argSymbol){
    string code = argSymbol->getCode();
    string asmSymbol = idSymbol->getAsmSymbol();

    if(idSymbol->getFuncAsmSymbol() == "si"){
        if(asmSymbol != ""){
            code += "mov si, " + idSymbol->getAsmSymbol() + "\n";
        }
        code += "push " + idSymbol->getFuncAsmSymbol() + "\n";
    }
    else{
        if(idSymbol->getDataType() != "void"){
            idSymbol->setFuncAsmSymbol("si");

            if(asmSymbol == ""){
                asmSymbol = getTempVar("", "", false, false);
                idSymbol->setAsmSymbol(asmSymbol);
            }
        }
    }

    for(int i = 0; i < argumentsInfo.size(); i++){
        code += "push " + argumentsInfo[i]->getAsmSymbol() + "\n";

        /*if(argumentsInfo[i]->getAsmSymbol().at(0) == 't'){
            symbolTable->reusableVar.push(argumentsInfo[i]->getAsmSymbol());
        }*/
    }

    code += "call " + idSymbol->getName() + "\n";

    return code;
}


string getAsmOfReturn(SymbolInfo* symbol){
    string scopeName = symbolTable->getCurrentScopeTable()->getName();
    string code = symbol->getCode();

    if(scopeName == "undefined"){
        code += "ret\n\n";
    }
    else{
        code += "mov ax, " + symbol->getAsmSymbol() + "\n";
        code += "jmp ret_" + scopeName + "\n";
    }

    return code;
}


string getAsmOfParameterizeFunction(SymbolInfo* funcSymbol, SymbolInfo* statementSymbol){
    string code = funcSymbol->getName() + " proc\n\n";
    string tempVar = "";
    code += "push ax \npush bx \npush cx \npush dx \npush bp \n";
    code += "mov bp, sp\n";
    code += statementSymbol->getCode();

    SymbolInfo* currentFuncSymbol = symbolTable->Lookup(funcSymbol->getName());

    /*if(currentFuncSymbol->getDataType() != "void"){
        tempVar = getTempVar("", "", false, false);
        currentFuncSymbol->setAsmSymbol(tempVar);
    }*/

    string returnLabel = "ret_" + funcSymbol->getName();
    code += returnLabel + ":\n";

    /*if(currentFuncSymbol->getFuncAsmSymbol() != ""){
        code += "mov " + currentFuncSymbol->getFuncAsmSymbol() + ", ax\n";
    }*/

    string curFuncAsmSymbol = currentFuncSymbol->getFuncAsmSymbol();
    if(currentFuncSymbol->getAsmSymbol() == ""){
        currentFuncSymbol->setAsmSymbol(getTempVar("", "", false, false));
    }
    //currentFuncSymbol->setFuncAsmSymbol(getTempVar("", "", false, false));
    currentFuncSymbol->setFuncAsmSymbol(currentFuncSymbol->getAsmSymbol());

    if(curFuncAsmSymbol != "si"){
        code += "mov " + currentFuncSymbol->getFuncAsmSymbol() + ", ax\n";
    }
    else{
        code += "mov si, ax\n";
        code += "mov " + currentFuncSymbol->getFuncAsmSymbol() + ", ax\n";
        //currentFuncSymbol->setAsmSymbol(currentFuncSymbol->getFuncAsmSymbol());
    }

    code += "pop bp \npop dx \npop cx \npop bx \npop ax \n";
    code += "ret " + to_string(currentFuncSymbol->getNoOfParamters() * 2) + "\n\n";
    code += funcSymbol->getName() + " endp\n\n";

    currentFuncSymbol->setFuncAsmSymbol("");

    return code;
}


string getAsmOfUnary(SymbolInfo* symbol1){
    string code = symbol1->getCode();

    /// first operand is array (b[5] < 3)
    if(symbol1->baseProperty == ARRAY){
        code += "mov ax, "+ symbol1->getAsmSymbol() + "[bx]\n";
    }
    /// first operand is a variable (c > d) / number (5 < c)
    else{
        code += "mov ax, " + symbol1->getAsmSymbol() + "\n";
    }

    return code;
}


string getAsmOfALU(SymbolInfo* symbol1, SymbolInfo* symbol2){
    string scopeName = symbolTable->getCurrentScopeTable()->getName();
    string code = symbol1->getCode() + symbol2->getCode();

    SymbolInfo* curIdSymbol = symbolTable->Lookup(scopeName);
    string funcAsmSymbol = curIdSymbol->getFuncAsmSymbol();

    if(curIdSymbol->getAttribute() == FUNCTION && funcAsmSymbol == "si" && symbol1->getAttribute() == FUNCTION
            && symbol2->getAttribute() == FUNCTION){

        code += "pop di\n";
        code += "mov ax, di\n";
        code += "mov bx, si\n";
    }

    else{
        /// first operand is array (b[5] < 3)
        if(symbol1->baseProperty == ARRAY){
            code += "mov ax, "+ symbol1->getAsmSymbol() + "[bx]\n";
        }
        /// first operand is a variable (c > d) / number (5 < c)
        else{
            code += "mov ax, " + symbol1->getAsmSymbol() + "\n";
        }

        //code += symbol2->getCode();
        /// second operand is array (3 < b[5])
        if(symbol2->baseProperty == ARRAY){
            code += "mov cx, bx\n";
            code += "mov bx, "+ symbol2->getAsmSymbol() + "[cx]\n";
        }
        /// second operand is a variable (c > d) / number (5 < 7)
        else{
            code += "mov bx, " + symbol2->getAsmSymbol() + "\n";
        }
    }

    return code;
}


string getAsmOfAssignment(SymbolInfo* symbol1, SymbolInfo* symbol2){
    string code = "";

    /// for assignment operation
    code += symbol2->getCode();

    /// second operand is array (b[5] = 3)
    if(symbol2->baseProperty == ARRAY){
        code += "mov ax, "+ symbol2->getAsmSymbol() + "[bx]\n";
    }
    /// first operand is a variable and second operand is a number (c = 5)
    else if(symbol1->baseProperty != ARRAY && symbol2->isNumber){
        code += "mov ax, " + symbol2->getAsmSymbol() + "\n";
        code += "mov " + symbol1->getAsmSymbol() + ", ax\n";
        //code += "mov " + symbol1->getAsmSymbol() + ", " + symbol2->getAsmSymbol()+"\n";
    }
    /// second operand is a variable (c = d)
    else{
        code += "mov ax, " + symbol2->getAsmSymbol() + "\n";
    }

    code += symbol1->getCode();

    /// first operand is array (a[4] = c)
    if(symbol1->baseProperty == ARRAY){
        code += "mov "+ symbol1->getAsmSymbol() + "[bx], ax\n";
    }
    /// first operand is a variable. (c = d)
    else if(symbol1->baseProperty == VARIABLE && !symbol2->isNumber){
        code += "mov " + symbol1->getAsmSymbol() + ", ax\n";
    }

    if(!symbol2->isNumber && symbol2->getAsmSymbol() != "" && symbol2->getAsmSymbol().at(0) == 't'){
        symbolTable->reusableVar.push(symbol2->getAsmSymbol());
    }

    return code;
}





