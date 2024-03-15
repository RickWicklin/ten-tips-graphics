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

/* 9. Use Dot Plots Instead of Dynamite Plots
*/

/* Synthetic data based on Figure 8 in the graph at
   https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6100796/figure/F8/

   Pickhardt, Perry J., et al. (2018)
   "The Natural History of Colorectal Polyps: Overview of Predictive Static and Dynamic Features,"
   Gastroenterology Clinics of North America,
   Volume 47, Issue 3, Pages 515-536.
   https://doi.org/10.1016/j.gtc.2018.04.004.
   (https://www.sciencedirect.com/science/article/pii/S0889855318300323)   
*/

/* simulate data where the mean and std dev differ across groups */
data Sim;
call streaminit(1);
length type $21;
label type = "Polyp Type"
      y = "Volume Change per Year (%)";
array mu[4]    _temporary_ (76 20 -5 -13);  /* mean */
array sigma[4] _temporary_ (25  7 14  4);   /* std dev */
array NN[4]    _temporary_ (23 84 24 174);  /* sample size */
array tt[4] $21 ("Advanced Adenomas" "Non-advanced Adenomas" "Non-neoplastic" "Unresected");
drop tt1-tt4;
call streaminit(12345);
do i = 1 to dim(mu);
   type = tt[i];
   N = NN[i];
   do j = 1 to N;
      y = rand("Normal", mu[i], sigma[i]); /* Y ~ N(mu[i], sigma[i]) */
      output;
   end;
end;
run;

/* create the dynamite plot */
ods graphics / width=500px height=600px;
title "Change in Polyp Volume";
title2 "Mean and Standard Deviation";
footnote J=L "Pickhardt, et al. (2018) Gastroenterol Clin North Am.";

proc sgplot data=Sim noautolegend;
   vbar type / response=y stat=mean limitstat=stddev;
   xaxistable N / stat=freq location=inside;
   yaxis grid;
   xaxis fitpolicy=split;
run;


/* create the dot plot */
ods graphics / width=500px height=300px;
proc sgplot data=Sim noautolegend;
   refline 0 / axis=x lineattrs=(color=gray thickness=2);
   dot type / response=y stat=mean limitstat=stddev limitattrs=(thickness=2);
   yaxistable N / stat=freq location=inside;
   xaxis grid;
   yaxis fitpolicy=split labelpos=top;
run;


title; footnote; ods graphics / pop;
