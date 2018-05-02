#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

sub is_def {
    my $var = shift;
    $var = " " if ! defined $var ;
    return $var;
}

# ############################################################################
# sub    : format_entree
# desc.  : affiche suivant le format les arg. passés
# usage  : format-entree(id,prenom,nom,mail,adresse,tels)
# arg.   :
# retour :
# ############################################################################
sub format_entree {
    my ($id, $prenom, $nom, $mail, $adresse, $tels) = @_ ;
    my @info = (@$tels, @$mail) ;

format STDOUT=
@>>>@@<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<
&is_def($id), " ", &is_def($prenom), &is_def($nom)
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[0]),               &is_def($adresse->[0])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[1]),               &is_def($adresse->[1])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[2]),               &is_def($adresse->[2])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[3]),               &is_def($adresse->[3])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[4])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[5])
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($info[6])
.

write STDOUT ;
}

my $prenom = "Martin" ;
my $nom     = "Caussanel" ;
my @tels    = qw/1212121212 3434343434/ ;
my @mail    = qw/martin@caussanel.fr contact@taf.org/ ;
my @adresse = ("3, rue Lapointe", "31000 Toulouse") ;

format_entree( 1, $prenom, $nom, \@mail, \@adresse, \@tels ) ;

        } elsif ( "$reponse" eq "a" ){                    # modif. téléphone
            my $count = 0 ;

            foreach ( @{repertoire}[$index]{'adresse'} ) {
                printf "[%u] %-25s" , $count , $_ ;
                $count++ ;
            }

            print "(n°)modif (A)jouter \n" ;
            print "Choix : " ;
            chomp (my $reponse = <>) ;
            $reponse = lc $reponse ;

            if ( "$reponse" eq "a" ) {
                print "Nouvelle adresse : " ;
                chomp ( my $nvAdresse = <> ) ;
                push @{$repertoire}[$index]{'adresse'} , $nvAdresse ;

            } elsif ( $reponse =~ /\d+/ ) {
                print "Nouvelle adresse : " ;
                chomp ( my $nvAdresse = <> ) ;
                $repertoire[$index]{'adresse'}[$reponse] = $nvAdresse ;
            }
