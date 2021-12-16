


Appendix: Ines Thiele, Dec 2021
how to compile the newest version of mex files

prior to compilation do the following:
copy the 2 files from e.g., C:\Program Files\IBM\ILOG\CPLEX_Studio129\cplex\include\ilcplex
cplex.h
cpxconst.h
into your working directory (as you cannot modify them in ILOG folder)

remove all instances of from cplex.h: 'CPXDEPRECATEDAPI(12090000)'

delete from cpxconst.h: '#ifndef CPXSIZE_BITS_TEST_DISABLE
typedef int CPXSIZE_BITS_TEST[sizeof(CPXSIZE) == sizeof(size_t) ? 1 : -1];
#endif /* !CPXSIZE_BITS_TEST_DISABLE */'

make the following modifications to cplexFVA.c if necessary : remove all references to log files

create the mex file
you need MinGW64 therefore which you can get by installing Add-Ons in Matlab
run in matlab, e.g.,:
mex -largeArrayDims  cplexFVA.c "C:\Program Files\IBM\ILOG\CPLEX_Studio129\cplex\lib\x64_windows_vs2017\stat_mda\cplex1290.lib"


____________________________
Last updated 26.5.2010.

The following files are supplied

README.txt		This file
fastFVA.m		Matlab wrapper for the mex functions
run_exps.m		Performs the experiments described in the paper
SetWorkerCount.m	Helper function to configure the number of processes
cplexFVAc.c		Source code for the CPLEX version of fastFVA
glpkFVAcc.cpp		Source code for the GLPK version of fastFVA

The following precompiled Matlab executables are supplied

glpkFVAcc.mexw32	32-bit Windows version, built with GLPK-4.42, Matlab 2009b and Windows XP
glpkFVAcc.mexw64	64-bit Windows version, built with GLPK-4.42, Matlab 2009b and Windows 7
glpkFVAcc.mexa64	64-Bit Linux version,   built with GLPK-4.43, Matlab 2009b and Linux 2.6.9-89

cplexFVAc.mexw32	32-bit Windows version, built with CPLEX 12.1, Matlab 2009b and Windows XP
cplexFVAc.mexw64	64-bit Windows version, built with CPLEX 12.1, Matlab 2009b and Windows 7



Introduction
============

fastFVA is an efficient implementation of flux variability analysis written in C++. There are two versions of the code. One uses IBM's CPLEX solver and the other uses the open source GLPK.

The CPLEX version is called cplexFVAc. It requires the cplex121.dll to be present in the same directory and a valid license for CPLEX(*).

The GPLK version is called glpkFVAcc.cpp and requires glpk_4_42.dll (or a later version) to be present in the same directory.

The routines are called via the Matlab function fastFVA. This function employs PARFOR for further speedup if the parallel toolbox has been installed. You can either use the MATLABPOOL command directly to specify the number of cores/CPUs or use the SetWorkerCount helper function.

If you use fastFVA in your work, please cite

S. Gudmundsson, I. Thiele, Computationally efficient Flux Variability Analysis, ...


(*) IBM has recently made CPLEX available through their Academic Initiative program which allows academic institutions to obtain a full version of the software without charge..


Compiling
=========

1) Windows

You need to install a C++ compiler if you haven't done so already, e. g. The Microsoft Visual Studio Express 2008 compiler which is available free of charge. Depending on your Matlab version, see 

http://www.mathworks.com/support/compilers/R2009b/
http://www.mathworks.com/support/compilers/R2010a/

for more details on compiler options.

The instructions below refer to the Visual Studio Express compiler.

1.1 GLPK version
----------------

Download WinGLPK from 

http://sourceforge.net/projects/winglpk/

In the following it is assumed that GLPK has been installed in C:\glpk-4.42

For Win32
>> mex -IC:\glpk-4.42\include\ glpkFVAcc.cpp C:\glpk-4.42\w32\glpk_4_42.lib

For Win64
>> mex -largeArrayDims -IC:\glpk-4.42\include\ glpkFVAcc.cpp C:\glpk-4.42\w64\glpk_4_42.lib


1.2 CPLEX version
-----------------

Download the appropriate version of CPLEX (32-bit or 64-bit) from IBM and make sure the license is valid.

In the following it is assumed that CPLEX is installed in C:\ILOG\CPLEX

For Win32
>> mex -IC:\ILOG\CPLEX121\include\ilcplex cplexFVAc.c C:\ILOG\CPLEX121\lib\x86_windows_vs2008\stat_mda\cplex121.lib C:\ILOG\CPLEX121\lib\x86_windows_vs2008\stat_mda\ilocplex.lib

For Win64

>> mex -largeArrayDims -IC:\ILOG\CPLEX121\include\ilcplex cplexFVAc.c C:\ILOG\CPLEX121\lib\x64_windows_vs2008\stat_mda\cplex121.lib C:\ILOG\CPLEX121\lib\x64_windows_vs2008\stat_mda\ilocplex.lib


2) Linux

2.1 GLPK version
----------------

Download and install GLPK from

http://www.gnu.org/software/glpk/

32-bit
>> mex glpkFVAcc.cpp -lglpk -lm

64-bit
>> mex -largeArrayDims glpkFVAcc.cpp -lglpk -lm


Usage
=====

 [minFlux,maxFlux] = fastFVA(model,optPercentage,objective, solver)

 Solves LPs of the form for all v_j: max/min v_j
                                     subject to S*v = b
                                     lb <= v <= ub
 Inputs:
   model             Model structure
     Required fields
       S            Stoichiometric matrix
       b            Right hand side = 0
       c            Objective coefficients
       lb           Lower bounds
       ub           Upper bounds
     Optional fields
       A            General constraint matrix
       csense       Type of constraints, csense is a vector with elements
                    'E' (equal), 'L' (less than) or 'G' (greater than).
     If the optional fields are supplied, following LPs are solved
                    max/min v_j
                    subject to Av {'<=' | '=' | '>='} b
                                lb <= v <= ub

   optPercentage    Only consider solutions that give you at least a certain
                    percentage of the optimal solution (default = 100
                    or optimal solutions only)
   objective        Objective ('min' or 'max') (default 'max')
   solver           'cplex' or 'glpk' (default 'glpk')

 Outputs:
   minFlux   Minimum flux for each reaction
   maxFlux   Maximum flux for each reaction
   optsol    Optimal solution (of the initial FBA)
   ret       Zero if success


Please report problems to steinng@hi.is
