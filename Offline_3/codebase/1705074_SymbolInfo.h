
class SymbolInfo{
    string name;
    string type;
    string dataType;
    SymbolInfo* nextSymbolInfo;
    vector<SymbolInfo*> parameterList;
    int arrSize;
    Attribute attribute;

public:
    SymbolInfo(string name, string type, string dataType, Attribute attribute){
        this->name = name;
        this->type = type;
        this->dataType = dataType;
        this->nextSymbolInfo = NULL;
        this->parameterList.resize(0);
        this->attribute = attribute;
    }

    SymbolInfo(string name, string type, string dataType){
        this->name = name;
        this->type = type;
        this->dataType = dataType;
    }

    SymbolInfo(string name, string type){
        this->name = name;
        this->type = type;
    }
    SymbolInfo(string dataType, Attribute attribute){
        this->dataType = dataType;
        this->attribute = attribute;
    }

    void setNextSymbolInfo(SymbolInfo* symbolInfo){
        this->nextSymbolInfo = symbolInfo;
    }
    void setDataType(string dataType){
        this->dataType = dataType;
    }

    void setArraySize(int arrSize){
        this->arrSize = arrSize;
    }

    string getName(){
        return name;
    }
    string getType(){
        return type;
    }
    string getDataType(){
        return dataType;
    }
    int getArraySize(){
        return arrSize;
    }
    Attribute getAttribute(){
        return attribute;
    }

    int getNoOfParamters(){
        return parameterList.size();
    }

    void setParameterList(vector<SymbolInfo*> parametersInfo){
        this->parameterList.resize(parametersInfo.size());
        this->parameterList = parametersInfo;
    }


    vector<SymbolInfo*> getParameterList(){
        return parameterList;
    }

    SymbolInfo* getNextSymbolInfo(){
        return nextSymbolInfo;
    }
    ~SymbolInfo(){
        nextSymbolInfo = NULL;
    }
};


