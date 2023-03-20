#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>
#include <regex>


using namespace std;

//function declaration
void readFile(string fileName, vector<string>& fileText);
void Display(vector<string> fileText);
int FindInsert(vector<string> fileText, string updateTable);
int FindSelect(vector<string> fileText, int mainInsert);
void VariablesSwap(int mainSelect, vector<string> fileText, string updateTable);
void Output(string str, int count, string updateTable);
int FindFrom(vector<string> fileText, int mainSelect);

int main() {
    //declare local variables
    string fileName;
    vector<string> fileText;
    int mainInsert;
    int mainSelect;
    int fromLocation;
    string updateTable;


    //get file from user
    cout<<"\nFile to convert:";
    cout << "SQLQuery15.sql for testing\n";
    //cin >> fileName;       //commented out for testing
    fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.sql";
    //fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.txt";

    readFile(fileName, fileText);

    //cout <<"Enter name of table to UPDATE:";
    //cin >> updateTable;       //commented out for testing
    updateTable = "tblCaseCharge";

    //Display the test in file
    //Display(fileText);
    
    //should be 5 for test file (SQLQuery15)
    mainInsert = FindInsert(fileText,  updateTable);

    //should be 227 for test file (SQLQuery15)
    mainSelect = FindSelect(fileText, mainInsert);

    //Function call to find the variables in each line.
    VariablesSwap(mainSelect, fileText, updateTable);

    fromLocation = FindFrom(fileText, mainSelect);


    return 0;
}

//Function to read the file to a vector of strings.
//Takes the fileName as a inputs and the fileText as a inputs by reference.
void readFile(string fileName, vector<string>& fileText){
    //declare local variables
    fstream fileIn; 
    string line;

    //open user provided file
    fileIn.open(fileName);
    assert(fileIn);
 
    //looping through file line by line
    while(!fileIn.eof()){
        getline(fileIn, line);
        fileText.push_back(line);      
    }
    fileIn.close();
}

//Funciton to find the main INSERT of the sql file.
//Takes the fileText and updateTable as inputs.
//This funciton currently works with 3 INSERT INTOs: INSERT INTO, insert into, Insert Into.
int FindInsert(vector<string> fileText, string updateTable){
    int mainInsert;

    for(int i=0; i<fileText.size(); i++){
        if(fileText[i] == "INSERT INTO " + updateTable || fileText[i] == "insert into " + updateTable || fileText[i] == "Insert into " + updateTable){
            mainInsert = i;
            //cout << "\nMainInsert: " <<  mainInsert <<endl;
            break;
        }
    }

    return mainInsert;
}

//Functino to find the main FROm of the sql file.
//Takes fileText and mainSelect as inputs.
//This function currently works with 3 Froms: FROM, From, and from.
int FindFrom(vector<string> fileText, int mainSelect){
    //defining local variables
    int fromLocation;

    //defining regular expressions for searching
    regex r("(?:^|\\W\\b)FROM(?:$|\\W\\b)");
    regex s("(?:^|\\W\\b)from(?:$|\\W\\b)");
    regex t("(?:^|\\W\\b)From(?:$|\\W\\b)");
    smatch m;

    //should be 452 for test file (SQLQuery15)
    for(int i=fileText.size(); i>mainSelect; i--){
        if(regex_search(fileText[i], m, r) || regex_search(fileText[i], m, s) || regex_search(fileText[i], m, t)){
            fromLocation = i;
            cout << "From Location: " << fromLocation << endl;
            cout << fileText[i] << endl;
            break;
        }
    }

    return fromLocation;
}

//Function to find the main SELECT of the sql file.
//Takes the fileText and mainInsert as inputs.
//This funciton currently works with 3 selects: SELECT, Select, select.
int FindSelect(vector<string> fileText, int mainInsert){
    int mainSelect;

    //defining regular expressions for searching
    regex r("\\s+SELECT");
    regex s("\\s+select");
    regex t("\\s+Select");
    smatch m;

    for(int j=mainInsert; j<fileText.size(); j++){
        if(regex_search(fileText[j], m, r) || regex_search(fileText[j], m, s) || regex_search(fileText[j], m, t)){
            mainSelect = j;
            //cout << "MainSelect: " << mainSelect << endl;
            break;
        }
    }

    return mainSelect;
}

//This function is uses to find and swap the location of the variables. 
//Takes mainSelect, fileText, updateTable as inputs.
//This funciton currently works with 3 versions of AS: AS, As, as.
void VariablesSwap(int mainSelect, vector<string> fileText, string updateTable){
    //regex expressions needed to find variables
    regex r("(?:^|\\W\\b)AS(?:$|\\W\\b)");
    regex t("(?:^|\\W\\b)as(?:$|\\W\\b)");
    regex x("(?:^|\\W\\b)As(?:$|\\W\\b)");
    smatch m;

    //variable declarations
    string str1;
    string str2;
    string str;
    int pos;
    int count = 0;
    
    //Loop to go over all lines in the file and split the lines up.
    //first one should be 228 for test file (SQLQuery15)
    for(int i=mainSelect; i<fileText.size(); i++){
        //loop to look for "AS"
        if(regex_search(fileText[i], m, r)){            
            pos = m.position();        //find position of AS
            str1 = fileText[i].substr(0,pos);   //find first variable
            str1 = str1.substr(str1.find_first_not_of(", \\n\\r\\t\\f\\v"));    //remove leading spaces and ,
            str2 = fileText[i].substr(pos+4);   //find start of second variable

            if(count > 0){
                str = "," + str2 + " = " + str1;
            }
            else{
                str = str2 + " = " + str1;
            }

            Output(str, count, updateTable);
            count++;
        }
        //loop to look for "as"
        if(regex_search(fileText[i], m, t)){
            pos = m.position();        //find position of as
            str1 = fileText[i].substr(0,pos);   //find first variable
            str1 = str1.substr(str1.find_first_not_of(", \\n\\r\\t\\f\\v"));    //remove leading spaces and ,
            str2 = fileText[i].substr(pos+4);   //find start of second variable
            
            Output(str, count, updateTable);
            count++;
        }
        //loop to look for "As"
        if(regex_search(fileText[i], m, x)){
            pos = m.position();        //find position of As
            str1 = fileText[i].substr(0,pos);   //find first variable
            str1 = str1.substr(str1.find_first_not_of(", \\n\\r\\t\\f\\v"));    //remove leading spaces and ,
            str2 = fileText[i].substr(pos+4);   //find start of second variable
            
            Output(str, count, updateTable);
            count++;
        }
    }
}

void Output(string str, int count, string updateTable){
    string outputFileName;
    fstream fileOut;
    outputFileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\testOutput.sql";

    //cout << "Enter file to write to:";
    //cin >>  outputFileName;

    

    if(count == 0){
        fileOut.open(outputFileName, ios::out | ios::trunc);
        fileOut.close();

        fileOut.open(outputFileName, ios::app);
        fileOut << "UPDATE " << updateTable << endl;
        fileOut << "SET" << endl;
        fileOut << str << endl;
        fileOut.close();
    }
    else{
        fileOut.open(outputFileName, ios::app);
        fileOut << str << endl;
        fileOut.close();
    }

}

//Function to display what is in the sql file.
//Takes the fileText as a value.
void Display(vector<string> fileText){
    for(int i=0; i<fileText.size(); i++){
        cout <<fileText[i]<< endl;
    }
}
