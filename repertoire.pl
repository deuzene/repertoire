#!/usr/bin/env perl
use strict ;
use warnings ;
use diagnostics ;
use feature ":5.24" ;

use Storable ;
use POSIX qw(strxfrm);

# #############################################################################
# Ce programme est un répertoire permettant de créer des entrées comprenant :
# - le nom et le prénom d'une personne
# - un ou plusieurs n° de téléphone
# - une ou plusieurs adresse email
# - une adresse multilignes
#
# Il permet de voir toutes les entrées, rechercher une entrée par son nom,
# son prénom, mail, adresse, pour ajouter, supprimer et modifier des
# informations, ajouter et supprimer des entrées.
#
# Les données sont stockées dans le tableau @repertoire (voir ci-dessus)
# qui est sauvegardé dans $fichier ('repertoire' par défaut).
#
# #############################################################################
# structure du tableau @repertoire
# #############################################################################
# @repertoire
#             { prenom  => $prenom ,
#               nom     => $nom ,
#               mail    => [ @mail ] ,
#               tels    => [ @tels ] ,
#               adresse => [ @adresse ]
#             }
my @repertoire  ;
# #############################################################################

my $fichier = shift ;
$fichier = "repertoire" if ( ! defined $fichier ) ;


# ### programme principal #####################################################
ouvrir_repertoire () ;

while (1){
    # message d'invite
    print "(A)jouter une entrée (R)echercher "
        . "(V)oir le répertoire (.)quitter\n" ;
    print "Choix : " ;
    chomp(my $choix = <>) ;

    ajouter_entree ()     if ($choix eq "a") ;
    rechercher ()         if ($choix eq "r") ;
    affiche_repertoire () if ($choix eq "v") ;

    exit                  if ($choix eq ".") ;
}

ecrire_repertoire () ;
# ### fin programme principal #################################################

# #############################################################################
# sub: is_def
# arg: variable scalaire à tester
# usage: is_def($var)
# si la variable n'est pas définie lui affecte " " et la retourne
# #############################################################################
sub is_def {
    my $var = shift;
    $var = " " if not defined $var ;
    return $var;
}

# #############################################################################
# sub: ouvrir_repertoire
# ouvre le fichier $repertoire s'il existe et rempli @repertoire avec les
# données
# arg:
# usage: ouvrir_repertoire
# invoque: ajouter_entree si le fichier n'existe pas
# #############################################################################
sub ouvrir_repertoire {
    # test si $fichier existe et charge @repertoire
    if ( -e $fichier ) {
        my $ref = retrieve "$fichier" ;
        @repertoire = @{$ref} ;
    } else {
        # si le fichier n'existe pas créer @repertoire
        # en ajoutant la première entrée
        ajouter_entree () ;
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
    # tri par ordre alpha. des prénoms
    # strxfrm parce que use locale ne marche pas !
    # https://www.developpez.net/forums/d1854403/autres-langages/perl/langage/trier-ordre-alphabetique-chaines-comportant-caracteres-accentues/
    @repertoire = sort {
                        strxfrm($a->{'prenom'}) cmp strxfrm($b->{'prenom'})
                       } @repertoire ;
    # sauvegarde de @repertoire dans $fichier
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

    while ( $reponse eq "o" ) {
        my ($tel, $mail, $adresse)  = qw/. . ./ ;
        my (@tels, @mail, @adresse) = () ;

        # obtention du nom et du prénom
        print "Prenom : " ;
        chomp(my $prenom = <>) ;
        print "Nom : " ;
        chomp(my $nom = <>) ;

        # obtention des n° de téléphone
        while ( $tel ne "" ) { # tant qu'on entre pas une ligne vide
            print "Téléphone : " ;
            chomp($tel = <>) ;

            push @tels, $tel unless ( $tel eq "" ) ;
        }

        # obtention des mails
        while ( $mail ne "" ) {
            print "email : " ;
            chomp($mail = <>) ;

            push @mail, $mail unless ( $mail eq "" ) ;
        }

        # obtention de l'adresse
        while ( $adresse ne "" ) {
            print "Adresse : " ;
            chomp($adresse = <>) ;

            push @adresse, $adresse unless ( $adresse eq "" ) ;
        }

        # on met tout ça dans @repertoire
        push @repertoire, {
                           'prenom'  => $prenom,
                           'nom'     => $nom,
                           'mail'    => [ @mail ],
                           'tels'    => [ @tels ],
                           'adresse' => [ @adresse ]
                          } ;

        # on recommence ?
        print "Ajouter une autre entrée ? (o/n) " ;
        chomp($reponse = <>) ;
    }

    # Sortie
    ecrire_repertoire () ;
    return ;
}

# ############################################################################
# sub    : format_entree
# desc.  : affiche suivant le format les arg. passés
# usage  : format-entree(id,prenom,nom,mail,adresse,tels)
# arg.   : $id, $prenom, $nom, \@mail, \@adresse, \@tels
# retour :
# ############################################################################
sub format_entree {
    my ($id, $prenom, $nom, $mail, $adresse, $tels) = @_ ;
    my @info = (@$tels, @$mail) ;

# #### définitions des formats ###############################################
# formatage de la sortie sur 1 ligne
format AFF_1=
 @>>> @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
 &is_def($id), &is_def($prenom), &is_def($nom),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[0]),  &is_def($info[0]),

.

# formatage de la sortie sur 2 lignes
format AFF_2=
 @>>> @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
 &is_def($id), &is_def($prenom), &is_def($nom),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[0]),  &is_def($info[0]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[1]),  &is_def($info[1]),

.

# formatage de la sortie sur 3 lignes
format AFF_3=
 @>>> @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
 &is_def($id), &is_def($prenom), &is_def($nom),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[0]),  &is_def($info[0]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[1]),  &is_def($info[1]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[2]),  &is_def($info[2]),

.

# formatage de la sortie sur 4 lignes
format AFF_4=
 @>>> @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
 &is_def($id), &is_def($prenom), &is_def($nom),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[0]),  &is_def($info[0]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[1]),  &is_def($info[1]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[2]),  &is_def($info[2]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[3]),  &is_def($info[3]),

.

# formatage de la sortie sur 5 lignes
format AFF_5=
 @>>> @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
 &is_def($id), &is_def($prenom), &is_def($nom),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[0]),  &is_def($info[0]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[1]),  &is_def($info[1]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[2]),  &is_def($info[2]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[3]),  &is_def($info[3]),
      @<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      &is_def($adresse->[4]),  &is_def($info[4]),

.
# ### fin définition des formats ##############################################

# nombre de lignes à afficher
my $lignes ;

# on prends le plus grand des deux
if ( scalar(@info) >= scalar(@$adresse) ) {
    $lignes = scalar(@info) ;

} else {
    my $lignes = scalar(@$adresse) ;
}

# choix du format d'affichage
# $~ sélectionne le format
$~ = "AFF_1" if ( $lignes == 1 ) ;
$~ = "AFF_2" if ( $lignes == 2 ) ;
$~ = "AFF_3" if ( $lignes == 3 ) ;
$~ = "AFF_4" if ( $lignes == 4 ) ;
$~ = "AFF_5" if ( $lignes == 5 ) ;

# écriture suivant le format choisi
write ;

return ;
}

# #############################################################################
# sub: affiche_repertoire
# parcours et affiche @repertoire dans sa totalité
# arg:
# usage: affiche_repertoire
# #############################################################################
sub affiche_repertoire {
    my $id = 0 ;

    foreach my $personne ( @repertoire ) {     # parcours tout le répertoire
        my $prenom  = $personne->{'prenom'} ;
        my $nom     = $personne->{'nom'} ;
        my @tels    = @{$personne->{'tels'}} ;
        my @mail    = @{$personne->{'mail'}} ;
        my @adresse = @{$personne->{'adresse'}} ;

        # affichage formaté
        format_entree( $id, $prenom, $nom, \@mail, \@adresse, \@tels ) ;

        # on comptabilise l'id
        $id++ ;
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
    my $index = shift ; # l'index de l'entrée à modifier

    while (1) {
        my $reponse ;

        # affichage de l'entrée correspondant à l'index
        my $prenom  = $repertoire[$index]{'prenom'},
        my $nom     = $repertoire[$index]{'nom'},
        my @mail    = @{$repertoire[$index]{'mail'}} ;
        my @tels    = @{$repertoire[$index]{'tels'}} ;
        my @adresse = @{$repertoire[$index]{'adresse'}} ;

        format_entree( $index, $prenom,$nom, \@mail, \@adresse, \@tels ) ;

        # message d'invite
        print "Modifier (P)rénom (N)om (M)ail "
            . "(T)éléphone (A)dresse (.)Écrire : " ;
        chomp($reponse = <>) ;
        $reponse = lc $reponse;

        # différente actions suivant le choix fait
        if ( "$reponse" eq "p" ) {         # modif. prénom
            print "Nouveau prénom : " ;
            chomp(my $nvPrenom = <>) ;
            $repertoire[$index]{'prenom'} = $nvPrenom ;

        } elsif ( "$reponse" eq "n" ) {    # modif. nom
            print "Nouveau nom : " ;
            chomp(my $nvNom = <>) ;
            $repertoire[$index]{'nom'} = $nvNom ;

        } elsif ( "$reponse" eq "m" ){     # modif. mail
            my $count = 0 ;

            # affichage des différents mails
            foreach ( @{$repertoire[$index]{'mail'}} ) {
                printf "[%u] %-25s" , $count , $_ ;
                $count++ ;
            }

            # message d'invite
            print "(n°)modif (A)jouter \n" ;
            print "Choix : " ;
            chomp(my $choix = <>) ;
            $choix = lc $choix ;

            if ( "$choix" eq "a" ) {       # ajouter un email
                # message d'invite
                print "Nouvel email : " ;
                chomp(my $nvMail = <>) ;

                # ajout de l'entrée à @repertoire
                push @{$repertoire[$index]{'mail'}} , $nvMail ;

            } elsif ( $choix =~ /\d+/x ) {      # modifier l'email n°
                # message d'invite
                print "Nouvel email : " ;
                chomp(my $nvMail = <>) ;

                # modification de l'entrée $index
                $repertoire[$index]{'mail'}[$choix] = $nvMail ;
            }

        } elsif ( "$reponse" eq "t" ){                    # modif. téléphone
            my $count = 0 ;

            foreach ( @{$repertoire[$index]{'tels'}} ) {
                printf "[%u] %-25s" , $count , $_ ;
                $count++ ;
            }

            print "(n°)modif (A)jouter \n" ;
            print "Choix : " ;
            chomp(my $choix = <>) ;
            $choix = lc $choix ;

            if ( "$choix" eq "a" ) {
                print "Nouveau téléphone : " ;
                chomp(my $nvTel = <>) ;
                push @{$repertoire[$index]{'tels'}} , $nvTel ;

            } elsif ( $choix =~ /\d+/x ) {
                print "Nouveau téléphone : " ;
                chomp(my $nvTel = <>) ;
                $repertoire[$index]{'tels'}[$choix] = $nvTel ;
            }

        } elsif ( "$reponse" eq "a" ){                    # modif. adresse
            my $count = 0 ;

            foreach ( @{$repertoire[$index]{'adresse'}} ) {
                printf "[%u] %-25s" , $count , $_ ;
                $count++ ;
            }

            print "(n°)modif (A)jouter \n" ;
            print "Choix : " ;
            chomp(my $choix = <>) ;
            $choix = lc $choix ;

            if ( "$choix" eq "a" ) {
                print "Nouvelle adresse : " ;
                chomp(my $nvAdresse = <>) ;
                push @{$repertoire[$index]{'adresse'}} , $nvAdresse ;

            } elsif ( $choix =~ /\d+/x ) {
                print "Nouvelle adresse : " ;
                chomp(my $nvAdresse = <>) ;
                $repertoire[$index]{'adresse'}[$choix] = $nvAdresse ;

            }

        } elsif ( "reponse" eq "s" ) {                # suppression de l'entrée
            # message d'invite
            print "Suppimer o/n ? " ;
            chomp(my $choix = <>) ;
            $choix = lc $choix ;

            # suppression de l'entrée $index
            splice @{$repertoire[$index]} , $index , 1 if ( "$choix" eq "o" ) ;

        } elsif ( "$reponse" eq "." ) {               # sortie
            last ;
        }
    }

    # sortie
    ecrire_repertoire () ;
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

    # message d'invite
    printf "Êtes-vous sûr de vouloir supprimer : %s %s\n",
            $repertoire[$index]{'prenom'}, $repertoire[$index]{'nom'} ;
    print "o/n : " ;
    chomp($reponse = <>) ;

    # suppression de l'entrée
    splice (@repertoire, $index, 1) if ("$reponse" eq "o") ;

    ecrire_repertoire () ;
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

    # affichage de la liste des entrées
    foreach my $i ( @liste ) {
        my $id      = $i ;
        my $prenom  = $repertoire[$i]{'prenom'} ;
        my $nom     = $repertoire[$i]{'nom'} ;
        my @tels    = @{$repertoire[$i]{'tels'}} ;
        my @mail    = @{$repertoire[$i]{'mail'}} ;
        my @adresse = @{$repertoire[$i]{'adresse'}} ;

        format_entree( $id, $prenom, $nom, \@mail, \@adresse, \@tels ) ;
    }

    # message d'invite
    print "Choix : " ;
    chomp(my $index = <>) ;
    return if ( "$index" eq "." ) ;
    return if ( "$index" !~ /\d+/x ) ;

    # affichage de l'entrée choisie
    my $id      = $index ;
    my $prenom  = $repertoire[$index]{'prenom'} ;
    my $nom     = $repertoire[$index]{'nom'} ;
    my @tels    = @{$repertoire[$index]{'tels'}} ;
    my @mail    = @{$repertoire[$index]{'mail'}} ;
    my @adresse = @{$repertoire[$index]{'adresse'}} ;

    format_entree( $id, $prenom, $nom, \@mail, \@adresse, \@tels ) ;

    # message d'invite
    print "(M)odifier (S)upprimer (.)retour : " ;
    chomp($reponse = <>) ;

    # modifier, supprimer ou sortir
    return                    if ("$reponse" eq ".") ;
    modifier_entree ($index)  if ("$reponse" eq "m") ;
    supprimer_entree ($index) if ("$reponse" eq "s") ;
    return ;
}

# ############################################################################
# sub    : uniq
# desc.  : supprimer les doublons de la liste passée en argument
# usage  : uniq(@liste)
# arg.   : @liste
# retour : @liste sans les doublons
# ############################################################################
sub uniq {
    my %hash ;

    grep { !$hash{$_}++ } @_ ;

    # return ; # ne pas mettre de return, ne marche pas sinon
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
    my @trouves ;            # liste des élément trouvés

    print "Motif : " ;
    chomp(my $motif = <>) ;

    # recherche du motif dans @repertoire
    for ( my $index = 0 ; $index < scalar(@repertoire) ; $index++ ) {
        # recherche dans le prénom
        if ( $repertoire[$index]{'prenom'} =~ /$motif/ix ) {
            push @trouves , $index ;
            next ;
        }

        # recherche dans le nom
        if ( $repertoire[$index]{'nom'} =~ /$motif/ix ) {
            push @trouves , $index ;
            next ;
        }

        # recherche dans le(s) mail(s)
        foreach ( @{$repertoire[$index]{'mail'}} ) {
            if ( $_ =~ /$motif/ix ) {
                push @trouves , $index ;
                next ;
            }
        }

        # recherche dans les tél.
        foreach ( @{$repertoire[$index]{'tels'}} ) {
            if ( $_ =~ /$motif/ix ) {
                push @trouves , $index ;
                next ;
            }
        }

        # recherche dans l'adresse
        foreach ( @{$repertoire[$index]{'adresse'}} ) {
            if ( $_ =~ /$motif/ix ) {
                push @trouves , $index ;
                next ;
            }
        }
    }

    # suppression des doublons
    my @dedupe = uniq (@trouves) ;

    # affichage de la liste des entrées trouvées
    aff_liste_entrees (@dedupe) ;

    return ;
}

