#!/usr/bin/env perl

use File::Basename 'dirname';
use File::Spec::Functions qw(catdir splitdir);

# Source directory has precedence
my @base = (splitdir(dirname(__FILE__)), '..');
my $lib = join('/', @base, 'lib');
-e catdir(@base, 't') ? unshift(@INC, $lib) : push(@INC, $lib);

# Start commands for application
require Jobnavi::Utility;

for (my $i=0;$i<1000;$i++){
    Jognavi::Utility::makeCheckerIcon($i+1);
}
