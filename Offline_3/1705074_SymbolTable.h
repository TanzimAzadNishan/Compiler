
class SymbolTable{
    ScopeTable* currentScopeTable;
public:

    SymbolTable(){
        currentScopeTable = NULL;
    }
    void enterScope(int totalBuckets){
        ScopeTable* scopeTable = new ScopeTable(totalBuckets);

        if(currentScopeTable != NULL){
            scopeTable->setParentScopeTable(currentScopeTable);
        }
        scopeTable->generateId();
        currentScopeTable = scopeTable;

        string currId = scopeTable->getId();

        if(currId != "1"){
            //fout<<"New ScopeTable with id "<< currId << " created" << endl << endl;
            logFile<<"New ScopeTable with id "<< currId << " created" << endl << endl;
        }
    }
    void exitScope(){
        ScopeTable* tempTable = currentScopeTable;

        if(currentScopeTable != NULL){
            currentScopeTable = currentScopeTable->getParentScopeTable();

            //fout<<"ScopeTable with id "<<tempTable->getId()<<" removed"<<endl << endl;
            logFile<<"ScopeTable with id "<<tempTable->getId()<<" removed"<<endl << endl;
            ///delete tempTable;

            currentScopeTable->increaseDeletedChilds();

        }
    }

    bool Insert(string name, string type, string dataType, Attribute attribute){
        if(currentScopeTable->Insert(name, type, dataType, attribute)){
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
