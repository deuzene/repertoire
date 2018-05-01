#!/usr/bin/env perl
use strict ;
use warnings ;
use diagnostics ;
use Smart::Comments ;
use Data::Dumper ;
use feature ":5.24" ;

use Storable ;
use Term::ReadKey;

my @repertoire  ;                # le repertoire (array de hash)
my $fichier = "repertoire" ;     # fichier de sauvegarde

sub affiche_repertoire ;     sub aff_liste_entrees ;    sub ajouter_entree ;
sub ecrire_repertoire ;      sub modifier_entree ;      sub ouvrir_repertoire ;
sub rechercher ;             sub supprimer_entree ;     sub is_def;

#TODO: trier le repertoire par ordre alpha. de prénom
# ### programme principal #####################################################
ouvrir_repertoire ;

while (1){
    print "(A)jouter une entrée (R)echercher (V)oir le répertoire (.)quitter\n" ;
    print "Choix : " ;
    chomp (my $reponse = <>) ;
    ajouter_entree        if ($reponse eq "a") ;
    rechercher            if ($reponse eq "r") ;
    affiche_repertoire    if ($reponse eq "v") ;
    exit                  if ($reponse eq ".") ;
}

ecrire_repertoire ;
# ### fin programme principal #################################################

# #############################################################################
# sub: is_def
# arg: variable scalaire à tester
# usage: is_def($var)
# si la variable n'est pas définie lui affecte " "
# #############################################################################
sub is_def {
    my $var = shift;
    $var = " " if ! defined $var ;
    return $var;
}

my($id, $prenom, $nom, $mail, @tels) ;
format STDOUT=
@>>>@@<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<@>>>>>>>>>>>>>>>@>>>>>>>>>>>>>>>@>>>>>>>>>>>>>>>@>>>>>>>>>>>>>>>
&is_def($id), " ", &is_def($prenom), &is_def($nom), &is_def($mail), &is_def($tels[0]), &is_def($tels[1]), &is_def($tels[2]), &is_def($tels[3])
.


# #############################################################################
# sub: ouvrir_repertoire
# ouvre le fichier $repertoire s'il existe et rempli @repertoire avec les
# données
# arg:
# usage: ouvrir_repertoire
# invoque: ajouter_entree si le fichier n'existe pas
# #############################################################################
sub ouvrir_repertoire {
    if ( -e $fichier ) {
        my $ref = retrieve "$fichier" ;
        @repertoire = @$ref ;
    } else {
        ajouter_entree ; # si le fichier n'existe pas creer repertoire
    }
    return ;
}

# #############################################################################
# sub: ecrire_repertoire
# parcours @repertoire et écrit le fichier repertoire
# arg:
# usage: ecrire_repertoire
# #############################################################################
sub ecrire_repertoire {
    store \@repertoire, "$fichier" ;
    return ;
}

# #############################################################################
# sub: ajouter_entree
# ajoute des entrées au tableau @repertoire
# arg:
# usage: ajouter_entree
# invoque: ecrire_repertoire
# #############################################################################
sub ajouter_entree {
    my $reponse = "o" ;
    my $tel = "." ;
    my @tels=() ;

    while ( $reponse eq "o" ) {
        print "Prenom : " ;
        chomp (my $prenom = <>) ;
        print "Nom : " ;
        chomp (my $nom = <>) ;
        print "email : " ;
        chomp (my $mail = <>) ;

        while ( $tel ne "" ) {
            print "Téléphone : " ;
            chomp ($tel = <> ) ;
            push (@tels, $tel) unless ($tel eq "") ;
        }

        push @repertoire, {
                           'prenom' => $prenom,
                           'nom'    => $nom,
                           'mail'   => $mail,
                           'tels'   => [@tels]
                          } ;

        print "Ajouter une autre entrée ? (o/n) " ;
        # $reponse = &une_touche;
        chomp ($reponse = <>) ;
    }
    ecrire_repertoire ;
    return ;
}

# #############################################################################
# sub: affiche_repertoire
# parcours et affiche @repertoire dans sa totalité
# arg:
# usage: affiche_repertoire
# #############################################################################
sub affiche_repertoire {
    foreach my $personne ( @repertoire ) {     # parcours tout le répertoire
        $prenom = $personne->{'prenom'} ;
        $nom    = $personne->{'nom'} ;
        $mail   = $personne->{'mail'} ;
        @tels   = @{$personne->{'tels'}} ;

        write
    }
    return ;
}

# #############################################################################
# sub: modifier_entree
# permet de mofifier une entrée (modif nom, prénom, tel - ajout/supp. tél.)
# arg: index de l'entrée du tableau @repertoire
# usage: modifier_entree (index)
# invoque: ecrire_repertoire
# #############################################################################
sub modifier_entree {
    my $index = shift ;

    while (1) {
        my $reponse ;

        printf "%-18s %-18s %-30s",
                $repertoire[$index]{'prenom'},
                $repertoire[$index]{'nom'},
                $repertoire[$index]{'mail'} ;
        my $count = 0 ;
        foreach (@{$repertoire[$index]{tels}}){
            printf "[%u] %-20s", $count, $_ ;
            $count++ ;
        }
        print "\n" ;
        print "Modifier (P)rénom (N)om (M)ail (n°)Téléphone "
            . "(A)jouter tél. (S)upprimer tel. (.)Écrire : " ;
        chomp ($reponse = <>) ;
        $reponse = lc $reponse;

        if ( "$reponse" eq "p" ) {
            print "Nouveau prénom : " ;
            chomp (my $nvPrenom = <>) ;
            $repertoire[$index]{'prenom'} = $nvPrenom ;

        } elsif ( "$reponse" eq "n" ) {
            print "Nouveau nom : " ;
            chomp (my $nvNom = <>) ;
            $repertoire[$index]{'nom'} = $nvNom ;

        } elsif ( "$reponse" eq "m" ){
            print "Nouvel email" ;
            chomp (my $nvMail) ;
            $repertoire[$index]{'mail'} = $nvMail ;

        } elsif ( $reponse =~ /\d/ ){
            print "Nouveau téléphone : " ;
            chomp (my $nvTel = <>) ;
            $repertoire[$index]{'tels'}[$reponse] = $nvTel ;

        } elsif ( "$reponse" eq "a" ){
            print "Nouveau téléphone : " ;
            chomp (my $telPlus = <>) ;
            push @{$repertoire[$index]{'tels'}}, $telPlus ;

        } elsif ( "$reponse" eq "s" ){
            $count = 0 ;
            foreach ( @{$repertoire[$index]{tels}} ){
                printf "[%u] %-20s", $count, $_ ;
                $count++ ;
            }
            print "\n" ;
            print "N° à supprimer : " ;
            chomp (my $choix = <>) ;
            splice @{$repertoire[$index]{tels}}, $choix, 1 ;

        } elsif ( "$reponse" eq "." ) {
            last ;
        }
    }
    ecrire_repertoire ;
    return ;
}


# #############################################################################
# sub: supprimer_entree
# supprime l'entrée index de @repertoire
# arg: index de l'entrée à supprimer
# usage: supprimer_entree (index)
# invoque : ecrire_repertoire
# #############################################################################
sub supprimer_entree {
    my $index = shift ;
    my $reponse ;

    printf "Êtes-vous sur de vouloir supprimer : %s %s\n",
            $repertoire[$index]{prenom}, $repertoire[$index]{nom} ;
    print "o/n : " ;
    chomp ($reponse = <>) ;

    splice (@repertoire, $index, 1) if ("$reponse" eq "o") ;

    ecrire_repertoire ;
    return ;
}

# #############################################################################
# sub: aff_liste_entrees
# affiche les entrées (indices) passées en argument
# arg: liste d'entrées à afficher
# usage: aff_liste_entrees(@liste)
# invoque : supprimer_entree, modifier_entree
# #############################################################################
sub aff_liste_entrees {
    my @liste = @_ ;
    my $reponse ;

    foreach my $i ( @liste ) {
        $id     = $i ;
        $prenom = $repertoire[$i]{'prenom'} ;
        $nom    = $repertoire[$i]{'nom'} ;
        $mail   = $repertoire[$i]{'mail'} ;
        @tels   = @{$repertoire[$i]{'tels'}} ;

        write
    }

    print "Choix : " ;
    chomp (my $index = <>) ;
    return if ( "$index" eq "." ) ;
    return if ( "$index" !~ /\d+/ ) ;

    $id     = $index ;
    $prenom = $repertoire[$index]{'prenom'} ;
    $nom    = $repertoire[$index]{'nom'} ;
    $mail   = $repertoire[$index]{'mail'} ;
    @tels   = @{$repertoire[$index]{'tels'}} ;

    write ;

    print "(M)odifier (S)upprimer (.)retour : " ;
    chomp ($reponse = <>) ;

    return                    if ("$reponse" eq ".") ;
    modifier_entree ($index)  if ("$reponse" eq "m") ;
    supprimer_entree ($index) if ("$reponse" eq "s") ;
    return ;
}


# ############################################################################
# sub    : rechercher
# desc.  : demande quel est le motif à rechercher
#          et renvoie une liste d'entrées correspondantes
# usage  : rechercher
# arg.   :
# retour : liste
# ############################################################################
sub rechercher {
    my $motif ;              # motif à rechercher
    my @trouves ;            # liste des élément trouvés
    my $index = 0 ;          # index de l'élément dans @repertoire

    print "Motif : " ;
    chomp ($motif = <>) ;

    foreach my $ligne ( @repertoire ) {
        while ( my ($clef, $valeur) = each %$ligne ) {
            if ( $valeur =~ /$motif/i ){
                push (@trouves, $index) ;
                next ;
            }
        }
        $index++ ;
    }

    aff_liste_entrees (@trouves) ;
    return ;
}
