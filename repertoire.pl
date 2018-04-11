#!/usr/bin/env perl
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

#TODO: a la sortie de modifier_entree on ne doit pas quitter le prog
# ### programme principal #####################################################
ouvrir_repertoire();

while (1){
    print "(A)jouter une entrée (R)echercher (V)oir le répertoire (.)quitter\n";
    print "Choix : ";
    chomp ($reponse = <>);
    ajouter_entree()        if ($reponse eq "a");
    rechercher()            if ($reponse eq "r");
    affiche_repertoire()    if ($reponse eq "v");
    last                    if ($reponse eq "..");
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
}

sub ouvrir_repertoire () {
    if (-e $repertoire) {
        open REP,"$repertoire" or die "Impossible de lire $repertoire : $!";
        while (<REP>) {
            ($nom, $prenom, $tel) = split(/#/);
            push (@repertoire,{ 'prenom' => $nom,
                                'nom'    => $prenom,
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
        print $_->{prenom} . "\t" . $_->{nom} . "\t" . $_->{tel} . "\n";
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
        my @r_hash = @_;
        print "mod: $r_hash[0]{prenom} $r_hash[0]{nom} $r_hash[0]{tel}\n";
        print "(P)rénom (N)om (T)éléphone : ";
        chomp ($reponse = <>);
        if ("$reponse" eq "p") {
            print "Nouveau prénom : ";
            chomp (my $nvPrenom = <>);
            $r_hash[0]{prenom} = $nvPrenom;
        } elsif ("$reponse" eq "n") {
            print "Nouveau nom : ";
            chomp (my $nvNom = <>);
            $r_hash[0]{nom} = $nvNom;
        } elsif ("$reponse" eq "t") {
            print "Nouveau téléphone : ";
            chomp (my $nvTel = <>);
            $r_hash[0]{tel} = $nvTel;
        } elsif ("$reponse" eq ".") {
            return
        }
    }
}

sub supprimer_entree ($) {
    say "supprimer";
}

sub affiche_entrees (@) {
    my @liste = @_;
    foreach (@liste) {
        print "[$_]: $repertoire[$_]{prenom} $repertoire[$_]{nom} $repertoire[$_]{tel}\n";
    }
    print "Choix : ";
    chomp (my $index = <>);
    print "$repertoire[$index]{prenom} $repertoire[$index]{nom} $repertoire[$index]{tel}\n";
    print "(M)odifier (S)upprimer (.)retour\n";
    chomp ($reponse = <>);
    return                                 if ("$reponse" eq ".");
    modifier_entree ($repertoire[$index])  if ("$reponse" eq "m");
    supprimer_entree (\$repertoire[$index]) if ("$reponse" eq "s");
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
