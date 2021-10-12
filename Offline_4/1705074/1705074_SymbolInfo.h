
class SymbolInfo{
    string name;
    string type;
    string dataType;
    SymbolInfo* nextSymbolInfo;
    vector<SymbolInfo*> parameterList;
    int arrSize;
    Attribute attribute;  // denotes what type of value that symbol gives. Ex: a[5] is variable but a is array

    string asmSymbol = "";
    string funcReturnAsmSymbol = "";
    string code = "";
    int value;

public:
    bool isNumber = false;
    Attribute baseProperty = UNDEFINED;  // denotes what are we dealing with. Ex: Array, variable, function, ALU

    SymbolInfo(string name, string type, string dataType, Attribute attribute, string asmSymbol, string code){
        this->name = name;
        this->type = type;
        this->dataType = dataType;
        this->nextSymbolInfo = NULL;
        this->parameterList.resize(0);
        this->attribute = attribute;
        this->asmSymbol = asmSymbol;
        this->code = code;
    }

    SymbolInfo(string name, string type){
        this->name = name;
        this->type = type;
    }

    /*SymbolInfo(string name, string type, string dataType, Attribute attribute){
        this->name = name;
        this->type = type;
        this->dataType = dataType;
        this->nextSymbolInfo = NULL;
        this->parameterList.resize(0);
        this->attribute = attribute;
    }*/

    /*SymbolInfo(string name, string type, string dataType){
        this->name = name;
        this->type = type;
        this->dataType = dataType;
    }*/

    /*SymbolInfo(string dataType, Attribute attribute){
        this->dataType = dataType;
        this->attribute = attribute;
    }*/

    void setNextSymbolInfo(SymbolInfo* symbolInfo){
        this->nextSymbolInfo = symbolInfo;
    }
    void setDataType(string dataType){
        this->dataType = dataType;
    }

    void setArraySize(int arrSize){
        this->arrSize = arrSize;
    }

    void setAsmSymbol(string symbol){
        this->asmSymbol = symbol;
    }
    string getAsmSymbol(){
        return this->asmSymbol;
    }
    string getCode(){
        return this->code;
    }

    void setFuncReturnAsmSymbol(string symbol){
        this->funcReturnAsmSymbol = symbol;
    }
    string getFuncReturnAsmSymbol(){
        return this->funcReturnAsmSymbol;
    }

    void setValue(int value){
        this->value = value;
    }
    int getValue(){
        return this->value;
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


