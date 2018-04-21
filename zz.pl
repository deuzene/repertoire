#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

my $repertoire = "repertoire";  # fichier
my @repertoire ;                # le repertoire (array de hash)
my ($nom, $prenom, $tel);       # variables temporaires
my @tels;                       # liste de n° de téléphone

sub ouvrir_repertoire {
    if (-e $repertoire) {
        open my $REP, "<", "$repertoire" or die "Impossible de lire $repertoire : $!";

        while (<$REP>) {
            chomp;
            ($nom, $prenom, @tels) = split(/#/);
            ### nom: $nom
            ### prenom: $prenom
            ### tel: @tels
            push (@repertoire,{ 'prenom' => $prenom,
                                'nom'    => $nom,
                                'tels'   => [@tels]
                              });
        }
        ### @repertoire
        close $REP;
    } else {
        # ajouter_entree(); # si le fichier n'existe pas creer repertoire
    }
    return;
}

ouvrir_repertoire;
