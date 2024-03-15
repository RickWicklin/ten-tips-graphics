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

/* 10. Think Carefully about Log Axes 
*/

/* Program for 
   "Scatter plots with logarithmic axes...and how to handle zeros in the data"
   http://blogs.sas.com/content/iml/2014/07/09/scatter-plots-with-log-axes/
   by Rick Wicklin  */
data Comments;
label Comment = "Number of Original Comments"
      Response = "Number of Responses";
input Commenter $20. Total Comment Response;
nickName = substr(Commenter, 1, find(Commenter," "));
if Total>30 then 
   truncName = nickName;
datalines;
Chris Hemedinger    653 92 561 
Rick Wicklin        501 74 427 
Robert Allison      247 25 222 
Sanjay Matange      148 11 137 
Michelle Homes      140 128 12 
Angela Hall         122 41 81 
Tricia Aanderud     115 99 16 
Waynette Tubbs      83 17 66 
John Balla          59 9 50 
Shelly Goodin       52 25 27 
Charu Shankar       45 11 34 
Mark Jordan         45 3 42 
Peter Flom          42 38 4 
Alison Bolen        38 11 27 
Quentin             35 31 4 
Sunil Gupta         34 32 2 
Mike Clayton        34 34 0 
Ian Wakeling        33 27 6 
Phil Simon          31 28 3 
Divyesh Dave        28 27 1 
Jim Harris          28 14 14 
Lisa Horwitz        27 1 26 
charu               25 8 17 
LeRoy Bessler       24 24 0 
Mike Gilliland      24 8 16 
Christina Harvey    23 4 19 
Faye Merrideth      23 20 3 
Peter Lancashire    22 19 3 
Anonymous           22 22 0 
Michael A. Raithel  21 10 11 
Paul Homes          20 20 0 
Chris               19 18 1 
Peter               19 15 4 
Kriss Harris        19 16 3 
Stefan Hauck        18 15 3 
Bernd Gunter        18 18 0 
Michele Reister     17 3 14 
Bradley Jones       17 0 17 
Xan Gregg           17 5 12 
jaap karman         16 15 1 
Bob                 15 12 3 
Dylan Jones         15 14 1 
Mark Stevens        15 2 13 
Daniel Valente      14 3 11 
Jared Prins         14 13 1 
AnnMaria            14 14 0 
James Marcus        13 9 4 
Kathy Council       13 3 10 
Clark Abrahams      13 1 12 
Cat Truxillo        13 12 1 
;
ods graphics / reset width=480 height=480;
/* 1. Show the standard scatter plot */
title "Comments and Responses on blogs.sas.com";
proc sgplot data=Comments noautolegend;
   scatter x=Comment y=Response / datalabel=TruncName;
   lineparm x=0 y=0 slope=1; 
   yaxis grid offsetmin=0.05;
   xaxis grid;
run;

/* 3. restrict to positive values */
ods graphics / width=480 height=600;
title "Automatic Log Transformation";
title2 "Comment>0 and Response>0";
proc sgplot data=Comments;
   where Comment>0 & Response > 0;
   scatter x=Comment y=Response / datalabel=NickName;
   xaxis grid type=log logstyle=logexpand minor offsetmin=0.01;
   yaxis grid type=log logstyle=logexpand minor offsetmin=0.05;
run;
title2;

/****************************************/
/****************************************/
/****************************************/

/* SAS program to accompany the article 
   "Assign colors in heat maps: A study of married couples and college majors"
   by Rick Wicklin, published 30APR2018 on The DO Loop blog:
   https://blogs.sas.com/content/iml/2018/04/30/married-couples-major-heat-map.html

   This program shows how two ways to assign colors to response values in a heat map:
   log-normal transformation and binning the values into catgories (often by using
   quantiles.

   The data are from Phillip N. Cohen (2018) and are available at
   https://osf.io/h2bny
   Cohen used the American Community Survey to cross-tabulated the 
   college majors of 27,806 married couples from 2009&ndash;2016. 
   The majors are classified into 28 disciplines such as Architecture, Business, 
   Computer Science, and so forth.
*/

data Marriage;
length Major $24;
label 
Agriculture      ="Agriculture"
Environment      ="Environment NatRes"
Architecture     ="Architecture"
EthnicCiv        ="Area/Ethnic/CivStud"
Communications   ="Communications"
Computer         ="Computer/InfoSci"
Education        ="Education Admin"
Engineering      ="Engineering"
EngineeringTech  ="Engineering Techn"
ForeignLang      ="Linguistics/Foreign"
Consumer         ="Family/Consumer Sci"
EnglishLit       ="English Language/Lit"
LiberalArts      ="LiberalArts/Human"
BiologyLife      ="Biology and LifeSci"
MathStats        ="Math/Stats"
Interdisc        ="Interdisc/multidisc"
PhysFitness      ="PhysFit, Park/Rec"
Philosophy       ="Philosophy/ReligStud"
TheoReligion     ="Theology/ReligVoc"
PhysicalSciences ="PhysicalSci"
Psychology       ="Psychology"
CriminalJustice  ="CrimJustice/Fire"
PublicAffairs    ="PubAff/Policy/SocWk"
SocialScience    ="SocialSci"
FineArts         ="Fine Arts"
MedicalHealth    ="Medical/HealthSci"
Business         ="Business"
History          ="History";
informat Agriculture--History COMMA6.;
input Major $1-24 Agriculture--History;
datalines;
Agriculture             4,845 893   118   0  326   1,501 592   3,574 202   0  232   185   0  1,498 296   0  365   0  65 573   582   472   188   839   613   918   3,515 337
Environment and Natur   356   2,265 434   104   613   666   311   2,232 40 0  0  937   148   1,292 315   0  307   309   0  746   383   179   57 2,170 392   954   1,885 315
Architecture            40 0  3,142 59 287   1,248 215   3,985 0  83 0  184   246   766   366   0  162   461   0  197   64 52 53 1,211 672   0  2,700 285
Area, Ethnic, and Civ   115   305   369   325   798   1,558 544   1,333 0  241   0  346   32 1,120 317   58 43 233   0  558   127   0  46 1,824 1,090 237   2,865 973
Communications          1,359 1,801 768   620   18,098   6,273 5,497 18,694   1,576 517   419   4,689 1,441 6,115 2,305 1,091 3,019 2,127 1,343 3,968 4,703 3,862 1,144 19,799   5,697 3,060 44,529   5,858
Computer and Informat   236   149   253   0  2,000 18,898   277   19,059   3,141 46 0  425   113   1,679 654   137   142   310   48 2,163 731   379   217   1,674 857   984   6,002 395
Education Administrat   5,603 3,123 2,237 604   11,247   14,701   39,081   32,055   3,046 1,145 777   5,200 3,689 11,039   3,683 1,794 7,032 2,007 4,247 6,501 7,728 8,772 614   20,835   10,346   6,842 68,669   11,525
Engineering             188   681   945   70 1,716 11,957   1,276 53,559   1,277 323   0  631   135   3,661 804   238   1,011 209   223   4,508 646   886   513   3,828 1,454 1,521 10,407   464
Engineering Technolog   147   0  0  0  58 1,530 527   3,850 810   91 0  0  0  615   86 66 64 73 51 0  74 0  0  394   347   341   1,257 0
Linguistics and Forei   114   818   549   167   1,540 2,567 1,353 6,057 462   1,326 0  1,840 54 2,737 1,321 437   1,260 681   216   1,313 916   604   309   6,127 2,311 401   7,086 1,841
Family and Consumer S   193   660   660   246   2,280 2,363 750   5,211 303   117   180   1,080 841   1,267 416   338   1,814 172   64 857   1,402 1,055 311   3,727 1,011 147   8,407 696
English Language, Lit   1,127 1,557 949   513   6,460 8,683 3,147 12,417   659   931   98 7,654 1,826 5,817 2,987 1,096 1,406 1,138 696   3,797 4,608 1,511 517   15,263   5,904 1,242 20,091   6,275
Liberal Arts and Huma   111   194   1,516 378   2,019 2,573 1,239 4,490 284   273   0  1,057 3,502 1,594 958   320   408   99 256   2,107 965   1,317 71 4,264 1,208 795   6,170 1,440
Biology and Life Scie   1,809 2,543 2,352 499   4,404 11,712   4,152 29,234   2,084 1,033 310   3,236 1,015 32,206   2,250 905   3,830 1,434 977   12,070   6,533 3,134 856   17,522   4,417 5,528 30,343   4,510
Mathematics and Stati   0  107   262   0  618   3,135 1,644 5,784 713   318   0  899   237   1,040 2,648 308   331   380   373   2,137 467   219   139   1,987 1,139 798   4,638 415
Interdisciplinary and   647   201   118   208   1,502 2,753 981   4,968 1,095 301   0  779   283   3,516 406   681   955   646   448   1,396 2,110 435   0  4,089 1,409 243   7,078 1,370
Physical Fitness, Par   587   322   239   52 1,055 1,511 2,187 4,219 975   214   130   373   259   2,652 100   400   4,908 212   107   708   1,099 779   570   3,539 827   939   12,584   1,498
Philosophy and Religi   162   281   200   67 566   752   228   2,196 169   352   0  626   107   615   672   407   121   1,384 168   386   866   398   0  1,467 789   89 2,040 876
Theology and Religiou   0  0  246   47 394   152   871   677   44 83 0  85 0  656   366   148   0  373   1,887 0  263   277   131   258   614   315   1,047 110
Physical Sciences       284   537   229   375   939   3,385 1,567 8,051 357   685   54 1,104 300   4,020 1,772 359   778   564   75 15,228   1,078 727   0  4,910 1,138 1,188 8,562 1,712
Psychology              1,859 2,778 1,694 567   8,103 10,600   6,375 23,018   871   985   921   3,590 1,292 9,138 2,790 1,648 3,877 4,123 1,517 4,931 11,057   5,880 1,528 21,584   9,962 3,591 42,329   7,518
Criminal Justice and    175   171   160   127   1,184 1,613 1,316 2,152 277   315   146   108   612   924   424   171   613   324   49 737   459   3,871 160   2,096 1,016 1,179 7,569 165
Public Affairs, Polic   626   244   441   460   1,590 2,669 1,340 4,771 462   437   149   1,163 460   1,761 160   55 334   273   290   1,775 1,580 794   1,410 3,397 409   559   10,054   480
Social Sciences         827   2,248 2,661 1,039 8,185 13,321   4,094 26,221   978   920   113   5,826 2,220 12,439   3,634 1,795 2,310 4,145 445   7,336 8,654 3,328 2,013 37,217   9,747 2,148 41,958   8,325
Fine Arts               909   1,778 2,679 535   8,854 10,573   6,164 17,134   1,083 1,097 170   6,298 2,006 3,538 2,145 907   2,663 1,735 1,190 3,690 3,327 2,612 544   15,680   27,720   1,754 28,870   3,609
Medical and Health Sc   2,228 3,290 1,500 580   7,952 11,840   11,383   38,484   2,884 1,235 853   3,514 2,233 20,391   3,220 1,532 8,478 2,337 1,280 7,548 8,907 6,738 1,366 17,861   4,841 21,248   57,165   6,702
Business                5,059 3,719 3,686 669   17,051   29,179   11,095   65,244   6,544 3,129 705   7,192 2,559 17,763   5,530 1,440 7,810 1,349 2,117 9,690 10,690   10,591   1,795 41,763   10,718   7,899 168,163  8,755
History                 191   569   740   74 1,499 2,044 1,845 4,438 125   175   63 2,057 180   2,595 689   235   713   1,404 299   1,233 1,600 899   166   7,086 1,889 628   8,425 3,855
;

title;
proc iml;
use Marriage;
   read all var _NUM_ into X[colname=VarNames];
close;

colMarg = X[+, ];       /* sum of each column */
rowMarg = X[ ,+];       /* sum of each row */
N= rowMarg[+];          /* total sample size */

/* Compute matrix of relative differences: (Obs - Expected)/Expected */
Expected  = rowMarg*colMarg / N;           /* expected values under hypothesis of independence */
RelDiff = (X - Expected) / Expected;       /* relative difference for each cell */
*print (RelDiff[1:8, 1:8])[F=6.2];
*print (min(RelDiff))[L="min(RelDiff)" F=6.2] (max(RelDiff))[L="max(RelDiff)" F=6.2];
p = "CXFFFFFF" || palette("YLGN", 5);  * WHITE YELLOW ... GREEN;
ods graphics / width=640px height=480px;
call heatmapcont(RelDiff) colorramp=p
                          title="Relative Difference: (Observed-Expected) / Expected" 
                          xvalues=varNames yvalues=varNames;

/* The Log-modulus transform:
   https://blogs.sas.com/content/iml/2014/07/14/log-transformation-of-pos-neg.html
*/
start LogModulus(x);
  return  sign(x) # log10(abs(x) + 1);
finish;

/* 3. Compute matrix of log-modulus of the relative differences */
logDiff = logModulus(RelDiff);
pUpper = Palette("YLGNBU", 4); /* sequential colors greater than 0 */
pLower = Palette("YLORRD", 3); /* sequential colors less than 0 */
p = pLower[3] || pUpper;
call heatmapcont(logDiff) colorramp=p
                          title="log10(Relative Difference)" 
                          xvalues=varNames yvalues=varNames
                          /*xaxistop=1*/
                          range={-0.501 1.501} debug=1;

QUIT;

/********************************************/
/********************************************/
/********************************************/

/* simulate data from a mixture of three exponential distributions */
data Counts;
call streaminit(123);
do i = 1 to 1100;
   if i < 800 then scale=2000;
   else if i < 1000 then scale = 5000;
   else scale = 14000;
   Views = int( rand("Expo", scale) ); 
   if Views > 200 then
      output;
end;
drop i;
run;

title "Constant Bin Widths on a Log Scale";
proc sgplot data=Counts;
   histogram Views / binwidth=2000 binstart=1100;
   xaxis type=log logbase=10 label="Views (log10 spacing)";
   yaxis grid;
run;

/* Log-transform the X values and use non-constant bins */
data Pg / view=Pg;
set Counts;
if Views <= 0 then 
   log10Count = .;
else
   log10Count = log10(Views);
run;
 
title "Log(Pageviews) for Top Blog Articles";
proc sgplot data=Pg;
   histogram log10Count;
   xaxis label="log10(Count)" values=(2 to 5 by 0.5);
   yaxis grid;
run;

title; footnote; ods graphics / pop;
