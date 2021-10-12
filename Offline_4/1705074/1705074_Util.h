
string getTempVar(string asmSymbol1, string asmSymbol2, bool isNum1, bool isNum2, bool willPush = true){
 	if(!isNum1 && asmSymbol1 != "" && asmSymbol1.at(0) == 't'){
        //symbolTable->getCurrentScopeTable()->localTempVars.push(asmSymbol1);
 		return asmSymbol1;
 	}
 	else if(!isNum2 && asmSymbol2 != "" && asmSymbol2.at(0) == 't'){
        //symbolTable->getCurrentScopeTable()->localTempVars.push(asmSymbol2);
 		return asmSymbol2;
 	}
 	else{
        string tempVar = "";
		if(symbolTable->reusableVar.size() == 0){
            tempVar = newTemp();
		}
        else{
            tempVar = *(symbolTable->reusableVar.begin());
            symbolTable->reusableVar.erase(tempVar);
		}

        if(willPush){
            symbolTable->getCurrentScopeTable()->localTempVars.insert(tempVar);
        }
		return tempVar;
 	}
}


void freeTempVarOfCurrScope(){
    ScopeTable* currScopeTable = symbolTable->getCurrentScopeTable();
    set<string>::iterator it;

    for (it = currScopeTable->localTempVars.begin(); it != currScopeTable->localTempVars.end(); it++){
        symbolTable->reusableVar.insert(*it);
    }

    currScopeTable->localTempVars.clear();

    /*while(!currScopeTable->localTempVars.empty()){
        symbolTable->reusableVar.insert(currScopeTable->localTempVars.front());
        currScopeTable->localTempVars.pop();
    }*/
}



void freeTempVarAfterExpression(string symbol){
    if(symbol != "" && symbol.at(0) == 't'){
        symbolTable->reusableVar.insert(symbol);
    }
}


string getDstAddressForUnary(SymbolInfo* symbol){
    string tempVar = "";

    if(symbol->getAttribute() == FUNCTION){
        tempVar = getTempVar("", "", false, false);
    }
    else{
        tempVar = getTempVar(symbol->getAsmSymbol(), "", symbol->isNumber, false);
    }

    return tempVar;
}


string getDstAddress(SymbolInfo* symbol1, SymbolInfo* symbol2){
    string tempVar = "";

    if(symbol1->getAttribute() == FUNCTION && symbol2->getAttribute() == FUNCTION){
        tempVar = getTempVar("", "", false, false);
    }
    else if(symbol1->getAttribute() == FUNCTION){
        tempVar = getTempVar("", symbol2->getAsmSymbol(), false, symbol2->isNumber);
    }
    else if(symbol2->getAttribute() == FUNCTION){
        tempVar = getTempVar(symbol1->getAsmSymbol(), "", symbol1->isNumber, false);
        //tempVar = newTemp();
        //symbolTable->getCurrentScopeTable()->localTempVars.insert(tempVar);
    }
    else{
        tempVar = getTempVar(symbol1->getAsmSymbol(), symbol2->getAsmSymbol(), symbol1->isNumber, symbol2->isNumber);
    }
    return tempVar;
}






