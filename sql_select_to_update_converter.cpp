#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>


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
    cout<<"File to convert:";
    //cin >> fileName;       //commented out for testing
    fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.sql";
    //fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.txt";

    readFile(fileName, fileText);

    cout <<"Enter name of table to UPDATE:";
    //cin >> updateTable;       //commented out for testing
    updateTable = "tblCaseCharge";

    //Display the test in file
    //Display(fileText);
    

   for(int i=0; i<fileText.size(); i++){
        if(fileText[i] == "INSERT INTO " + updateTable || fileText[i] == "insert into " + updateTable || fileText[i] == "Insert into " + updateTable){
            mainInsert = i;
            cout <<"MainInsert = " + mainInsert <<endl;
            break;
        }
    }

    for(int i=mainInsert; i<fileText.size(); i++){
        if(fileText[i]=="SELECT" || fileText[i]=="select" || fileText[i]=="Select"){
            mainSelect = i;
            cout <<"MainSelect = " + mainSelect << endl;
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
