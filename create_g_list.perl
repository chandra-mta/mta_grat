#!/usr/bin/perl 

#################################################################################################################################
#																#
#	create_g_list.perl: create an input file (obs2html.lst) for idl code: obs2html.pro which generate grat index.html page	#
#																#
#			author: t. isobe (tisobe@cfa.harvard.edu)								#
#																#
#			Last update: Sep. 29, 2011										#
#																#
#################################################################################################################################

#
#--- sot_ocat.out has all data
#

open(FH, "/proj/web-icxc/cgi-bin/obs_ss/sot_ocat.out");
while(<FH>){
	chomp $_;
#
#--- extract acis-s/hetg information
#
	if($_ =~ /ACIS-S/i && $_=~/HETG/i && $_ =~ /archived/){
		@atemp = split(/\^/, $_);
		$obsid = $atemp[1];
		$obsid = int($obsid);
		$time  = $atemp[13];

		conv_date($time);		#--- converting time format

#
#--- save time in 20010101 format so that we can sort later. Then put all other info in a hash table
#
		push(@acis_hetg, $odr_date);
		%{a_hetg.$odr_date} = (dir_date => ["$dir_date"], dsp_date => ["$dsp_date"], obsid => ["$obsid"]);

#
#--- extract acis-s/letg information
#
	}elsif($_ =~ /ACIS-S/i && $_=~/LETG/i && $_ =~ /archived/){
		@atemp = split(/\^/, $_);
		$obsid = $atemp[1];
		$obsid = int($obsid);
		$time  = $atemp[13];

		conv_date($time);

		push(@acis_letg, $odr_date);
		%{a_letg.$odr_date} = (dir_date => ["$dir_date"], dsp_date => ["$dsp_date"], obsid => ["$obsid"]);

#
#--- extract hrc/letg information
#
	}elsif($_ =~ /HRC-S/i && $_=~/LETG/i && $_ =~ /archived/){
		@atemp = split(/\^/, $_);
		$obsid = $atemp[1];
		$obsid = int($obsid);
		$time  = $atemp[13];

		conv_date($time);

		push(@hrc_letg, $odr_date);
		%{h_letg.$odr_date} = (dir_date => ["$dir_date"], dsp_date => ["$dsp_date"], obsid => ["$obsid"]);
	}
}
close(FH);

system("mv obs2html.lst obs2html.lst~");
open(OUT, ">obs2html.lst");
open(EOUT, ">grat_missing");				#---- a list of missing data from the directory

print OUT "ACIS-S/LETG\n";

#
#--- sort the data indesending order
#

@temp = sort{$a<=>$b} @acis_letg;
@temp = reverse(@temp);
$chk = '';
foreach $ent (@temp){

#
#--- remove duplicates and also only list data with output
#
	if($chk != ${a_letg.$ent}{obsid}[0]){
		$input = `ls ${a_letg.$ent}{dir_date}[0]/`;
		@list  = split(/\s+/, $input);
		$mchk = 0;
		foreach $ob_chk (@list){
#print " I AM HERE: $ob_chk<---->${a_letg.$ent}{obsid}[0]\n";
			if($ob_chk == ${a_letg.$ent}{obsid}[0]){
				print OUT "${a_letg.$ent}{dir_date}[0] ${a_letg.$ent}{dsp_date}[0] ${a_letg.$ent}{obsid}[0]\n";
				$chk = ${a_letg.$ent}{obsid}[0];
				$mchk= 1;
			}
		}
		if($mchk == 1){
			print EOUT "ACIS-S/LETG: ${a_letg.$ent}{dir_date}[0] ${a_letg.$ent}{dsp_date}[0] ${a_letg.$ent}{obsid}[0]\n"
		}
	}
}

print OUT "ACIS-S/HETG\n";
@temp = sort{$a<=>$b} @acis_hetg;
@temp = reverse(@temp);
$chk  = '';
foreach $ent (@temp){
	if($chk != ${a_hetg.$ent}{obsid}[0]){
		$input = `ls ${a_hetg.$ent}{dir_date}[0]/`;
		@list  = split(/\s+/, $input);
		$mchk  = 0;
		foreach $ob_chk (@list){
			if($ob_chk == ${a_hetg.$ent}{obsid}[0]){
				print OUT "${a_hetg.$ent}{dir_date}[0] ${a_hetg.$ent}{dsp_date}[0] ${a_hetg.$ent}{obsid}[0]\n";
				$chk = ${a_hetg.$ent}{obsid}[0];
				$mchk = 1;
			}
		}
		if($mchk == 0){
			print EOUT "ACIS-S/HETG: ${a_hetg.$ent}{dir_date}[0] ${a_hetg.$ent}{dsp_date}[0] ${a_hetg.$ent}{obsid}[0]\n";
		}
	}
}

print OUT "HRC-S/LETG\n";
@temp = sort{$a<=>$b} @hrc_letg;
@temp = reverse(@temp);
$chk  = '';
foreach $ent (@temp){
	if($chk != ${h_letg.$ent}{obsid}[0]){
		$input = `ls ${h_letg.$ent}{dir_date}[0]/`;
		@list  = split(/\s+/, $input);
		$mchk  = 0;
		foreach $ob_chk (@list){
			if($ob_chk == ${h_letg.$ent}{obsid}[0]){
				print OUT "${h_letg.$ent}{dir_date}[0] ${h_letg.$ent}{dsp_date}[0] ${h_letg.$ent}{obsid}[0]\n";
				$chk = ${h_letg.$ent}{obsid}[0];
				$mchk = 1;
			}
		}
		if($mchk == 0){
			print EOUT "HRC-S/LETG: ${h_letg.$ent}{dir_date}[0] ${h_letg.$ent}{dsp_date}[0] ${h_letg.$ent}{obsid}[0]\n";
		}
	}
}

close(EOUT);
close(OUT);

############################################################################################################
###  conv_date: convert data fromat from Jan 01 2011 to three different formats                         ####
############################################################################################################

sub conv_date{
	($line) = @_;
	@btemp = split(/\s+/, $line);

	if($btemp[0] =~ /Jan/){
		$lman = 'Jan';
		$dmon = '01';
	}elsif($btemp[0] =~ /Feb/){
		$lman = 'Feb';
		$dmon = '02';
	}elsif($btemp[0] =~ /Mar/){
		$lman = 'Mar';
		$dmon = '03';
	}elsif($btemp[0] =~ /Apr/){
		$lman = 'Apr';
		$dmon = '04';
	}elsif($btemp[0] =~ /May/){
		$lman = 'May';
		$dmon = '05';
	}elsif($btemp[0] =~ /Jun/){
		$lman = 'Jun';
		$dmon = '06';
	}elsif($btemp[0] =~ /Jul/){
		$lman = 'Jul';
		$dmon = '07';
	}elsif($btemp[0] =~ /Aug/){
		$lman = 'Aug';
		$dmon = '08';
	}elsif($btemp[0] =~ /Sep/){
		$lman = 'Sep';
		$dmon = '09';
	}elsif($btemp[0] =~ /Oct/){
		$lman = 'Oct';
		$dmon = '10';
	}elsif($btemp[0] =~ /Nov/){
		$lman = 'Nov';
		$dmon = '11';
	}elsif($btemp[0] =~ /Dec/){
		$lman = 'Dec';
		$dmon = '12';
	}

	$date = $btemp[1];
	if($date < 10){
		$date = '0'."$date";
	}

	@ctemp = split(//, $btemp[2]);
	$year = "$ctemp[2]$ctemp[3]";

	$dir_date = "$lman"."$year";
	$odr_date = "$btemp[2]"."$dmon"."$date";
	$dsp_date = "$dmon".'/'."$date".'/'."$year";
}

	

