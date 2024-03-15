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

/* Difference betwen data visualization and statistical graphics.
   Example from 
   https://blogs.sas.com/content/iml/2015/09/10/plot-distrib-reg-model.html
*/

/* data and ideas from http://freakonometrics.hypotheses.org/9593 */
/* Stopping distance (ft) for a car traveling at certain speeds (mph) */
data MyData(label="cars data from R");
input x y @@;
logY = log(y);
label x = "Speed (mph)"  y = "Distance (feet)" logY = "log(Distance)";
datalines;
4   2  4 10  7  4  7  22  8 16  9 10 10 18 10 26 10  34 11 17 
11 28 12 14 12 20 12  24 12 28 13 26 13 34 13 34 13  46 14 26 
14 36 14 60 14 80 15  20 15 26 15 54 16 32 16 40 17  32 17 40 
17 50 18 42 18 56 18  76 18 84 19 36 19 46 19 68 20  32 20 48 
20 52 20 56 20 64 22  66 23 54 24 70 24 92 24 93 24 120 25 85 
;


title "Stopping Distance";
proc sgplot data=MyData noautolegend;
  scatter x=x y=y;
  xaxis grid;
  yaxis grid;
run;
title;

title "Regression Model of Stopping Distance";
proc sgplot data=MyData noautolegend;
  reg x=x y=y / clm;
  xaxis grid;
  yaxis grid;
run;


title; footnote; ods graphics / pop;
