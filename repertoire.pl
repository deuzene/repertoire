#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

my @repertoire ;                # le repertoire (array de hash)
my $fichier = "repertoire";  # fichier

sub affiche_repertoire;     sub affiche_entrees;    sub ajouter_entree;
sub ecrire_repertoire;      sub modifier_entree;    sub ouvrir_repertoire;
sub rechercher;             sub supprimer_entree;

#TODO: ajouter adresse
# ### programme principal #####################################################
ouvrir_repertoire($fichier);

while (1){
    print "(A)jouter une entrée (R)echercher (V)oir le répertoire (..)quitter\n";
    print "Choix : ";
    my $reponse;
    chomp ($reponse = <>);
    $reponse = lc($reponse);
    ajouter_entree        if ($reponse eq "a");
    rechercher            if ($reponse eq "r");
    affiche_repertoire    if ($reponse eq "v");
    exit                  if ($reponse eq "..");
}

ecrire_repertoire($fichier);
# ### fin programme principal #################################################

# #############################################################################
# sub: ouvrir_repertoire
# arg:
# usage: ouvrir_repertoire
# invoque: ajouter_entree si le fichier n'existe pas
# ouvre le fichier $repertoire s'il existe et rempli @repertoire avec les données
# #############################################################################
sub ouvrir_repertoire {
    my $fichier = shift;
    if ( -e $fichier ) {
        open my $REP, "<", "$fichier" or die "Impossible de lire $fichier : $!";

        while (<$REP>) {
            chomp;
            my ($prenom, $nom, $mail, @tels) = split(/#/);
            push @repertoire,{ 'prenom' => $prenom,
                               'nom'    => $nom,
                               'mail'   => $mail,
                               'tels'   => [@tels]
                             };
        }
        close $REP;
    } else {
        ajouter_entree; # si le fichier n'existe pas creer repertoire
    }
    return;
}

# #############################################################################
# sub: ecrire_repertoire
# arg:
# usage: ecrire_repertoire
# parcours @repertoire et écrit le fichier repertoire
# #############################################################################
sub ecrire_repertoire {
    my $fichier = shift;
    open my $REP, ">", "$fichier"
        or die "Impossible d'ouvrir $fichier en écriture : $!";

    foreach my $personne (@repertoire) {
        print $REP $personne->{'prenom'} . "#"    # on sépare les champs
                 . $personne->{'mail'}   . "#"    # avec des dièses
                 . $personne->{'nom'}    . "#";

        foreach my $tel (@{$personne->{'tels'}}) { # parcours du tableau tels
            print $REP $tel . "#";
        }
        print $REP "\n";
    }
    close $REP;
    return;
}

# #############################################################################
# sub: ajouter_entree
# arg:
# usage: ajouter_entree
# invoque: ecrire_repertoire
# ajoute des entrées au tableau @repertoire
# #############################################################################
sub ajouter_entree {
    my $reponse = "o";
    my $tel="";
    my @tels=();

    while ( $reponse eq "o" ) {
        print "Prenom : ";
        chomp (my $prenom = <>);
        print "Nom : ";
        chomp (my $nom = <>);
        print "email : ";
        chomp (my $mail = <>);

        while ( $tel ne "." ) {
            print "Téléphone : ";
            chomp ($tel = <> );
            push @tels, $tel unless $tel eq ".";
        }

        push @repertoire, {
                           'prenom' => $prenom,
                           'nom'    => $nom,
                           'tels'    => [@tels]
                          };

        print "Ajouter une autre entrée ? (o/n) ";
        chomp ($reponse = <>);
        $reponse = lc($reponse);
    }
    ecrire_repertoire;
    return;
}

# #############################################################################
# sub: affiche_repertoire
# arg:
# usage: affiche_repertoire
# parcours et affiche @repertoire dans sa totalité
# #############################################################################
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

# #############################################################################
# sub: modifier_entree
# arg: index de l'entrée du tableau @repertoire
# usage: modifier_entree (index)
# invoque: ecrire_repertoire
# permet de mofifier une entrée (modif nom, prénom, tel - ajout/suppression tél.)
# #############################################################################
sub modifier_entree {
    my $index = shift;

    while (1) {
        my $reponse;

        printf "%-20s %-20s %-30s",
                $repertoire[$index]{'prenom'},
                $repertoire[$index]{'nom'},
                $repertoire[$index]{'mail'};
        my $count = 0;
        foreach (@{$repertoire[$index]{tels}}){
            printf "[%u] %-20s", $count, $_;
            $count++;
        }
        print "\n";
        print "Modifier (P)rénom (N)om (M)ail (n°)Téléphone (A)jouter tél. (S)upprimer tel. (.)Écrire : ";
        chomp ($reponse = <>);
        $reponse = lc($reponse);

        if ( "$reponse" eq "p" ) {
            print "Nouveau prénom : ";
            chomp (my $nvPrenom = <>);
            $repertoire[$index]{'prenom'} = $nvPrenom;
        } elsif ( "$reponse" eq "n" ) {
            print "Nouveau nom : ";
            chomp (my $nvNom = <>);
            $repertoire[$index]{'nom'} = $nvNom;
        } elsif ( "$reponse" eq "m" ){
            print "Nouvel email";
            chomp (my $nvMail);
            $repertoire[$index]{'mail'} = $nvMail;
        } elsif ( $reponse =~ /\d/ ){
            print "Nouveau téléphone : ";
            chomp (my $nvTel = <>);
            $repertoire[$index]{'tels'}[$reponse] = $nvTel;
        } elsif ( "$reponse" eq "a" ){
            print "Nouveau téléphone : ";
            chomp (my $telPlus = <>);
            push @{$repertoire[$index]{'tels'}}, $telPlus;
        } elsif ( "$reponse" eq "s" ){
            $count = 0;
            foreach ( @{$repertoire[$index]{tels}} ){
                printf "[%u] %-20s", $count, $_;
                $count++;
            }
            print "N° à supprimer : ";
            chomp (my $choix = <>);
            splice @{$repertoire[$index]{tels}}, $choix, 1;
        } elsif ( "$reponse" eq "." ) {
            last;
        }
    }
    ecrire_repertoire;
    return;
}


# #############################################################################
# sub: supprimer_entree
# arg: index de l'entrée à supprimer
# usage: supprimer_entree (index)
# invoque ecrire_repertoire
# supprime l'entrée index de @repertoire
# #############################################################################
sub supprimer_entree {
    my $index = shift;
    my $reponse;

    printf "Êtes-vous sur de vouloir supprimer : %s %s\n",
            $repertoire[$index]{prenom}, $repertoire[$index]{nom};
    print "o/n : ";
    chomp ($reponse = <>);
    $reponse = lc($reponse);

    splice (@repertoire, $index, 1) if ("$reponse" eq "o");

    ecrire_repertoire;
    return;
}

# #############################################################################
# sub: affiche_entrees
# arg: liste d'entrées à afficher
# usage: affiche_entrees(@liste)
# invoque : supprimer_entree, modifier_entree
# affiche les entrées passées en argument
# #############################################################################
sub affiche_entrees {
    my @liste = @_;
    my $reponse;

    foreach my $i ( @liste ) {
        my $aff = sprintf "[%5s]: %-20s %-20s %-30s",
                          $i,
                          $repertoire[$i]{'prenom'},
                          $repertoire[$i]{'nom'},
                          $repertoire[$i]{'mail'};

        foreach my $j ( @{$repertoire[$i]{'tels'}} ){
            $aff .= sprintf "%-15s", $j;
        }
        say $aff;
    }

    print "Choix : ";
    chomp (my $index = <>);
    return if ( "$index" eq "." );
    return if ( "$index" !~ /\d+/ );

    my $aff = sprintf "[%5s]: %-20s %-20s %-30s",
                      $index,
                      $repertoire[$index]{'prenom'},
                      $repertoire[$index]{'nom'},
                      $repertoire[$index]{'mail'};

    foreach my $j ( @{$repertoire[$index]{'tels'}} ){
        $aff .= sprintf "%-15s", $j;
    }

    say $aff;
    print "(M)odifier (S)upprimer (.)retour : ";
    chomp ($reponse = <>);
    $reponse = lc($reponse);

    return                    if ("$reponse" eq ".");
    modifier_entree ($index)  if ("$reponse" eq "m");
    supprimer_entree ($index) if ("$reponse" eq "s");
    return;
}


# #############################################################################
# sub: rechercher
# arg:
# usage: recherche les entrée correpondant au motif
# invoque: affiche_entrees
# #############################################################################
sub rechercher {
    my $motif;              # motif à rechercher
    my @trouves;            # liste des élément trouvés
    my $index = 0;          # index de l'élément dans @repertoire

    print "Motif : ";
    chomp ($motif = <>);

    foreach my $ligne ( @repertoire ) {
        while ( my ($clef, $valeur) = each %$ligne ) {
            if ( $valeur =~ /$motif/ ){
                push @trouves, $index;
                next;
            }
        }
        $index++;
    }

    affiche_entrees (@trouves);
    return;
}
