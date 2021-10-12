#include<bits/stdc++.h>
using namespace std;

ofstream fout;
char operation;

#include "1705074_SymbolInfo.h"
#include "1705074_ScopeTable.h"
#include "1705074_SymbolTable.h"


int main(){

    int totalBuckets = 0;
    string name, type;

    ifstream fin;
    fin.open("input.txt");
    fout.open("output.txt", ios::out);

    fin >> totalBuckets;

    SymbolTable* symbolTable = new SymbolTable();
    symbolTable->enterScope(totalBuckets);

    while(!fin.eof()){
        fin >> operation;

        if(operation == 'I'){
            fin >> name;
            fin >> type;

            fout << "I " << name << " " << type << endl << endl;

            if(!symbolTable->Insert(name, type)){
                fout<<"<"<<name<<","<<type<<">"<<" already exists in current ScopeTable"
                    <<endl << endl;
            }
        }
        else if(operation == 'L'){
            fin >> name;

            fout << "L " << name << endl << endl;

            symbolTable->Lookup(name);
        }
        else if(operation == 'D'){
            fin >> name;

            fout << "D " << name << endl << endl;

            if(!symbolTable->Remove(name)){
                fout << "Not found" << endl << endl;
                fout << name << " not found" << endl << endl;
            }
        }
        else if(operation == 'P'){
            char code;
            fin >> code;

            fout << "P " << code << endl << endl << endl;

            if(code == 'A'){
                symbolTable->printAllScopeTable();
            }
            else if(code == 'C'){
                symbolTable->printCurrentScopeTable();
            }
        }
        else if(operation == 'S'){
            fout << "S"<< endl << endl;
            symbolTable->enterScope(totalBuckets);
        }
        else if(operation == 'E'){
            fout << "E"<< endl << endl;
            symbolTable->exitScope();
        }
        operation = ' ';
    }

    fin.close();
    fout.close();

    delete symbolTable;

    return 0;
}










