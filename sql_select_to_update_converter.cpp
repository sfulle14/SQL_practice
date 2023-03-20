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

int main() {
    //declare local variables
    string fileName;
    vector<string> fileText;
    int mainInsert;
    int mainSelect;
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
    
    //should be 5 for test
    for(int i=0; i<fileText.size(); i++){
        if(fileText[i] == "INSERT INTO " + updateTable || fileText[i] == "insert into " + updateTable || fileText[i] == "Insert into " + updateTable){
            mainInsert = i;
            cout << "\nMainInsert : " <<  mainInsert <<endl;
            break;
        }
    }

   //defining regular expressions for searching
   regex r("\\s+SELECT");
   regex s("\\s+select");
   regex t("\\s+Select");
   smatch m;

    
    //should be 227 for test
    for(int j=mainInsert; j<fileText.size(); j++){
        if(regex_search(fileText[j], m, r) || regex_search(fileText[j], m, s) || regex_search(fileText[j], m, t)){
            mainSelect = j;
            cout << "MainSelect: " << mainSelect << endl;
            break;
        }
    }


    return 0;
}

//Function to read the file to a vector of strings.
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


void Display(vector<string> fileText){
    for(int i=0; i<fileText.size(); i++){
        cout <<fileText[i]<< endl;
    }
}
