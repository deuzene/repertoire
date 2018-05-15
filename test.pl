#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";
use Storable ;

my $fichier = "repertoire" ;
my @repertoire ;

sub ouvrir_repertoire {
    if ( -e $fichier ) {
        my $ref = retrieve "$fichier" ;
        @repertoire = @{$ref} ;
    } else {
        # ajouter_entree ; # si le fichier n'existe pas creer repertoire
    }
    return ;
}
ouvrir_repertoire ;

@repertoire = sort {
                     $a->{'prenom'} cmp $b->{'prenom'}
                   } @repertoire ;

                   ### @repertoire
