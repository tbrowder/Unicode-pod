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
    my $s = sprintf '%#.4X', $c.ord;
    say "'$c' = '$s'";
}
