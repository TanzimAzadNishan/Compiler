
class SymbolInfo{
    string name;
    string type;
    SymbolInfo* nextSymbolInfo;

public:
    SymbolInfo(string name, string type){
        this->name = name;
        this->type = type;
        this->nextSymbolInfo = NULL;
    }

    void setNextSymbolInfo(SymbolInfo* symbolInfo){
        this->nextSymbolInfo = symbolInfo;
    }
    string getName(){
        return name;
    }
    string getType(){
        return type;
    }
    SymbolInfo* getNextSymbolInfo(){
        return nextSymbolInfo;
    }
    ~SymbolInfo(){
        nextSymbolInfo = NULL;
    }
};




class ScopeTable{
    string id;
    vector<SymbolInfo*> firstEntries;
    int totalBuckets;
    ScopeTable* parentScopeTable;
    int noOfDeletedChilds;
    pair<SymbolInfo*, pair<int, int>> previousEntry;

    int getHash(string name){
        int sum_ascii = 0;

        for(int i = 0; i < name.size(); i++){
            sum_ascii += (int) name[i];
        }

        return sum_ascii % totalBuckets;
    }

public:

    ScopeTable(int n){
        totalBuckets = n;
        firstEntries.resize(n);
        parentScopeTable = NULL;
        noOfDeletedChilds = 0;
        previousEntry = {NULL, {-1, -1}};
    }

    void setParentScopeTable(ScopeTable* parentScopeTable){
        this->parentScopeTable = parentScopeTable;
    }

    void increaseDeletedChilds(){
        noOfDeletedChilds++;
    }

    void generateId(){
        if(parentScopeTable != NULL){
            this->id = parentScopeTable->id + "." + to_string(parentScopeTable->noOfDeletedChilds + 1);
        }
        else{
            this->id = "1";

        }
    }

    ScopeTable* getParentScopeTable(){
        return parentScopeTable;
    }
    int getTotalBuckets(){
        return totalBuckets;
    }
    string getId(){
        return id;
    }

    SymbolInfo* Lookup(string symbolName){
        int index = getHash(symbolName);

        if(index == -1){
            return NULL;
        }

        previousEntry = {NULL, {index, -1}};
        SymbolInfo* currSymbolInfo = firstEntries[index];
        int lastPos = -1;

        while(currSymbolInfo != NULL){
            if(currSymbolInfo->getName() == symbolName){

                /*if(operation != 'I'){
                    fout<<"Found in ScopeTable# "<<id<<" at position "<<index<<", "
                        <<previousEntry.second.second + 1<<endl << endl;
                }*/

                return currSymbolInfo;
            }

            lastPos++;
            previousEntry = {currSymbolInfo, {index, lastPos}};
            currSymbolInfo = currSymbolInfo->getNextSymbolInfo();
        }

        return NULL;
    }

    bool Insert(string name, string type){

        if(Lookup(name) == NULL){

            SymbolInfo* symbolInfo = new SymbolInfo(name, type);

            pair<int, int> position = previousEntry.second;
            int index = position.first;

            if(position.second == -1){
               firstEntries[index] = symbolInfo;
            }
            else{
                previousEntry.first->setNextSymbolInfo(symbolInfo);
            }

            /*fout<<"Inserted in ScopeTable# "<<id<<" at position "
                <<index<<", "<<position.second + 1<<endl << endl;*/

            return true;
        }
        return false;
    }

    bool Delete(string symbolName){
        SymbolInfo* searchedSymbolInfo = Lookup(symbolName);
        if(searchedSymbolInfo != NULL){

            pair<int, int> position = previousEntry.second;
            int index = position.first;
            SymbolInfo* nextSymbolInfo = searchedSymbolInfo->getNextSymbolInfo();

            if(position.second + 1 == 0){
                firstEntries[index] = nextSymbolInfo;
            }
            else{
                previousEntry.first->setNextSymbolInfo(nextSymbolInfo);
            }
            delete searchedSymbolInfo;
            searchedSymbolInfo = NULL;

            /*fout<<"Deleted Entry "<<index<<", "<<position.second + 1
                <<" from current ScopeTable"<<endl << endl;*/

            return true;
        }
        return false;
    }

    void Print(){
        //fout<<"ScopeTable # "<<id<<endl;
        ///logFile<<"ScopeTable # "<<id<<endl;

        for(int i = 0; i < firstEntries.size(); i++){
            //fout<<i<<" --> ";
            SymbolInfo* curSymbolInfo = firstEntries[i];

            if(curSymbolInfo == NULL){
                continue;
            }
            ///logFile<<" "<<i<<" --> ";

            while(curSymbolInfo != NULL){
                //fout<<"< "<<curSymbolInfo->getName()<<" : "<<curSymbolInfo->getType()<<">  ";
                ///logFile<<"< "<<curSymbolInfo->getName()<<" : "<<curSymbolInfo->getType()<<">  ";
                curSymbolInfo = curSymbolInfo->getNextSymbolInfo();
            }
            //fout<<endl;
            ///logFile<<endl;
        }
    }

    ~ScopeTable(){
        parentScopeTable = NULL;

        if(previousEntry.first != NULL){
            delete previousEntry.first;
        }
        previousEntry.first = NULL;

        for(int i = 0; i < firstEntries.size(); i++){
            SymbolInfo* curSymbolInfo = firstEntries[i];
            SymbolInfo* temp = firstEntries[i];

            while(curSymbolInfo != NULL && curSymbolInfo->getNextSymbolInfo() != NULL){
                temp = curSymbolInfo;
                curSymbolInfo = curSymbolInfo->getNextSymbolInfo();
                delete temp;
            }

            delete curSymbolInfo;
        }
        firstEntries.clear();
    }

};





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
        }
    }
    void exitScope(){
        ScopeTable* tempTable = currentScopeTable;

        if(currentScopeTable != NULL){
            currentScopeTable = currentScopeTable->getParentScopeTable();

            //fout<<"ScopeTable with id "<<tempTable->getId()<<" removed"<<endl << endl;
            ///delete tempTable;

            currentScopeTable->increaseDeletedChilds();

        }
    }

    bool Insert(string name, string type){
        if(currentScopeTable->Insert(name, type)){
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
            ///logFile<<endl;
        }
    }

    ~SymbolTable(){
        if(currentScopeTable != NULL){
            delete currentScopeTable;
        }
        currentScopeTable = NULL;
    }
};














