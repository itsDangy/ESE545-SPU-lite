#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
#include <vector>
#include <tuple>
#include <sstream>
#include <bitset>
#include <algorithm>
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

string toBin(string str){
    string bin;
    if("0x" != str.substr(0,2))
        return bitset<18>(stoi(str)).to_string();

    unordered_map<char, string> hex_to_bin_dict {
        {'0', "0000"}, {'1', "0001"}, {'2', "0010"}, {'3', "0011"},
        {'4', "0100"}, {'5', "0101"}, {'6', "0110"}, {'7', "0111"},
        {'8', "1000"}, {'9', "1001"}, {'A', "1010"}, {'B', "1011"},
        {'C', "1100"}, {'D', "1101"}, {'E', "1110"}, {'F', "1111"}
    };

    for (char digit : str) {
        bin += hex_to_bin_dict[toupper(digit)];
    }
    return bin;
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

    char const* digits = "0123456789";

    while(getline(AssemblyCode,line)){
        stringstream ss(line);
        string op;
        ss >> op;
        cout << op << endl;

        if(op.empty() || op == "\n" || op.find("#") != std::string::npos) {
            continue;
        }
        if(op == "stop"){
            MachineCode << "00000000000000000000000000000000"<<endl;
            continue;
        }
        if(op == "nop"){
            MachineCode << "01000000001000000000000000000000"<<endl;
            continue;
        }
        if(op == "lnop"){
            MachineCode << "00000000001000000000000000000000"<<endl;
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
        cout << format <<endl;

        string arg1 = "\0", arg2 = "\0", arg3 = "\0", arg4 = "\0";
        int reg1 = 0, reg2 = 0, reg3 = 0, reg4 = 0;

        getline(ss, arg1, ',');
        getline(ss, arg2, ',');
        getline(ss, arg3, ',');
        getline(ss, arg4, ',');

        cout << arg1 << " " << arg2 << " " <<arg3 << " " <<arg4 << " " <<endl;

        if(arg1 != "\0")
            reg1 = stoi(arg1.substr(arg1.find_first_of(digits)));
        if(arg2 != "\0")
            reg2 = stoi(arg2.substr(arg2.find_first_of(digits)));
        if(arg3 != "\0")
            reg3 = stoi(arg3.substr(arg3.find_first_of(digits)));
        if(arg4 != "\0")
            reg4 = stoi(arg4.substr(arg4.find_first_of(digits)));

        if(format.find("RR") != std::string::npos){
            MachineCode << (bitset<7>(reg3)).to_string();
            MachineCode << bitset<7>(reg2).to_string();
            MachineCode << bitset<7>(reg1).to_string()<<endl;
        }
        else if(format.find("RRR") != std::string::npos){
            MachineCode << bitset<7>(reg1).to_string();
            MachineCode << bitset<7>(reg3).to_string();
            MachineCode << bitset<7>(reg2).to_string();
            MachineCode << bitset<7>(reg4).to_string()<<endl;
        }
        else if(format.find("RI7") != std::string::npos){
            //arg3 has immediate
            MachineCode << toBin(arg3).substr(toBin(arg3).size() - 7);
            MachineCode << bitset<7>(reg2).to_string();
            MachineCode << bitset<7>(reg1).to_string()<<endl;
        }
        else if(format.find("RI10") != std::string::npos){
            //arg3 has immediate
            MachineCode << toBin(arg3).substr(toBin(arg3).size() - 10);
            MachineCode << bitset<7>(reg2).to_string();
            MachineCode << bitset<7>(reg1).to_string()<<endl;
        }
        else if(format.find("RI16") != std::string::npos){
            //arg2 has immediate
            MachineCode << toBin(arg2).substr(toBin(arg2).size() - 16);
            MachineCode << bitset<7>(reg1).to_string()<<endl;
        }
        else if(format.find("RI18") != std::string::npos){
            //arg2 has immediate
            MachineCode << toBin(arg2).substr(toBin(arg2).size() - 18);
            MachineCode << bitset<7>(reg1).to_string()<<endl;
        }
        else if(format.find("?") != std::string::npos){
            
        }
        else{
            MachineCode << "00000000000000000000000000000000"<<endl;
        }
    }

}