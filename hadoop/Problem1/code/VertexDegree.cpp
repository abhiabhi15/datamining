/*
 * VertexDegree.cpp
 *
 *  Created on: Sep 17, 2014
 *      Author: abhishek
 *    UnityId : akagrawa
 */

#include <iostream>
#include <fstream>
#include <string.h>
#include <sstream>
#include <map>
#include <dirent.h>

using namespace std;

class VertexDegree {

    int mapper(char *args[]);
	int reducer(char *args[]);

public:
	int run(char *args[]); //Master Controller
};

int VertexDegree :: mapper(char *args[]){

	DIR *pDir;
    struct dirent *entry;
    string filepath;
    if((pDir = opendir(args[1])) != NULL){         //To access the input directory and files

    	ofstream ifile ( "tempFile.txt", ios::in|ios::app);
    	while((entry = readdir(pDir)) != NULL){
    		filepath = args[1];
			if( strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0 ){

				filepath.append("/");
				filepath.append(entry->d_name);

				ifstream srcfile ( filepath.c_str(), ios::out);   // To access individual files
				string line;

				getline( srcfile, line);
				if(srcfile.is_open() && ifile.is_open()){
					while( getline( srcfile, line)){ //To escape the first line of Vertex and edge count

						istringstream iss(line, istringstream::in);
						string vertex;
						while( iss >> vertex ){
							ifile << vertex << "  " << "1" << endl;   // Writing in Intermediate file
						}
					}
					cout << "Mapper job done for file = : " << entry->d_name << endl;
					srcfile.close();
				}else{
					cout << "Unable to open file : " << entry->d_name << endl;
					return -1;
				}
			}
		}
    	ifile.close();
		closedir(pDir);
	}else{
		cout<< "Unable to find input file directory : " << args[1] << endl;
		return -1;
	}
    return 0;
}

int VertexDegree :: reducer(char *args[]){

	ifstream iFile ("tempFile.txt", ios::out);           // Access of Intermediate File
	ofstream destFile (args[2], ios::in|ios::app);
	map <string, int> degreeMap;
	string line;
	if(iFile.is_open() && destFile.is_open()){
		while( getline( iFile, line)){

			istringstream iss(line, istringstream::in);
			string val;
			while( iss >> val ){

				if (degreeMap.find(val) != degreeMap.end()){
					degreeMap[val] += 1;
				}else{
					degreeMap[val] = 1;
				}
				break;
			}
		}
		// Writing output of map-reduce in the destination file
		for(map<string,int>::iterator itr=degreeMap.begin(); itr!=degreeMap.end(); ++itr){
			destFile << itr->first << " " << itr->second << '\n';
		}
		destFile.close();
		iFile.close();
	}else{
		cout << "  Unable to open files " << args[2] << "or tempFile.txt " << endl ;
		return -1;
	}

	if( remove( "tempFile.txt") != 0 ){
	    perror( "Error deleting file" );
	}
	return 0;
}

int VertexDegree :: run(char *args[]){

	clock_t t1 = clock();
	cout << " ------ Mapper Job Initiated -------- " << endl;

	if(mapper(args) == -1 ){
		return -1;
	}
	cout << " ------ Mapper Job Ends ------" << endl;

	t1 = clock() - t1;
	printf (" For Mapper Jobs %d clicks =(%f seconds).\n",t1,((float)t1)/CLOCKS_PER_SEC);

	clock_t t2 = clock();
	cout << "\n ------- Reducer Job Initiated  ------- " << endl;

	if(reducer(args) == -1){
		return -1;
	}

	t2 = clock() - t2;
	printf (" For Reducer Jobs %d clicks =(%f seconds).\n",t2,((float)t2)/CLOCKS_PER_SEC);
	return 0;
}

int main(int argc, char *argv[]) {

	if(argc != 3){
		cout << " Arguments Missing " << endl;
		cout << " MapReduce : Vertexdegree.cpp [Options]: executable-file  input-folder output-file " << endl;
		return -1;
	}

	clock_t t = clock();

	cout << " ######## Map Reduce Job Begins ###########" << endl;
	VertexDegree vd;

	if(vd.run(argv) == -1){
		cout << " ----- Program Exits ------ " << endl;
		return -1;
	}

	t = clock() - t;
	cout << endl;
	printf (" For Total Map-Reduce Jobs %d clicks = (%f seconds).\n",t,((float)t)/CLOCKS_PER_SEC);

    cout << " ######## Map Reduce Ends ##########" <<endl;
    return 0;
}
