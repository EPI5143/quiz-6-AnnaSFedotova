libname classdat '/folders/myfolders/classdata';
run;

/*Sorting patients by ID in the data*/

proc sort data=classdat.nencounter out=encounters;
by encpatwid;
run;

/*Flat-filing by keeping only the encounter IDs, Patient IDs, encounter types, and keeping only 2003 data*/

data encounters;
set classdat.nencounter(keep=encwid encpatwid encstartdtm encvisitTypeCd);
encdate=datepart (encstartdtm);
if encdate<'01JAN2003'd
or encdate> '31DEC2003'd then delete;
run;

/*Determining how many patients have had at least 1 inpatient encounter that started in 2003*/

data encounters;
set encounters;
if encvisitTypeCd in ('INPT');
run;

/*Determining how many patients have had at least 1 emergency room encounter that started in 2003*/
/*only works if the inpatient code isn't run beforehand :P*/

data encounters;
set encounters;
if encvisitTypeCd in ('EMERG');
run;

/*Sorting and getting rid of duplicates as to patients, which shows how many had at least one visit (question c)*/

proc sort data=encounters out=unique_enc nodupkey;
by encpatwid;
run;

/*Attempt at counting either inpatient encounters, ER encounters, or both by patients*/

data encounters2;
set unique_enc;
by encpatwid;
if encVisitTypeCd in:('INPT' 'EMERG') then do; 
enc=1;
end;
else if encVisitTypeCd in: ('INPT') and encVisitTypeCd in: ('EMERG') then do;
enc=2;
end;
run;

/*Made the above into a table but unfortunately text-friendly version didn't run*/

options formchar="|----|+|---+=|-/\<>*";
title 'Types of encounters (inpatient or ER) by patient';
proc freq data=encounters2;
tables enc;
run;

