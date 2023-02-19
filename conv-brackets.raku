#!/usr/bin/env raku

if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.IO.basename} go

    Converts the first eight chars in the HLL::Grammar '\$brackets'
    to hex codepoints.
    HERE
    exit;
}

my @c = [
    '<', '>', '[', ']', '(', ')', '{', '}', 
];

for @c -> $c {
    my $i = $c.ord;
    # convert an Int to hex format
    my $s = sprintf '%#.4X', $i;
    $s ~~ s/X/x/;
    say "'$c' = '$s'";
}
