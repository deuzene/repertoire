#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

use Text::LineEditor ;

# my $text = line_editor() ;
# print $text ;
my @liste = qw/un deux trois quatre cinq six/ ;
my $text =  join "\n" , @liste ;

format REPORT1=
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
.

format REPORT2=
@<<<<<<<<<<<<<<
$text
@<<<<<<<<<<<<<<
$text
@<<<<<<<<<<<<<<
$text
@<<<<<<<<<<<<<<
$text
.

$~ = "REPORT2" ;
write ;

$~ = "REPORT1" ;
write

# print $text . "\n" ;
