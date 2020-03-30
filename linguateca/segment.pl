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
    
my $frases = separa_frases("$text ");

print $frases;
