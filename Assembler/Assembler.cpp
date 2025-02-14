#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
#include <vector>
#include <tuple>
#include <sstream>
using namespace std;

vector<tuple<string, string, string>> parseCSV(const string& filename) {
    vector<tuple<string, string, string>> data;
    ifstream file(filename);

    if (!file.is_open()) {
        cerr << "Error: Could not open file " << filename << endl;
        return data;
    }

    string line;
    while (getline(file, line)) {
        stringstream ss(line);
        string col1, col2, col3;

        // Parse columns (assuming CSV is well-formed)
        if (getline(ss, col1, ',') &&
            getline(ss, col2, ',') &&
            getline(ss, col3, ',')) {
            data.emplace_back(col1, col2, col3);
        }
    }

    file.close();
    return data;
}

int main(){
    ifstream AssemblyCode;
    ofstream MachineCode;
    AssemblyCode.open("../Assembly.txt");
    MachineCode.open("../MachineCode");
    if(!AssemblyCode.is_open() || !MachineCode.is_open())
        cerr << "File Error: Please check file path" << endl;

    vector<tuple<string,string,string>> Table = parseCSV("../Opcodes.csv"); //RR,RRR,RI7,RI10,RI16,RI18
    string line;
    while(getline(AssemblyCode,line)){
        stringstream ss(line);
        string op;
        getline(ss, op, ' ');

        if(op.empty() || op == "\n" || op.substr(0, 1) == "#") {
            continue;
        }
        if(op == "stop"){
            MachineCode << "00000000000000000000000000000000"<<endl;
            continue;
        }

        int index = 0;
        for(auto it : Table){
            if (op == (get<0>(it)))
                break;
            index++;
        }

        MachineCode << get<1>(Table[index]);
        string format = get<2>(Table[index]);
        string arg1 = '\0', arg2 = '\0', arg3 = '\0', arg4 = '\0';
        int reg1 = 0, reg2 = 0, reg3 = 0, reg4 = 0;

        getline(ss, arg1, ',');
        getline(ss, arg2, ',');
        getline(ss, arg3, ',');
        getline(ss, arg4, ',');

        reg1 = stoi(arg1);
        reg2 = stoi(arg2);
        reg3 = stoi(arg3);
        reg4 = stoi(arg4);

        if(format == "RR"){
            
        }
        else if(format == "RRR"){

        }
        else if(format == "RI7"){
            
        }
        else if(format == "RI10"){
            
        }
        else if(format == "RI16"){
            
        }
        else if(format == "RI18"){
            
        }
        else if(format == "?"){
            
        }
        else{

        }
    }

}