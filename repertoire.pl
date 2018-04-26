#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

my @repertoire ;                # le repertoire (array de hash)
my $repertoire = "repertoire";  # fichier

sub affiche_repertoire;     sub affiche_entrees;    sub ajouter_entree;
sub ecrire_repertoire;      sub modifier_entree;    sub ouvrir_repertoire;
sub rechercher;             sub supprimer_entree;

#TODO: supprimer : valider l'entrée
#TODO: ajouter mail, adresse
#TODO: plusieurs n° de tél
# ### programme principal #####################################################
ouvrir_repertoire();

while (1){
    print "(A)jouter une entrée (R)echercher (V)oir le répertoire (..)quitter\n";
    print "Choix : ";
    my $reponse;
    chomp ($reponse = <>);
    ajouter_entree()        if ($reponse eq "a");
    rechercher()            if ($reponse eq "r");
    affiche_repertoire()    if ($reponse eq "v");
    exit                    if ($reponse eq "..");
}

ecrire_repertoire();
# ### fin programme principal #################################################

sub ouvrir_repertoire {
    if (-e $repertoire) {
        open my $REP, "<", "$repertoire" or die "Impossible de lire $repertoire : $!";

        while (<$REP>) {
            chomp;
            my ($prenom, $nom, @tels) = split(/#/);
            push (@repertoire,{ 'prenom' => $prenom,
                                'nom'    => $nom,
                                'tels'   => [@tels]
                              });
        }
        close $REP;
    } else {
        ajouter_entree(); # si le fichier n'existe pas creer repertoire
    }
    return;
}

sub ecrire_repertoire {
  open my $REP, ">", "$repertoire"
    or die "Impossible d'ouvrir $repertoire en écriture : $!";

  foreach my $personne (@repertoire) {
    print $REP $personne->{'prenom'} . "#"    # on sépare les champs
             . $personne->{'nom'}    . "#";   # avec des dièses
    foreach my $tel (@{$personne->{'tels'}}) {
      print $REP $tel . "#";
    }
    print $REP "\n";
  }
  close $REP;
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
    ecrire_repertoire;
    return;
}

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

sub modifier_entree {
    my $index = shift;

    while (1) {
        my $reponse;

        printf "%-20s %-20s",
                $repertoire[$index]{prenom}, $repertoire[$index]{nom};
        my $count = 0;
        foreach (@{$repertoire[$index]{tels}}){
            printf "[%u] %-20s", $count, $_;
            $count++;
        }
        print "\n";
        print "Modifier (P)rénom (N)om (n°)Téléphone (.)Écrire : ";
        chomp ($reponse = <>);

        if ("$reponse" eq "p") {
            print "Nouveau prénom : ";
            chomp (my $nvPrenom = <>);
            $repertoire[$index]{prenom} = $nvPrenom;
        } elsif ("$reponse" eq "n") {
            print "Nouveau nom : ";
            chomp (my $nvNom = <>);
            $repertoire[$index]{nom} = $nvNom;
        } elsif ($reponse =~ /\d/){
            print "Nouveau téléphone : ";
            chomp (my $nvTel = <>);
            $repertoire[$index]{tels}[$reponse] = $nvTel;
        } elsif ("$reponse" eq ".") {
            last;
        }
    }
    ecrire_repertoire;
    return;
}


sub supprimer_entree {
    my $index = shift;
    my $reponse;

    printf "Êtes-vous sur de vouloir supprimer : %s %s\n",
            $repertoire[$index]{prenom}, $repertoire[$index]{nom};
    print "o/n : ";
    chomp ($reponse = <>);

    splice (@repertoire, $index, 1) if ("$reponse" eq "o");

    ecrire_repertoire;
    return;
}

sub affiche_entrees {
    my @liste = @_;
    my $reponse;

    foreach my $i (@liste) {
        my $aff = sprintf "[%5s]: %-20s %-20s",
                  $i,  $repertoire[$i]{'prenom'}, $repertoire[$i]{'nom'};

        foreach my $j (@{$repertoire[$i]{'tels'}}){
            $aff .= sprintf "%-15s", $j;
        }
        say $aff;
    }

    print "Choix : ";
    chomp (my $index = <>);

    my $aff = sprintf "[%5s]: %-20s %-20s",
              $index,  $repertoire[$index]{'prenom'}, $repertoire[$index]{'nom'};

    foreach my $j (@{$repertoire[$index]{'tels'}}){
        $aff .= sprintf "%-15s", $j;
    }

    say $aff;
    print "(M)odifier (S)upprimer (.)retour : ";
    chomp ($reponse = <>);

    return                    if ("$reponse" eq ".");
    modifier_entree ($index)  if ("$reponse" eq "m");
    supprimer_entree ($index) if ("$reponse" eq "s");
    return;
}


sub rechercher {
    my $motif;              # motif à rechercher
    my @trouves;            # liste des élément trouvés
    my $index = 0;          # index de l'élément dans @repertoire

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
    return;
}
