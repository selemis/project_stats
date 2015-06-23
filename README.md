# Project stats

## Summary

This is a simple projects for visualizing code metrics to simple graphs.

The purpose of the project is to visualize the code metrics over the evolution of time. I assume that there is some kind of source control system and we are able to run metrics against the various commits.
I also suppose that each commits' metrics are represented by a line in some csv files.  

There is a main Rakefile that reads the data from those csv files and renders various types of graphs as pictures in png format. On top of that there is an html file that displays all those images. 

## Input - csv files format

For the moment there are two csv files.

The first file is named **file_data.csv**.

It contains the following columns:

* Hash
    * An identifier of the source control system. It could be the SHA-1 hash of a git commit or something like that.
* Comments Count
    * Number of lines of comments.
* Library Lines
    * Number of lines of code included in third party party. For example it could count the lines of code in the lib folder of a rails project.
* Application Lines
    * Lines of production source code.
* Spec Lines
    * Number of lines of spec code.
* Spec Runtime
    * The time it takes for the specs to run.
    
The second file is named **coverage_data.csv**.

It contains the following columns:

* Hash
    * An identifier of the source control system. It could be the SHA-1 hash of a git commit or something like that.
* Covered Lines
    * Lines of production code covered by specs.
* Total Lines
    * Total lines of production source code.

## Output - Graphs produced

The types of graphs that are produced are the following

* 'Lines of code' graph

### 'Lines of code' graph

The graph is a line graph that displays 4 lines.

* One line for total lines of comments
* One line for third party library lines of code
* One line for total lines of production code
* One line for total spec lines of code

![Lines of code](https://github.com/selemis/project_stats/raw/master/images/loc.png "Lines of code graph")

### 'Specs runtime graph'

The graph is a line graph that displays total number of seconds it takes to run the specs in each revision.

![Specs runtime](https://github.com/selemis/project_stats/raw/master/images/spec_run_time.png "Specs runtime graph")

### Spec to production code lines of code ratio graph

The graph is a line graph that displays the ratio of number of lines of spec code to the total number of lines of production code. 

![Specs to prod ratio](https://github.com/selemis/project_stats/raw/master/images/spec_to_prod_ratio.png "Specs to prod ratio graph")

### 'Coverage graph'
 
The graph is a line graph that contains two lines.

* One line for the number of lines covered by the specs.
* One line for the total line numbers of production code.

![Coverage](https://github.com/selemis/project_stats/raw/master/images/coverage.png "Coverage graph")

### 'Coverage ratio' graph

The graph is a line graph that displays the ratio of the total lines covered by the specs to the total lines of production code.

![Coverage ratio](https://github.com/selemis/project_stats/raw/master/images/coverage_ratio.png "Coverage ratio graph")