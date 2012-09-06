#!/usr/bin/perl

@new_files=`ls *fits`;
open (OUT,">mkcommand.out");
print OUT "\@/home/brad/Gratings/hak_1.4/hak_start\n\n";
for ($ifiles=0;$ifiles<=$#new_files;$ifiles++) {
  $file=$new_files[$ifiles];
  chomp $file;
  $command="dmkeypar $file OBS_ID echo+";
  $obsid=`$command`; 
  chomp $obsid;
  $date=`dmkeypar $file DATE-OBS echo+`;
  chomp $date;
  $roll=`dmkeypar $file ROLL_NOM echo+`;
  chomp $roll;
  $inst=`dmkeypar $file DETNAM echo+`;
  chomp $inst;
  $grat=`dmkeypar $file GRATING echo+`;
  chomp $grat;
  $mode=`dmkeypar $file DATAMODE echo+`;
  chomp $mode;
  print "$new_files[$ifiles] $date $obsid $inst $grat $roll $mode\n";

  print OUT "spawn, \'mkdir /data/mta/www/mta_grat/Dec08/$obsid\'\n";
  print OUT "obs_anal, \'$file\', \$\n";
  print OUT "   OUTPUT_PREFIX = \'obsid_$obsid\', \$\n";
  print OUT "   OUT_DIR=\'/data/mta/www/mta_grat/Dec08/$obsid\', \$\n";
  print OUT "   COORDS_NAME=\'Sky\', /FLIPY, ROLLAXAY=\-$roll, \$\n";
  print OUT "   /OVERRIDE_ZERO, /ZBUFFER, OVERR_WIDTH=200.0, \$\n";
  print OUT "   /CENTER_FIT, \$\n";
  print OUT "   CD_WIDTH=0.5, /LINE, \$\n";
  print OUT "   GRATING=\'$grat\', DETECTOR=\'$inst\', \$\n";
  print OUT "   ORDER_SEL_ACCURACY = 0.3, \$\n";
  print OUT "   /EXPORT\n";
  print OUT "retall\n";

}
print OUT "exit\n";
close OUT;

#end
