#!/usr/bin/perl

use strict;
use warnings;
use Lingua::PT::PLNbase;
use File::Basename;

my @var = <STDIN>;

my $text = '';

foreach my $y (@var) {
    $text = join '', $text, $y;
    }
    
my @frases = frases($text);

my $output = '';

foreach my $line (@frases){
    $output = join '', $output,$line,"\n";
    }

print $output;
