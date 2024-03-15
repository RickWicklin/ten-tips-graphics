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

/* 8. Use Lasagna Charts Instead of Spaghetti Plots
*/

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


/* conventional spaghetti plot is not very useful */
ods graphics / reset;
*ods graphics / ANTIALIASMAX=13700 imagemap=ON TIPMAX=11800; /* enable data tips */
title "Life Expectancy at Birth";
title2 "Low-Income Countries";
proc sgplot data=LE;
where income=5;            /* extract the "low income" companies */
format Country_Name $10.;  /* truncate country names */
series x=Year y=Expected / group=Country_name break curvelabel
       lineattrs=(pattern=solid) tip=(Country_Name Region Year Expected);
run;

/***********************************************/
/* Lasagna plots */
/***********************************************/

/* More readable: heat map of countries, colored by response variable */
/* 1. Unsorted list of countries */
/* use COLORMODEL=(color-list) to change colors */
ods graphics/ width=500px height=600px discretemax=10000;
title "Life Expectancy in Low Income Countries";
proc sgplot data=LE;
   where Income=5;            /* extract the "low income" companies */
   format Country_Name $10.;  /* truncate country names */
   heatmap x=Year y=Country_Name/ colorresponse=Expected discretex
               colormodel=TwoColorRamp;
   yaxis display=(nolabel) labelattrs=(size=6pt) fitpolicy=thin reverse;
   xaxis display=(nolabel) labelattrs=(size=8pt) fitpolicy=thin;
run;
title;

/* extract the "low income" companies and SORT by average life expectancy */
data LE5;
set LE;
where Income=5;
run;

/* compute average life expectancy for each country over the years */
proc means data=LE5 mean nolabels;
class Country_Name;
var Expected;
output out=AvgLE(keep=Country_Name _TYPE_ MeanLE) mean=MeanLE;
run;

/* merge */
data LE6;
merge LE5 AvgLE(where=(_TYPE_=1));
by Country_Name;
run;

/* sort by average life expectancy */
proc sort data=LE6 out=LE7;
by descending MeanLE Year;
run;

title "Life Expectancy of Low-Income Countries";
title2 "Sorted by Average Life Expectancy";
proc sgplot data=LE7;
   format Country_Name $11.;  /* truncate country names */
   heatmap x=Year y=Country_Name/ colorresponse=Expected discretex
               colormodel=TwoColorRamp;
   yaxis display=(nolabel) labelattrs=(size=6pt) fitpolicy=thin reverse;
   xaxis display=(nolabel) labelattrs=(size=8pt) fitpolicy=thin;
run;


title; footnote; ods graphics / pop;
