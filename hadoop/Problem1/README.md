# C++ Implementation of Map-Reduce
 
 In this problem, the map reduce API is implemented using C++ serial programs.
 
 File : VertexDegree.cpp
 
 Compiler Version : gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1 ubuntu5)

## Code Description
 The code contains a mapper function, a reducer function and a master function run.
 Main function is calling the run function to initiate the process.
 Clock times for the process is also monitored.


## Usage
* Code Compilation

````
    g++ VertexDegree -pg
````
This command execution will create ./a.out file as executable file. -pg is used for gprof profiler


* Code Running

```
   ./a.out <input directory path> <output-file>
```

This command execution will create output files and gmon.out file. It also returns the job performance chart as follow in the console.

* Code Profiling using gprof

```
     gprof a.out gmon.out -p|g|A >> performance.txt
```

This command runs the gprof profiler and stores the output in performance.txt file

**-p** provides flat profile

**-q** provides call graph

**-A** provides Annotated resource

* Conversion of profiling output to a dot graph : **Gprof2Dot**

```
    gprof path/to/your/executable | gprof2dot.py | dot -Tpng -o output.png
```
This command generates a dot graph which shows the %time consumed by each fucntion and the caller-callee graphs. 

## Functions Details
* Mapper Function

```
    int mapper(char *args[]) 
```
This function takes args[1] as input directory name and reads the files inside the directory sequentially and writes into an intermediate file for the reducer. Returns -1 if fails and 0 if succeeds.

* Reducer Function

```
    int reducer(char *args[]) 
```

This function takes args[2] as output file name and reads the intermediate file created by mapper function and writes the final output after reducing operation into outfile file. Returns -1 if fails and 0 if succeeds.

* Run Function

```
    int run(char *args[]) 
```
This function takes args[1] as input folder and args[2] output file name and calls the mapper and reducer function. Returns -1 if fails and 0 if succeeds.

* Main Function

```
    int main(int argc, char *args[]) 
```
This is a normal main function which takes argument described in the usage section and prints the job description and performance with the use of clock operations


## References
* https://www.cs.utah.edu/dept/old/texinfo/as/gprof.html
* https://sourceware.org/binutils/docs/gprof
* http://stackoverflow.com/questions/874134/find-if-string-endswith-another-string-in-c?lq=1
* https://code.google.com/p/jrfonseca/wiki/Gprof2Dot

