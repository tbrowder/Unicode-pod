#!/usr/bin/env raku

# global array defined in the BEGIN block at the end:
my @bracket-chars;

if !@*ARGS {
    say qq:to/HERE/;
    Usage: {$*PROGRAM.IO.basename} go

    Writes the HLL::Grammar '\$brackets' chars into a Pod6 table.
    HERE
    exit;
}

my @ofils;

my %bracket-sets = [
    # left => right
    '|' => '|',
    # don't create the other table for now
    #0xff62.chr => 0xff63.chr,
];

=begin comment
say "bracket sets: L, R";
for %bracket-sets.kv -> $lb, $rb {
    say "Left: '$lb'; Right: '$rb'";
}
=end comment

my $i = 0;
for %bracket-sets.kv -> $lb is copy, $rb is copy {
    ++$i;
    my $f = "brackets-{$i}.pod6";
    if $lb ~~ /'|'/ {
        # need to escape it for doc site
        $lb = '\\|';
        $rb = $lb
    }
    write-opener-pod6-file :$f, :$lb, :$rb;
    @ofils.append: $f;
}

say "Normal end.";
my $s = @ofils.elems > 1 ?? 's' !! '';
say "See output file$s:";
say "  $_" for @ofils;

=begin comment
my $lb = 0xff62.chr;
my $rb = 0xff63.chr;
my $lb = '|';
my $rb = '|';
=end comment

sub write-opener-pod6-file(:$f, :$lb, :$rb) {

    my $fh = open $f, :w;

    $fh.print: qq:to/HERE/;

    =begin table :caption<Bracket pairs>
     Char | Char | Hex  | Hex  | Char | Char | Hex  | Hex
    ======+======+======+======+======+======+======+======
    HERE

    my $n   = @bracket-chars.elems;
    my $inc = 8;
    # wee need to march through the list $inc elements at a time
    # a hack for now

    loop (my $i = 0;  $i < $n; $i += $inc)  {
        my $i0 = $i;
        my $i1 = $i+1;
        my $i2 = $i+2;
        my $i3 = $i+3;
        my $i4 = $i+4;
        my $i5 = $i+5;
        my $i6 = $i+6;
        my $i7 = $i+7;

        my ($a, $b, $c, $d, $e, $f, $g, $h);

        $a = $i0 < $n ?? @bracket-chars[$i0] !! '';
        $b = $i1 < $n ?? @bracket-chars[$i1] !! '';
        $c = $i2 < $n ?? @bracket-chars[$i2] !! '';
        $d = $i3 < $n ?? @bracket-chars[$i3] !! '';
        $e = $i4 < $n ?? @bracket-chars[$i4] !! '';
        $f = $i5 < $n ?? @bracket-chars[$i5] !! '';
        $g = $i6 < $n ?? @bracket-chars[$i6] !! '';
        $h = $i7 < $n ?? @bracket-chars[$i7] !! '';

        #=begin comment
        if 1 {
          #.Int    : '{$a.Int}'
          #.chr    : '{$a.chr}'
          #.ord    : '{$a.ord}'
          #.WHAT   : '{$a.WHAT}'
        note qq:to/HERE/;
        == Item $i: '$a'
          .^name  : '{$a.^name}'
          .uniname: '{$a.uniname}'
          .uniprop: '{$a.uniprop}'
        HERE
        note("  .Str: '$a'") if $a ~~ Str;
        note("  .Str: '{$a.chr}'") if $a ~~ Int;

        next;
        }
        #=end comment


        my $aa = $a ?? $a.chr !! '';
        my $bb = $b ?? $b.chr !! '';
        my $cc = $c ?? $c.chr !! '';
        my $dd = $d ?? $d.chr !! '';

        $aa = sprintf("%s%s%s", $lb, $aa, $rb) if $aa;
        $bb = sprintf("%s%s%s", $lb, $bb, $rb) if $bb;
        $cc = sprintf("%s%s%s", $lb, $cc, $rb) if $cc;
        $dd = sprintf("%s%s%s", $lb, $dd, $rb) if $dd;

        =begin comment
        say "|$a|";
        say "|$aa|";
        last;
        =end comment

        $fh.say: "$aa | $a | $bb | $b | $cc | $c | $dd | $d";
        $fh.say: "--------+---------+---------+---------+---------+---------+---------+--------";

        last if !$d;
    }

    $fh.say: "=end table";
    $fh.say: "\n=end pod";
    $fh.say: "\n# vim: expandtab softtabstop=4 shiftwidth=4 ft=perl6";
    $fh.close;
}

BEGIN {
    # contents of the following array are the hex values of the HLL::Grammar
    # '$brackets' chars
    #@bracket-chars = <
    @bracket-chars = [
         #'<'.ord, '>', '[', ']', '(', ')', '{', '}' 
         '<', '>', '[', ']', '(', ')', '{', '}', 
         0x0028, 0x0029, 0x003C, 0x003E, 0x005B, 0x005D, 
         0x007B, 0x007D, 0x00AB, 0x00BB, 0x0F3A, 0x0F3B, 0x0F3C, 0x0F3D, 0x169B, 0x169C,
    ];
    #>;

    # 0x0028 0x003C 0x005B 0x007B 0x00AB 0x0F3A 0x0F3C 0x169B 0x2018 0x201A 0x201B
}
