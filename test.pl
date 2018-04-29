#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";



use Storable;
my $ref = retrieve('rep.st');
my @repertoire = @$ref;

sub affiche_repertoire {
    foreach my $personne ( @repertoire ) {     # parcours tout le répertoire
        printf "%-20s %-20s %-30s",
                $personne->{'prenom'}, $personne->{'nom'}, $personne->{'mail'};

        foreach my $tel ( @{$personne->{'tels'}} ) {
            printf "%-15s", $tel;
        }

        print "\n";
    }
    return;
}

affiche_repertoire;
