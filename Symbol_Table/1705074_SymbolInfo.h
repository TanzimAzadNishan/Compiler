
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
