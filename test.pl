#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

<<<<<<< HEAD
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
        ajouter_entree(); # si le fichier n'existe pas creer repertoire
=======
my $repertoire = "repertoire";    # fichier
my @repertoire;                   # le repertoire (array de hash)

sub ouvrir_repertoire {
    if ( -e $repertoire ) {
        open my $REP, "<", "$repertoire"
            or die "Impossible de lire $repertoire : $!";

        while (<$REP>) {
            chomp;
            my ( $prenom, $nom, @tels ) = split(/#/);
            push @repertoire, {
                                'prenom' => $prenom,
                                'nom'    => $nom,
                                'tels'   => [@tels]
                              };
        }
        close $REP;
    }
    else {
        ajouter_entree();    # si le fichier n'existe pas creer repertoire
>>>>>>> tels
    }
    return;
}

sub ecrire_repertoire {
<<<<<<< HEAD
    open my $REP, ">", "$repertoire" or die "Impossible d'ouvrir $repertoire en écriture : $!";

    my $count = 0;
    foreach (@repertoire){
        print $REP $repertoire[$count]{'prenom'} . "#";       # on sépare les champe
        print $REP $repertoire[$count]{'nom'}    . "#";
        foreach (@repertoire[$count]->{tels}){
            print $REP $_ . "#";
        }
=======
    open my $REP, ">", "$repertoire"
        or die "Impossible d'ouvrir $repertoire en écriture : $!";

    foreach my $personne (@repertoire) {
        print $REP $personne->{'prenom'} . "#"    # on sépare les champs
                 . $personne->{'nom'}    . "#";   # avec des dièses
        foreach my $tel (@{$personne->{'tels'}}) {
            print $REP $tel              . "#";
        }
        print $REP "\n";
>>>>>>> tels
    }
    close $REP;
    return;
}

<<<<<<< HEAD
ouvrir_repertoire;
ecrire_repertoire;
=======
sub affiche_repertoire {
    foreach my $personne (@repertoire) {     # parcours tout le répertoire
        printf "%-20s %-20s", $personne->{prenom}, $personne->{nom};
        foreach my $tel (@{$personne->{'tels'}}) {
            printf "%-15s", $tel;
        }
        print "\n";
    }
    return;
}

sub ajouter_entree {
    my $reponse = "o";
    my ($nom, $prenom);
    my $tel="";
    my @tels=();

    while ($reponse eq "o") {
        print "Prenom : ";
        chomp ($prenom = <>);
        print "Nom : ";
        chomp ($nom = <>);

        while ($tel ne ".") {
            print "Téléphone : ";
            chomp ($tel = <> );
            push (@tels, $tel) unless ($tel eq ".");
        }

        push @repertoire, {
                           'prenom' => $prenom,
                           'nom'    => $nom,
                           'tels'    => [@tels]
                          };

        print "Ajouter une autre entrée ? (o/n) ";
        chomp ($reponse = <>);
    }
    # print Dumper @repertoire;
    return;
}

ouvrir_repertoire;
ajouter_entree;
affiche_repertoire;
>>>>>>> tels
