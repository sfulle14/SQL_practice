#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>
#include <regex>


using namespace std;

//function declaration
void readFile(string fileName, vector<string>& fileText);

int main() {
    //declare local variables
    string fileName;
    vector<string> fileText;
    int mainInsert;
    string updateTable;


    //get file from user
    cout<<"File to convert:";
    //cin >> fileName;
    fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.sql";
    //fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.txt";

    readFile(fileName, fileText);

    cout <<"Enter name of table to UPDATE:";
    cin >> updateTable;
    updateTable = "tblCaseCharge";

    /*
    for(int i=0; i<fileText.size(); i++){
        cout <<fileText[i]<< endl;
    }
    */

   for(int i=0; i<fileText.size(); i++){
        if(fileText[i] == "INSERT INTO " + updateTable){
            mainInsert = i;
            cout <<mainInsert<<endl;
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

/*
void Display(){

}
*/
