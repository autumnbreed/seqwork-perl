#! /usr/bin/perl -w
use 5.010;
use strict;
use warnings;
#use Data::Dumper;
open(FN,"$ARGV[0]");
open(SE,"$ARGV[1]");
open(OUTSEQ, ">>./seqout.fasta")|| die "Cannot open the file: $!\n";

my ($seq,$name,@line,$chr,$num,@part,$hed,$end,@sp,$call,$in,$dia,%main,@keys,$key,$value,$len,$l,$want,$bp);
$bp='bp';
while (<FN>) {
    chomp;
    if(/^>/)  {
        $_=~/>(.*?)(\s)(.*?)$/;
		$name=$1;
    }
    else {
        $seq=$seq.$_;
    }
    $main{$name}=$seq;
}

while (<SE>)
{
	chomp;
	@line=split(/\s/);
	$chr=shift(@line);
	foreach $num(@line) {
		@part=($chr, $num);
		push @sp,[@part];
	}

}

for $in(@sp) {
	$call=$in->[0];
	$dia=$in->[1];
	$hed=$dia-6;
	#die "meet short sequence $!\n" if $hed<1;
	$end=$dia+16;
	$l=($dia+22);
	@keys = keys(%main);	#@vals = values(%alphabet);
	# loop over hash
	while (($key, $value) = each(%main) ) {
		if ($key=~$call) {
			$len=length($value);
			die "meet short sequence $!\n" if $end>$len;
			$want=substr($value,$hed,$l);
			print OUTSEQ (">$key $dia.$l$bp\n");
			print OUTSEQ ("$want\n");
			print OUTSEQ ("\n");
		}
	}
}

close FN;
close SE;
close OUTSEQ;
#print Dumper(\%main);
exit;