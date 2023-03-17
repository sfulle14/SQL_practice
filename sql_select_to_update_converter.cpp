#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>


using namespace std;

//function declaration
void readFile(string fileName, vector<string>& fileText, fstream fileIn);

int main() {
    //declare variables
    string fileName;
    fstream fileIn;
    fstream file;
    vector<string> fileText;
    int n=0;

    //asking for file to open
    cout<<"File to convert:";
    cin >> fileName;

    //open given file
    fileIn.open(fileName);
    assert(fileIn);

    //looping through file line by line
    while(fileIn >> fileText[n]){
        //fileText[n] = fileIn.get();
        n++;
    }
    cout << fileText.size();
    //readFile(fileName, fileText, fileIn);

    //readFile(fileName, fileText);
    cout<<"Exited readFile\n";


    for(int i=0; i<10 /*fileText.size()*/; i++){
        cout << fileText[i];
    }
    
    fileIn.close();
    return 0;
}

//Function to read the file to a vector of strings.
void readFile(string fileName, vector<string>& fileText, fstream fileIn){


}

/*
void Display(){

}
*/
