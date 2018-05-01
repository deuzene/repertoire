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

sub format_entree {
    my ($id, $prenom, $nom, $mail, $adresse, $tels) = @_ ;

format STDOUT=
@>>>@@<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
&is_def($id), " ", &is_def($prenom), &is_def($nom), &is_def($mail)
     @<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($tels->[0]),    &is_def($adresse->[0])
     @<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($tels->[1]),    &is_def($adresse->[1])
     @<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($tels->[2]),    &is_def($adresse->[2])
     @<<<<<<<<<<<<<<<<<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     &is_def($tels->[3]),    &is_def($adresse->[3])
.

write STDOUT ;
}

my $prenom = "Martin" ;
my $nom     = "Caussanel" ;
my @tels    = qw/1212121212 3434343434/ ;
my $mail    = 'martin@caussanel.fr' ;
my @adresse = ("3, rue Lapointe", "31000 Toulouse") ;

format_entree( undef, $prenom, $nom, $mail, \@adresse, \@tels ) ;
