#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

my $aff = sprintf "[%5s]: %-20s %-20s", $index,  $repertoire[$index]{'prenom'}, $repertoire[$index]{'nom'};

foreach my $j (@{$repertoire[$index]{'tels'}}){
    $aff .= sprintf "%-15s", $j;
}
