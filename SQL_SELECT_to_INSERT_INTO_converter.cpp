/*
Title: SQL SELECT script to INSERT INTO script converter
Description: 
Created By: Steven Fuller
Create Date: 3/21/2023
Version : 1.0 
*/

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>
#include <regex>


using namespace std;

void readFile(string fileName, vector<string>& fileText);
int FindSelect(vector<string> fileText);
int FindFrom(vector<string> fileText, int mainSelect);
void Display(vector<string> fileText);

int main() {
    //declare local variables
    string fileName;
    string outputFileName;
    vector<string> fileText;
    int mainSelect;
    int mainFrom;

    //get file from user
    cout<<"\nFile to convert:";
    cin >> fileName;       


    readFile(fileName, fileText);

    //Get the locaiton of the main SELECT script.
    mainSelect = FindSelect(fileText);

    //Get the location of the main FROM in the script.
    mainFrom = FindFrom(fileText, mainSelect);


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


//Funciton to find the main SELECT of the sql file.
//Takes the fileText as inputs.
//
int FindSelect(vector<string> fileText){
    int mainSelect;

    for(int i=0; i<fileText.size(); i++){
        if(fileText[i] == "SELECT" || fileText[i] == "select" || fileText[i] == "Select"){
            mainSelect = i;
            break;
        }
    }

    return mainSelect;
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
    for(int i=mainSelect+1; i<fileText.size(); i++){
        if(regex_search(fileText[i], m, r) || regex_search(fileText[i], m, s) || regex_search(fileText[i], m, t)){
            fromLocation = i;
            break;
        }
    }

    return fromLocation;
}


//Function to display what is in the sql file.
//Takes the fileText as a value.
void Display(vector<string> fileText){
    for(int i=0; i<fileText.size(); i++){
        cout <<fileText[i]<< endl;
    }
}
