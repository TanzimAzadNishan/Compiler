
class SymbolTable{
    ScopeTable* currentScopeTable;
    int noOfScopeTables;

public:
    queue<pair<string, pair<Attribute, int>>> dataSegment;
    queue<string> reusableVar;

    SymbolTable(){
        currentScopeTable = NULL;
        noOfScopeTables = 0;
    }
    void enterScope(int totalBuckets, string scopeName){
        ScopeTable* scopeTable = new ScopeTable(totalBuckets, scopeName);

        if(currentScopeTable != NULL){
            scopeTable->setParentScopeTable(currentScopeTable);
        }
        ///scopeTable->generateId();
        scopeTable->setId(noOfScopeTables++);
        currentScopeTable = scopeTable;

        int currId = scopeTable->getId();

        if(currId != 1){
            logFile<<"New ScopeTable with id "<< currId << " created" << endl << endl;
        }

        /*string currId = scopeTable->getId();

        if(currId != "1"){
            //fout<<"New ScopeTable with id "<< currId << " created" << endl << endl;
            logFile<<"New ScopeTable with id "<< currId << " created" << endl << endl;
        }*/
    }
    void exitScope(){
        ScopeTable* tempTable = currentScopeTable;

        if(currentScopeTable != NULL){
            currentScopeTable = currentScopeTable->getParentScopeTable();

            logFile<<"ScopeTable with id "<<tempTable->getId()<<" removed"<<endl << endl;
            //delete tempTable;

            ///currentScopeTable->increaseDeletedChilds();

        }
    }

    bool Insert(string name, string type, string dataType, Attribute attribute){
        /*string asmSymbol = name + to_string(noOfScopeTables);
        dataSegment.push({asmSymbol, {attribute, 0}});*/

        if(currentScopeTable->Insert(name, type, dataType, attribute)){
            return true;
        }

        return false;
    }

    bool Insert(string name, string type, string dataType, Attribute attribute, string arrSizeStr){
        string asmSymbol = name + to_string(noOfScopeTables);
        int arrSize = stoi(arrSizeStr);
        dataSegment.push({asmSymbol, {attribute, arrSize}});

        if(currentScopeTable->Insert(name, type, dataType, attribute, asmSymbol, "", arrSize)){
            return true;
        }

        return false;
    }

    bool Remove(string symbolName){
        if(currentScopeTable->Delete(symbolName)){
            return true;
        }
        return false;
    }

    SymbolInfo* Lookup(string symbolName){

        ScopeTable* lastScopeTable = currentScopeTable;

        while(lastScopeTable != NULL){
            SymbolInfo* searchedSymbolInfo =  lastScopeTable->Lookup(symbolName);

            if(searchedSymbolInfo != NULL){
                return searchedSymbolInfo;
            }

            lastScopeTable = lastScopeTable->getParentScopeTable();
        }

        //fout << "Not found" << endl << endl;

        return NULL;
    }
    void printCurrentScopeTable(){
        currentScopeTable->Print();
        //fout<<endl;
    }
    void printAllScopeTable(){
        ScopeTable* lastScopeTable = currentScopeTable;

        while(lastScopeTable != NULL){
            lastScopeTable->Print();
            lastScopeTable = lastScopeTable->getParentScopeTable();
            //fout<<endl<<endl;
            logFile<<endl;
        }
    }

    ScopeTable* getCurrentScopeTable(){
        return currentScopeTable;
    }

    ~SymbolTable(){
        if(currentScopeTable != NULL){
            delete currentScopeTable;
        }
        currentScopeTable = NULL;
    }
};
