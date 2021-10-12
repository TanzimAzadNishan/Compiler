
string appendSingleInstruction(vector<string> instParts){
    string code = "";

    for(auto segItr = instParts.begin(); segItr != instParts.end(); segItr++){
        code += *segItr + " ";
    }
    code += "\n";

    return code;
}


string generateOptimizedAsmCode(string code){
    string optCode = "";
    string tempCode = "";
    stringstream ss(code);
    vector<string> instructions;
    vector<vector<string>> instSegments;

    while(getline(ss, tempCode, '\n')){
        instructions.push_back(tempCode);
    }

    for(auto it = instructions.begin(); it != instructions.end(); it++){
        vector<string> singleInstSeg;
        string inst = *it;
        stringstream ss(inst);

        while(getline(ss, tempCode, ' ')){
            singleInstSeg.push_back(tempCode);
        }
        instSegments.push_back(singleInstSeg);
    }

    //cout << instSegments.size() << " " <<instructions.size() << endl;

    for(auto insItr = instSegments.begin(); insItr != instSegments.end(); insItr++){

        if((*insItr).size() != 0 && insItr == instSegments.end()){
            code += appendSingleInstruction((*insItr));
        }

        else if((*insItr).size() != 0 && (*(insItr + 1)).size() != 0){

            string inst1 = (*insItr).at(0);
            string inst2 = (*(insItr + 1)).at(0);
            string var11 = "";

            if((*insItr).size() > 1){
                var11 = (*insItr).at(1);

                if(var11.at(var11.size() - 1) == ','){
                    var11.pop_back();
                }
            }

            if(inst1 == "mov" && var11 == "bx" && (*insItr).at(2) == "1" && (inst2 == "mul" || inst2 == "div")){
                insItr++;
            }
            else if(inst1 == "mov" && var11 == "bx" && (*insItr).at(2) == "0" && (inst2 == "add" || inst2 == "sub")
                && (*(insItr + 1)).at(1) != "bx,"){

                insItr++;
            }

            else if(inst1 == "mov" && inst2 == "mov"){

                string var12 = (*insItr).at(2);
                string var21 = (*(insItr + 1)).at(1);
                string var22 = (*(insItr + 1)).at(2);

                if(var21.at(var21.size() - 1) == ','){
                    var21.pop_back();
                }

                if(var11 == var22 && var12 == var21){
                    optCode += appendSingleInstruction((*insItr));
                    insItr++;
                }
                else{
                    optCode += appendSingleInstruction((*insItr));
                }
            }

            else{
                optCode += appendSingleInstruction((*insItr));
            }
        }
        else{
            optCode += appendSingleInstruction((*insItr));
        }
    }

    return optCode;
}



string appendStackDataSegment(){
	string code = "";
	code += ".MODEL SMALL\n\n";
	code += ".STACK 100H\n\n";
	code += ".DATA\n\n";

    while(!symbolTable->userDefFuncAddr.empty()){
        string varName = symbolTable->userDefFuncAddr.front();
        symbolTable->userDefFuncAddr.pop();
        code += varName + " DW ?\n";
    }

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
    string scopeName = symbolTable->getCurrentScopeTable()->getName();

    if(scopeName == idSymbol->getName()){
        if(idSymbol->getAsmSymbol() == ""){
            string tempVar = getTempVar("", "", false, false, false);
            idSymbol->setAsmSymbol(tempVar);
        }

        code += "mov cx, " + idSymbol->getFuncReturnAsmSymbol() + "\n";
        code += "mov " + idSymbol->getAsmSymbol() + ", cx\n";
    }


    for(int i = 0; i < argumentsInfo.size(); i++){
        code += "push " + argumentsInfo[i]->getAsmSymbol() + "\n";

        if(argumentsInfo[i]->getAsmSymbol().at(0) == 't'){
            symbolTable->reusableVar.insert(argumentsInfo[i]->getAsmSymbol());
        }
    }

    code += "call " + idSymbol->getName() + "\n";

    if(scopeName == idSymbol->getName()){
        code += "mov cx, " + idSymbol->getAsmSymbol() + "\n";
        code += "mov " + idSymbol->getFuncReturnAsmSymbol() + ", cx\n";
    }

    return code;
}


string getAsmOfReturn(SymbolInfo* symbol){
    string scopeName = symbolTable->getCurrentScopeTable()->getName();
    string code = symbol->getCode();

    if(scopeName == "undefined"){
        code += "ret\n\n";
    }
    else{
        if(symbol->getAttribute() == FUNCTION){
            code += "pop di\n";
            code += "mov ax, di\n";
        }
        else{
            code += "mov ax, " + symbol->getAsmSymbol() + "\n";
        }
        code += "jmp ret_" + scopeName + "\n";
    }

    return code;
}


string getAsmOfNonParamFunction(SymbolInfo* funcSymbol, SymbolInfo* statementSymbol){
    SymbolInfo* currentFuncSymbol = symbolTable->Lookup(funcSymbol->getName());
    string code = "";
    string returnLabel = "ret_" + currentFuncSymbol->getName();

    if(currentFuncSymbol->getName() != "main"){
        symbolTable->userDefFuncAddr.push(currentFuncSymbol->getFuncReturnAsmSymbol());
    }

    if(currentFuncSymbol->getName() == "main"){
        code += "MAIN proc\n\n";
        code += ";initialize DS\n";
        code += "MOV AX, @DATA\n";
        code += "MOV DS, AX\n";
    }
    else{
        code += currentFuncSymbol->getName() + " proc\n\n";
        code += "pop " + currentFuncSymbol->getFuncReturnAsmSymbol() + "\n\n";
        code += "push ax \npush bx \npush cx \npush dx \npush si \npush di \npush bp \n";
        code += "mov bp, sp\n";

        if(currentFuncSymbol->getAsmSymbol() != ""){
            code += "push " + currentFuncSymbol->getAsmSymbol() + "\n";
        }
    }

    code += statementSymbol->getCode() + "\n";
    code += returnLabel + ":\n";

    if(currentFuncSymbol->getName() == "main"){
        code += "MOV AH, 4CH\n";
        code += "INT 21H\n";
        code += "ret\n\n";
        code += "MAIN endp\n\n";
    }
    else{
        code += "mov si, ax\n";
        if(currentFuncSymbol->getAsmSymbol() != ""){
            code += "pop " + currentFuncSymbol->getAsmSymbol() + "\n";
        }
        code += "pop bp \npop di \npop si \npop dx \npop cx \npop bx \npop ax \n";
        code += "push si\n";
        code += "push " + currentFuncSymbol->getFuncReturnAsmSymbol() + "\n";
        code += "ret\n\n";
        code += currentFuncSymbol->getName() + " endp\n\n";
    }
    return code;
}


string getAsmOfParameterizedFunction(SymbolInfo* funcSymbol, SymbolInfo* statementSymbol){
    SymbolInfo* currentFuncSymbol = symbolTable->Lookup(funcSymbol->getName());

    symbolTable->userDefFuncAddr.push(currentFuncSymbol->getFuncReturnAsmSymbol());

    string code = funcSymbol->getName() + " proc\n\n";

    code += "pop " + currentFuncSymbol->getFuncReturnAsmSymbol() + "\n\n";
    code += "push ax \npush bx \npush cx \npush dx \npush bp \n";
    code += "mov bp, sp\n";

    if(currentFuncSymbol->getAsmSymbol() != ""){
        code += "push " + currentFuncSymbol->getAsmSymbol() + "\n";
    }
    code += statementSymbol->getCode();

    string returnLabel = "ret_" + funcSymbol->getName();
    code += returnLabel + ":\n";
    code += "mov si, ax\n";

    if(currentFuncSymbol->getAsmSymbol() != ""){
        code += "pop " + currentFuncSymbol->getAsmSymbol() + "\n";
    }
    code += "pop bp \npop dx \npop cx \npop bx \npop ax \n\n";

    for(int i = 1; i <= currentFuncSymbol->getNoOfParamters(); i++){
        code += "pop ax\n";
    }

    code += "\npush si\n";
    code += "push " + currentFuncSymbol->getFuncReturnAsmSymbol() + "\n";
    code += "ret\n\n";
    code += funcSymbol->getName() + " endp\n\n";

    return code;
}


string getAsmOfUnary(SymbolInfo* symbol1){
    string code = symbol1->getCode();

    if(symbol1->getAttribute() == FUNCTION){
        code += "pop di\n";
        code += "mov ax, di\n";
    }
    /// first operand is array (b[5] < 3)
    else if(symbol1->baseProperty == ARRAY){
        code += "mov ax, "+ symbol1->getAsmSymbol() + "[bx]\n";
    }
    /// first operand is a variable (c > d) / number (5 < c)
    else{
        code += "mov ax, " + symbol1->getAsmSymbol() + "\n";
    }

    return code;
}


string getAsmOfALU(SymbolInfo* symbol1, SymbolInfo* symbol2){
    //string scopeName = symbolTable->getCurrentScopeTable()->getName();
    //string code = symbol1->getCode() + symbol2->getCode();
    string code = symbol1->getCode();

    if(symbol1->baseProperty == ALU && symbol2->getAttribute() == FUNCTION){
        code += "push " + symbol1->getAsmSymbol() + "\n";
    }
    code +=  symbol2->getCode();

    if(symbol1->baseProperty == ALU && symbol2->getAttribute() == FUNCTION){
        code += "pop " + symbol1->getAsmSymbol() + "\n";
    }

    if(symbol1->getAttribute() == FUNCTION){
        code += "pop di\n";
        code += "mov ax, di\n";
    }
    /// first operand is array (b[5] < 3)
    else if(symbol1->baseProperty == ARRAY){
        code += "mov ax, "+ symbol1->getAsmSymbol() + "[bx]\n";
    }
    /// first operand is a variable (c > d) / number (5 < c)
    else{
        code += "mov ax, " + symbol1->getAsmSymbol() + "\n";
    }


    if(symbol2->getAttribute() == FUNCTION){
        code += "pop di\n";
        code += "mov bx, di\n";
    }
    /// second operand is array (3 < b[5])
    else if(symbol2->baseProperty == ARRAY){
        code += "mov cx, bx\n";
        code += "mov bx, "+ symbol2->getAsmSymbol() + "[cx]\n";
    }
    /// second operand is a variable (c > d) / number (5 < 7)
    else{
        code += "mov bx, " + symbol2->getAsmSymbol() + "\n";
    }


    return code;
}


string getAsmOfAssignment(SymbolInfo* symbol1, SymbolInfo* symbol2){
    string code = "";

    /// for assignment operation
    code += symbol2->getCode();

    if(symbol2->getAttribute() == FUNCTION){
        code += "pop di\n";
        code += "mov ax, di\n";
    }
    /// second operand is array (b[5] = 3)
    else if(symbol2->baseProperty == ARRAY){
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

    if(/*!symbol2->isNumber && */symbol2->getAsmSymbol() != "" && symbol2->getAsmSymbol().at(0) == 't'){
        symbolTable->reusableVar.insert(symbol2->getAsmSymbol());
    }

    return code;
}


/*string wtiteAssembly(string programCode){

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
}*/



