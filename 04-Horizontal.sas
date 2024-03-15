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

/* 4. Use Horizontal Bar Charts 
      https://blogs.sas.com/content/iml/2021/04/12/horizontal-bar-chart.html
*/

/* Sort the data by smoking status:
   https://blogs.sas.com/content/iml/2016/06/20/select-when-sas-data-step.html
*/
data Heart;
set sashelp.heart;
select (Smoking_Status);
   when ('Non-smoker')        Smoking_Cat=1;
   when ('Light (1-5)')       Smoking_Cat=2;
   when ('Moderate (6-15)')   Smoking_Cat=3;
   when ('Heavy (16-25)')     Smoking_Cat=4;
   when ('Very Heavy (> 25)') Smoking_Cat=5;
   otherwise                  Smoking_Cat=.;
end;
run;

proc sort data=Heart; by Smoking_Cat; run;

ods graphics/ width=400px height=300px;

/* Standard vertical bar charts */
title "Vertical Bar Chart";
proc sgplot data=Heart;
   vbar Smoking_Status;
   xaxis discreteorder=data;   /* use data order instead of alphabetical */
   yaxis grid;
run;

title "Horizontal Bar Chart";
proc sgplot data=Heart;
   hbar Smoking_Status;
   xaxis grid;
   yaxis discreteorder=data;   /* use data order instead of alphabetical */
run;


/*******************************************************/
/*******************************************************/

/* SAS program to accompany the blog post "Perceptions of probability" 
   by Rick Wicklin, published on The DO Loop blog 03MAY2017
    http://blogs.sas.com/content/iml/2017/05/03/perceptions-of-probability.html

Data and idea from from 
   https://github.com/zonination/perceptions/blob/master/numberly.csv
Original data discussed at
https://www.cia.gov/library/center-for-the-study-of-intelligence/csi-publications/books-and-monographs/psychology-of-intelligence-analysis/art15.html
*/
data Perception;
input AlmostCertainly HighlyLikely VeryGoodChance Probable	
      Likely Probably WeBelieve BetterThanEven AboutEven	
      WeDoubt Improbable Unlikely ProbablyNot LittleChance
      AlmostNoChance HighlyUnlikely ChancesAreSlight;
label AlmostCertainly="Almost Certainly" 
      HighlyLikely="Highly Likely" 
      Probable="Probable"
      Likely="Likely"
      Probably="Probably"
      VeryGoodChance="Very Good Chance"
      WeBelieve="We Believe" 
      BetterThanEven="Better Than Even" 
      AboutEven="About Even"	
      WeDoubt="We Doubt" 
      Improbable="Improbable"
      Unlikely="Unlikely"
      ProbablyNot="Probably Not" 
      LittleChance="Little Chance"
      AlmostNoChance="Almost No Chance" 
      HighlyUnlikely="Highly Unlikely" 
      ChancesAreSlight="Chances Are Slight";
datalines;
95	80	85	75	66	75	66	55	50	40	20	30	15	20	5	25	25
95	75	75	51	75	51	51	51	50	20	49	25	49	5	5	10	5
95	85	85	70	75	70	80	60	50	30	10	25	25	20	1	5	15
95	85	85	70	75	70	80	60	50	30	10	25	25	20	1	5	15
98	95	80	70	70	75	65	60	50	10	50	5	20	5	1	2	10
95	99	85	90	75	75	80	65	50	7	15	8	15	5	1	3	20
85	95	65	80	40	45	80	60	45	45	35	20	40	20	10	20	30
97	95	75	70	70	80	75	55	50	25	30	15	25	20	3	5	10
95	95	80	70	65	80	65	55	50	20	30	35	35	15	5	15	10
90	85	90	70	75	70	65	60	52	60	20	30	45	20	10	6	25
90	90	85	70	60	75	80	60	50	25	1	15	40	20	15	10	15
99	97	70	75	75	75	90	67	50	17	10	10	25	17	2	3	5
60	80	70	70	60	55	60	55	50	20	5	30	30	10	5	5	15
88.7	69	80	51	70	60	50	5	50	30	49	20	40	13	2	3	5
99	98	85	85	75	65	5	65	50	100	1	10	100	100	95	90	35
95	90	80	70	70	80	85	60	50	30	40	30	40	15	1	5	10
97	90	70	51	65	60	75	51	50	5	10	15	10	15	2	7	5
99	95	75	60	65	75	80	55	50	25	3	15	30	10	1	5	40
95	95	90	60	80	75	75	60	50	25	10	10	20	25	5	5	10
95	90	75	80	75	75	50	50.1	50	25	20	25	49.9	25	5	5	10
90	80	80	75	80	75	60	60	50	40	30	10	25	20	5	5	5
92	85	75	60	70	60	85	57	50	25	33	10	10	7	3	3	13
98	90	75	80	85	85	85	60	49	5	15	2	10	2	5	5	5
98	92	91	85	85	85	70	60	50	30	7	18	27	17	2	3	10
90	90	75	75	65	80	80	60	50	12	25	35	30	20	2	10	20
95	85	80	75	65	75	50	60	50	33	10	25	25	10	2	5	5
95	90	80	60	75	60	60	51	50	10	49	20	40	15	5	20	10
98	95	75	85	90	85	75	98	50	40	7	10	25	10	2	5	5
85	85	90	60	65	76	50	51	50	33	25	25	20	10	1	15	15
80	15	74	65	65	65	60	60	50	38	29	36	34	29	7	15	30
98	80	75	65	70	55	60	55	50	25	20	12	35	15	1	8	15
96	85	80	75	70	90	80	60	50	5	9	3	20	20	10	5	12
99	85	75	80	75	90	50	51	50	1	0.001	10	10	5	0.05	10	5
85	84	87	50	60	65	50	60	50	60	3	24	30	20	5	15	30
90	95	80	70	90	60	60	80	40	25	3	5	20	4	2	2	30
95	85	80	64	80	80	75	80	50	10	10	25	20	8	2	5	5
98	96	90	90	90	80	70	53	50	40	4	30	30	8	1	5	10
98	96	82	75	86	80	45	69	52	21	12	34	26	18	7	3	13
80	90	70	80	80	80	70	60	50	10	0	20	30	10	1	10	10
95	90	90	80	90	90	85	55	48	15	20	35	15	15	5	8	10
99	90	80	90	60	50	90	60	50	40	20	10	40	5	1	30	15
85	80	80	70	70	70	65	51	45	30	15	35	30	10	5	15	20
90	70	80	75	70	65	70	60	50	15	35	20	25	5	2	10	10
95	80	90	75	70	75	100	60	50	10	5	10	20	10	1	5	5
85	90	75	65	65	60	95	55	50	95	5	20	40	25	2	5	10
95	80	75	75	60	68	55	51	49	25	20	35	40	17	5	10	15
;

/* First sort variables by value of the median. See
   http://blogs.sas.com/content/iml/2014/09/08/order-variables-by-statistic.html */
%let Stat = Median; /* or mean, stddev, qrange, skew, etc */
proc means data=Perception &Stat STACKODSOUTPUT; 
 ods output Summary=StatOut;
run;
/* put ordered variable names into macro variable */
proc sql noprint;                              
 select Variable into :varlist separated by ' '
 from StatOut order by &Stat;
quit;

proc means data=Perception Q1 median Q3 nolabels; 
 var &varList;
run;

data Wide / view=Wide;     
retain &varlist;           /* reorder vars by statistic */
set Perception;
obsNum = _N_;              /* add ID for subject (observation) */
keep obsNum &varlist;
run;
 
/* transpose from wide to long data format; VARNAME is a categorical var */
proc transpose data=Wide name=VarName 
               out=Long(rename=(Col1=_Value_));
 by obsNum;
run;

/* Create the box plot
   1. sorted by medians
   2. no colors; use alternating bands instead
   3. systematic jitter instead of random jitter
   4. do not duplicate outliers
*/
ods graphics / height=700px width=500px subpixel;
title "Perceptions of Probability";
proc sgplot data=Long noautolegend;
   hbox _Value_ / category=_Label_ nooutliers nomean nocaps;  
   scatter x=_Value_ y=_Label_ / jitter transparency=0.5
                     markerattrs=GraphData2(symbol=circlefilled size=4);
   yaxis reverse discreteorder=data labelpos=top labelattrs=(weight=bold)
                     colorbands=even colorbandsattrs=(color=gray transparency=0.9)
                     offsetmin=0.0294 offsetmax=0.0294; /* half of 1/k, where k=number of catgories */
   xaxis grid values=(0 to 100 by 10);
   label _Value_ = "Assigned Probability (%)" _label_="Statement";
run;


title; footnote; ods graphics / pop;
