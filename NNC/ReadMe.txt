***********************************************************************
Normalized Normal Constraint Algorithm for Multi-objective optimization
***********************************************************************


**********************************************************************

Beta version 

Copyright 2006 - 2012 - CPOH  

Predictive Control and Heuristic Optimization Research Group
	http://cpoh.upv.es

ai2 Institute
	http://www.ai2.upv.es

Universitat Politècnica de València - Spain.
	http://www.upv.es

**********************************************************************

Author
	Gilberto Reynoso Meza
	gilreyme@upv.es
	http://cpoh.upv.es/en/gilberto-reynoso-meza.html
    http://www.mathworks.es/matlabcentral/fileexchange/authors/289050

**********************************************************************

For new releases and bug fixing of this Tool Set please visit:

	http://cpoh.upv.es/en/research/software.html
	Matlab Central File Exchange

**********************************************************************


**********************************************************************
****************************DESCRIPTION*******************************
**********************************************************************

This Toolset comprises of the following files:


1) NNCparam.m

	Generates the required parameters to run the NNC optimization algorithm.

2) NNC.m

	Runs the optimization algorithm. This code implements the NNC algorithm for 2 and 3 objectives as described in:

A. Messac, A. Ismail-Yahaya and C.A. Mattson. The normalized normal 
constraint method for generating the Pareto frontier structural and
multidisciplinary optimization Volume 25, Number 2 (2003), 86-98.

3) OPTroutine.m
	Implements the optimization routine for NNC algorithm.

4) CostFuntion.m
	The cost function to optimize