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

/* 3. Use Small Multiples */

/* Example from https://blogs.sas.com/content/iml/2016/06/02/create-spaghetti-plots-in-sas.html */
ods graphics / width=400px height=400px AttrPriority=NONE;
title "Overlay Groups";
proc sgplot data=sashelp.iris;
  ellipse x=SepalLength y=SepalWidth / fill fillattrs=(transparency=0.5) group=Species name="e";
  scatter x=SepalLength y=SepalWidth / group=Species;
  yaxis grid values=(20 to 45 by 5) valueshint;
  xaxis grid;
  keylegend "e" / title="95% Prediction Ellipse";
run;

ods graphics / width=600px height=400px AttrPriority=COLOR;
title "Small Multiples";
proc sgpanel data=sashelp.iris;
  *panelby Species / rows=3 layout=rowlattice;
  panelby Species / columns=3 layout=columnlattice;
  ellipse x=SepalLength y=SepalWidth / fill name="e";
  scatter x=SepalLength y=SepalWidth;
  colaxis grid max=83;
  rowaxis grid;
  keylegend "e";
run;


/* Program to accompany the article
   "Lasagna plots in SAS: When spaghetti plots aren't sufficient" 
   by Rick Wicklin, published 08JUN2016
   http://blogs.sas.com/content/iml/2016/06/08/lasagna-plots-in-sas.html
   Average life expectancy data from World Bank
   http://data.worldbank.org/indicator/SP.DYN.LE00.IN
   downloaded 20May2016.
*/

/* Step 1: Download two CSV file
   The life expectancy data: http://blogs.sas.com/content/iml/files/2016/06/LE2.csv
   Country information: http://blogs.sas.com/content/iml/files/2016/06/LifeExpectancyCountries.csv
*/
title; footnote; 

/* Step 2: Import to SAS data sets */
filename LEDATA1 "C:\Users\&SYSUSERID\Downloads\LifeExpectancy\LE2.csv";
filename LEDATA2 "C:\Users\&SYSUSERID\Downloads\LifeExpectancy\LifeExpectancyCountries.csv";

PROC IMPORT OUT= WORK.LifeExpectancy 
            DATAFILE= LEDATA1 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.CountryCodes 
            DATAFILE= LEDATA2
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/* Step 3: Prepare data for plotting. Add formats. Convert from Wide to Long form */
proc sort data=LifeExpectancy(drop=Indicator_Code Indicator_Name) out=LEsort;
   by Country_Code;
run;

proc format;
value IncomeFmt   1='High OECD'    2='High nonOECD'
                  3='Upper Middle' 4='Lower Middle'
                  5='Low';
run;

data LL2;
merge LEsort  CountryCodes(drop=SpecialNotes);
by Country_Code;
if      IncomeGroup="High income: OECD" then Income=1;
else if IncomeGroup="High income: nonOECD" then Income=2;
else if IncomeGroup="Upper middle income" then Income=3;
else if IncomeGroup="Lower middle income" then Income=4;
else if IncomeGroup="Low income" then Income=5;
else delete;
format Income IncomeFmt.;
run;

proc sort data=LL2;
  by Income Country_Name;
run;

/* transpose from wide to long */
data LE;
set LL2;
array Yr[*] Y1960-Y2014;
do i = 1 to dim(Yr);
   Year = 1960 + (i-1);
   Expected = Yr[i];
   output;
end;
label Expected = "Life Expectancy at Birth (years)";
drop i Y1960-Y2015;
run;

/* Spaghetti plot in SAS, colored by World Bank wealth category */
title "Life Expectancy at Birth for 207 Countries";
proc sgplot data=LE;
   series x=Year y=Expected / group=Country_Name grouplc=region break 
        transparency=0.7 lineattrs=(pattern=solid)
        tip=(Country_Name Income Region);
   xaxis display=(nolabel);
   keylegend / type=linecolor title="";
run;

/* Paneled spaghetti plots, colored by geography */
proc sgpanel data=LE;
   panelby Income / columns=3 onepanel sparse;
   series x=Year y=Expected / group=Country_Name break transparency=0.5
       grouplc=region lineattrs=(pattern=solid)
       tip=(Country_Name Region);
   colaxis grid display=(nolabel) offsetmin=0.05 fitpolicy=stagger;
   keylegend / type=linecolor title="";
run;

/**********************************/

/* layout the graphs. Use the #BYVALn values to build the titles */
title;
ods graphics / width=300px height=250px;      /* make small to fit on page */
*options nobyline;                            /* suppress Stock=Value title */
ods layout gridded columns=3 advance=table;   /* layout in three columns */
title "95% Prediction Ellipse for #ByVar1";   /* substitute var name for #BYVAR */
 
proc sgplot data=Sashelp.iris noautolegend;
   by Species;
   ellipse x=SepalLength y=SepalWidth / fill;
   scatter x=SepalLength y=SepalWidth;
   xaxis grid; yaxis grid;
run;
 
ods layout end;                               /* end the gridded layout */
*options byline;                              /* turn the option on again */

title; footnote; ods graphics / pop;
