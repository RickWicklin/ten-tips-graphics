/* Program for 
   Wicklin, Rick (2023) "Ten Tips for Creating Effective Statistical Graphics"
   presented at multiple SAS conferences, including SAS Innovate 2024 in Las Vegas.

   Cite as 
   Wicklin, Rick (2023) "10 tips for creating effective statistical graphics." 
   _The DO Loop_ blog. Published December 6, 2023. 
   Accessed 01MAR2024
   https://blogs.sas.com/content/iml/2023/12/06/10-tips-statistical-graphics.html
*/

title; footnote; ods graphics / push;

/* 7. Visualize Missing Data
      https://blogs.sas.com/content/iml/2016/04/18/patterns-of-missing-data-in-sas.html
*/
%let Vars = AgeAtStart Height Weight Diastolic Systolic MRW Smoking Cholesterol;
%let numVars = %sysfunc(countw(&Vars));    /* &numVars = 8 for this example */
 
ods select MissPattern;
proc mi data=Sashelp.Heart nimpute=0 displaypattern=nomeans;   /* SAS 9.4M5 option */;
var &Vars;
ods output MissPattern=Pattern;        /* output missing value pattern to data set */
run;


proc iml;
varNames = {AgeAtStart Height Weight Diastolic 
            Systolic MRW Smoking Cholesterol};
use Sashelp.Heart;                         /* open data set */
read all var varNames into X;              /* create numeric data matrix, X */
close Sashelp.Heart;
 

Count = countmiss(X,"row");                /* count missing values for each obs */
missRows = loc(Count > 0);                 /* which rows are missing? */
Y = X[missRows,];              /* extract missing rows   */
Y = Y`;                        /* transpose so we can use a short/wide display */

ods graphics / push width=600px height=200px;
call HeatmapDisc( cmiss(Y) )   /* CMISS returns 0/1 matrix */
     displayoutlines=0 
     colorramp={white black}
     yvalues=VarNames          /* variable names along side */
     xvalues=missRows          /* use nonmissing rows numbers as labels */
     showlegend=0 title="Missing Value Pattern";
ods graphics / pop;
QUIT;


data Miss;
set Pattern;
array vars[*] _CHARACTER_;    /* or use &Vars */
length Pattern $&numVars.;    /* length = number of variables in array */
Pattern = translate(catt(of vars[*]), '01', 'X.');     /* Ex: 00100100 */
NumMiss = countc(pattern, '1');
run;
 
proc print data=Miss noobs;
   var Group Pattern NumMiss Freq;
run;

title "Pattern of Missing Values";
proc sgplot data=Miss;
   hbar Pattern /response=Freq datalabel
                       baseline=1;  /* set BASELINE=1 for log scale */
   yaxistable NumMiss / valuejustify=left label="Num Miss"
                       valueattrs=GraphValueText labelattrs=GraphLabelText; /* use same attributes as axis */
   yaxis labelposition=top; 
   xaxis grid type=log logbase=10 label="Frequency (log10 scale)";
run;

title; footnote; ods graphics / pop;
