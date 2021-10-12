
class FunctionInfo{
    int noOfParam;
    vector<pair<string, string>> parameters;

public:
    FunctionInfo(int noOfParam, vector<pair<string, string>> parameters){
        this->noOfParam = noOfParam;

        this->parameters.resize(this->noOfParam);
        this->parameters = parameters;
    }

    int getNoOfParam(){
        return noOfParam;
    }

    vector<pair<string, string>> getParameterList(){
        return parameters;
    }

};








