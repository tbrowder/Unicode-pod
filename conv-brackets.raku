#!/usr/bin/env raku

if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.IO.basename} go

    Converts the first eight chars in the HLL::Grammar '\$brackets'
    to hex codepoints.
    HERE
    exit;
}

        #   '<', '>', '[', ']', '(', ')', '{', '}', 
