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

/* 1. Simpler Is Better */
/*    Replace radar plot by a "butterfly chart" or a chart of differences
      https://blogs.sas.com/content/iml/2013/08/21/comparing-two-groups-graphically.html
*/
data Debate2012;
input Category $15. Obama Romney;
datalines;
Individualism  47 53
Directness     49 51
Talkativeness  49 51
Achievement    45 55
Perceptual     44 56
Quantitative   36 64
Insight        47 53
Causation      59 41
Thinking       52 48
Certainty      56 44
Sophistication 51 49
Collectivism   56 44
;

data Long;        /* transpose the data from wide to long */
set Debate2012;
Candidate = "Obama "; Value = Obama;  output;
Candidate = "Romney"; Value = Romney; output;
drop Obama Romney;
run;
 
/* display a horizontal bar chart */
title "2012 US Presidential Debates";
title2 "Linguistic Style Indexed Across Three Debates";
footnote justify=left "Data from http://blog.odintext.com/?p=179";
proc sgplot data=Long;
   hbar Category / response=Value group=Candidate groupdisplay=stack;
   refline 50 / axis=x lineattrs=(color=black);
   yaxis discreteorder=data;
   xaxis label="Percentage" values=(0 to 100 by 10);
run;

/* Two problems:
   1. The categories are not sorted in a useful order
   2. To contrast two groups, plot the DIFFERENCE between the groups, rather than the absolute quantities.
*/
data DebateDiff;
set Debate2012;
label Difference = "Percentage Difference: Romney - Obama";
Difference = Romney - Obama;
if Difference>0 then Advantage = "Romney";
else                 Advantage = "Obama ";
run;
 
proc sort data=DebateDiff;  /* sort categories by difference */
   by Difference;
run;
 
title2 "Linguistic Style Differences Indexed Across Three Debates";
proc sgplot data=DebateDiff;
   hbar Category / response=Difference group=Advantage;
   refline 0 / axis=x;
   yaxis discreteorder=data;
   xaxis grid;
   keylegend / position=topright location=inside title="Candidate" across=1; 
run;


title; footnote; ods graphics / pop;
