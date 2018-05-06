#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Smart::Comments;
use Data::Dumper;
use feature ":5.24";

use Text::LineEditor ;

my $text = line_editor() ;
# print $text ;

format STDOUT=
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
^<<<<<<<<<<<<<<
$text
.

write ;
