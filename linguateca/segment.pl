#!/usr/bin/perl

use strict;
use warnings;
use Lingua::PT::PLNbase;
use File::Basename;

opendir my $dir, "treated_raw" or die "Não foi possível encontrar o diretório treated_raw na pasta!";

my @arquivos = readdir $dir;
closedir $dir;
my $i = 0;

foreach my $p (@arquivos) {
    my $len = @arquivos;
    open my $fh, '<', "treated_raw/$p" or die "Não foi possível abrir o arquivo raw/$p!";
    my $texto = do {local $/; <$fh>};
    my @frases = frases($texto);
    my $name = fileparse($p,'.raw');
    my $arq = "$name.sent";
    open my $out, '>', "PLNbase/$arq" or die "Não foi possível abrir o arquivo PLNbase/$arq!";
    foreach my $line (@frases){
        unless ($line eq "\n"){
            print $out $line;
            print $out "\n";
        }
    }
    $i = $i + 1;
    my $load = 100*$i/$len;
    print "$load% loaded... \r";
    close $out;
}
    
print "Pronto."

