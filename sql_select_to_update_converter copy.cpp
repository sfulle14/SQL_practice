#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cassert>


using namespace std;

//function declaration
void readFile(string fileName, vector<string>& fileText);

int main() {
    //declare variables
    string fileName;
    vector<string> fileText;
    int n=0;


    cout<<"File to convert:";
    //cin >> fileName;
    //fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.sql";
    fileName = "C:\\Users\\Steven\\Desktop\\code\\SQL_practice\\SQLQuery15.txt";

    readFile(fileName, fileText);

    cout<<"Do i make it here!!!\n";


    return 0;
}

//Function to read the file to a vector of strings.
void readFile(string fileName, vector<string>& fileText){
    //declare variables
    int n=0;
    fstream fileIn; 
    string line;

    //open file
    fileIn.open(fileName);
    assert(fileIn);
    //everything works up to here!!
 
    //looping through file line by line
    while(!fileIn.eof()){
        cout << "\nreadFile while loop\n"; //Making it into the loop
        //getline(fileIn, fileText[n]);
        fileText[n] = fileIn.get();
        cout << fileText[n];
        n++;
        
    }
    cout << "readFile exited while loop\n";

    fileIn.close();
}

/*
void Display(){

}
*/
