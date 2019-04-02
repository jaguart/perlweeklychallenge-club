#!/usr/bin/env perl
#
# Solution to challenge #2 of the Perl Weekly Challenge 002.
#
# Task: Write a script that can convert integers to and from a base35
# representation, using the characters 0-9 and A-Y. 
#
# Prerequisites: cpan install Scalar::Util::Numeric
#
# Usage:
# > echo {0.999} | ./ch-02.pl to
#
# Test with:
# >  echo {0..99} | ./ch-02.pl to | awk '{print $3}' | ./ch-02.pl from

use strict;
use warnings;
use Scalar::Util::Numeric qw(isint);
use Data::Dump;

use v5.10;

my $BASE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXY";

exit 1 unless @ARGV == 1;
my $switch = $ARGV[0];

while (<STDIN>) {
	chomp;
	# TODO: find out how to stream input, instead of saving it to an array first
	my @input = split;
	for my $i (@input) {
		my $output;
		if ($switch eq "to") {
			$output = toBase35($i);
		} elsif ($switch eq "from") {
			$output = fromBase35($i);
		} else {
			say "Please specify to/from";
			exit 2;
		}
		# `pretty' print output
		printf "%-4s\t==>\t%-4s\n", $i, $output;
	}
}
exit 0;

sub toBase35 {
	my $input = shift;
	my @base = split "", $BASE;
	my @convert;
	my $baseNum = @base;
	my $max = 0;
	while (1) {
		last unless $baseNum ** ++$max <= $input;
	}
	while ($max > 0) {
		my $exp = $max - 1;
		#print "$baseNum to the $exp is ", $baseNum ** $exp, " which is smaller than $input\n";
		my $pow = $baseNum ** $exp;
		my $place = 0;
		while ($pow <= $input) {
			$input -= $pow;
			$place++;
			#print "input $input; place $place\n";
		}
		push @convert, $place;
		$max--;
	}
	#print "@convert: ";
	#dd @convert;
	#print "\n";
	my $output = join "", @base[@convert];
}

sub fromBase35 {
	my $input = shift; # APX

	# create a hash converting a base35 alphanumeric character to a base10 value
	my %hash;
	my @base = split "", $BASE;
	for my $i (0..@base-1) {
		$hash{$base[$i]} = $i;
	}

	my @based = split "", $input; #  (A, P, X)
	my $max = @based - 1;
	my $output;
	while ($max >= 0) {
		$output += ( @base ** $max ) * $hash{@based[@based - $max - 1]};
		$max--;
	}
	return $output;
}
