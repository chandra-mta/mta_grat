#! /usr/bin/perl

$tmp1 = "xtmp1";

open (LIST, "obslist");
open (FLIST, ">$tmp1");

<LIST>;  # skip first line
while (<LIST>) {
  chomp $_;
  $file = `ls $_/obsid*summ*.html`;
  print FLIST "$file\n";
}

close LIST;
close FLIST;

open (FLIST, "$tmp1");
open (fah, ">foc_acis_hetg.txt");
open (fal, ">foc_acis_letg.txt");
open (fhl, ">foc_hrc_letg.txt");

while (<FLIST>) {
  chomp $_;
  open (FILE, "$_");
  
  while (<FILE>) {
    if ($_ =~ 

  
for file in `tail +2 obslist`; do
  ls $file/obsid*summ*.html >> xtmplst
done

if (test -s xtmplst); then
   rm -f foc_acis_hetg.txt
   rm -f foc_acis_letg.txt
   rm -f foc_hrc_letg.txt

   for file in `cat xtmplst`; do
     if (/usr/xpg4/bin/grep -q "HETG" $file); then
       if (/usr/xpg4/bin/grep -q "ACIS-S" $file); then
         echo "$file" >> foc_acis_hetg.txt
         grep "Start time" $file | head -1 >> foc_acis_hetg.txt
         grep "AX LRF at 10" $file >> foc_acis_hetg.txt
         grep "AX LRF at 50" $file >> foc_acis_hetg.txt
         grep "Streak LRF at 10" $file >> foc_acis_hetg.txt
         grep "Streak LRF at 50" $file >> foc_acis_hetg.txt
       fi
     fi
     if (/usr/xpg4/bin/grep -q "LETG" $file); then
       if (/usr/xpg4/bin/grep -q "ACIS-S" $file); then
         echo "$file" >> foc_acis_letg.txt
         grep "Start time" $file | head -1 >> foc_acis_letg.txt
         grep "AX LRF at 10" $file >> foc_acis_letg.txt
         grep "AX LRF at 50" $file >> foc_acis_letg.txt
         grep "Streak LRF at 10" $file >> foc_acis_letg.txt
         grep "Streak LRF at 50" $file >> foc_acis_letg.txt
       fi
       if (/usr/xpg4/bin/grep -q "HRC-S" $file); then
         echo "$file" >> foc_hrc_letg.txt
         grep "Start time" $file | head -1 >> foc_hrc_letg.txt
         grep "AX LRF at 10" $file >> foc_hrc_letg.txt
         grep "AX LRF at 50" $file >> foc_hrc_letg.txt
         grep "Streak LRF at 10" $file >> foc_hrc_letg.txt
         grep "Streak LRF at 50" $file >> foc_hrc_letg.txt
       fi
     fi
   done
fi

rm -f xtmplst

#end
