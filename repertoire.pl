#!/usr/bin/env perl
# TODO: verifier fonction supprimer
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

my ($nom, $prenom, $tel);       # variables temporaires
my $reponse;                    #     "         "
my @repertoire ;                # le repertoire (array de hash)
my $repertoire = "repertoire";  # fichier

sub affiche_repertoire;     sub affiche_entrees;    sub ajouter_entree;
sub ecrire_repertoire;      sub modifier_entree;    sub ouvrir_repertoire;
sub rechercher;             sub supprimer_entree;

# ### programme principal #####################################################
ouvrir_repertoire();

while (1){
    print "(A)jouter une entrée (R)echercher (V)oir le répertoire (..)quitter\n";
    print "Choix : ";
    chomp ($reponse = <>);
    ajouter_entree()        if ($reponse eq "a");
    rechercher()            if ($reponse eq "r");
    affiche_repertoire()    if ($reponse eq "v");
    exit                    if ($reponse eq "..");
}

ecrire_repertoire();
# ### fin programme principal #################################################

sub ajouter_entree () {
    $reponse = "o";

    while ( $reponse eq "o" ) {
        print "Prenom : ";
        chomp ( $prenom = <> );
        print "Nom : ";
        chomp ( $nom = <> );
        print "Téléphone : ";
        chomp ( $tel = <> );
        push ( @repertoire,{'prenom' => $nom,
                            'nom'    => $prenom,
                            'tel'    => $tel} );

        print "Ajouter une autre entrée ? (o/n) ";
        chomp ($reponse = <>);
    }
    ecrire_repertoire;
}

sub ouvrir_repertoire () {
    if (-e $repertoire) {
        open REP,"$repertoire" or die "Impossible de lire $repertoire : $!";
        while (<REP>) {
            ($nom, $prenom, $tel) = split(/#/);
            push (@repertoire,{ 'prenom' => $prenom,
                                'nom'    => $nom,
                                'tel'    => $tel
                              });
        }
    } else {
        ajouter_entree(); # si le fichier n'existe pas creer repertoire
    }


    close REP;
}

sub affiche_repertoire () {
    foreach (@repertoire) {     # parcours tout le répertoire
        printf ("%-20s %-20s %-15s\n", $_->{prenom}, $_->{nom}, $_->{tel});
    }
}

sub ecrire_repertoire () {
    open REP, "> $repertoire" or die "Impossible d'ouvrir $repertoire en écriture : $!";

    foreach (@repertoire){
        print REP $_->{'prenom'} . "#"          # on sépare les champs
                . $_->{'nom'}    . "#"          # avec des dièses
                . $_->{'tel'}    . "#\n";       #
    }
    close REP;
}

sub modifier_entree {
    while (1) {
        my $index = @_;
        printf ("%-20s %-20s %-15s\n", $repertoire[$index]{prenom}, $repertoire[$index]{nom}, $repertoire[$index]{tel});
        print "Modifier (P)rénom (N)om (T)éléphone : ";
        chomp ($reponse = <>);
        if ("$reponse" eq "p") {
            print "Nouveau prénom : ";
            chomp (my $nvPrenom = <>);
            $repertoire[$index]{prenom} = $nvPrenom;
        } elsif ("$reponse" eq "n") {
            print "Nouveau nom : ";
            chomp (my $nvNom = <>);
            $repertoire[$index]{nom} = $nvNom;
        } elsif ("$reponse" eq "t") {
            print "Nouveau téléphone : ";
            chomp (my $nvTel = <>);
            $repertoire[$index]{tel} = $nvTel;
        } elsif ("$reponse" eq ".") {
            return
        }
    }
    ecrire_repertoire;
}

sub supprimer_entree  {
    my $index = shift;
    printf ("Êtes-vous sur de vouloir supprimer : %s %s\n", $repertoire[$index]{prenom}, $repertoire[$index]{nom});
    print "o/n : ";
    chomp ($reponse = <>);
    splice (@repertoire, $index, 1) if ("$reponse" eq "o");
    ecrire_repertoire;
}

sub affiche_entrees (@) {
    my @liste = @_;
    foreach (@liste) {
        printf ("[%5s]: %-20s %-20s %-15s\n", $_,  $repertoire[$_]{prenom}, $repertoire[$_]{nom}, $repertoire[$_]{tel});
    }
    print "Choix : ";
    chomp (my $index = <>);
    printf ("%-20s %-20s %-15s\n", $repertoire[$index]{prenom}, $repertoire[$index]{nom}, $repertoire[$index]{tel});
    print "(M)odifier (S)upprimer (.)retour : ";
    chomp ($reponse = <>);
    return                    if ("$reponse" eq ".");
    modifier_entree ($index)  if ("$reponse" eq "m");
    supprimer_entree ($index) if ("$reponse" eq "s");
}

sub rechercher () {
    my $motif;              # motif à rechercher
    my @trouves;            # liste des élément trouvés
    my $index = 0;
    print "Motif : ";
    chomp ($motif = <>);
    foreach my $ligne (@repertoire) {
        while ( my ($clef, $valeur) = each %$ligne ) {
            if ( $valeur =~ /$motif/ ){
                push (@trouves, $index);
                next;
            }
        }
        $index++;
    }
    affiche_entrees (@trouves);
}
