#!/usr/bin/env raku

# global array defined in the BEGIN block at the end:
my @opener-chars;

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM go

    Writes the 'token opener' chars into a Pod6 table.
    HERE
    exit;
}

my @ofils;

my %bracket-sets = %(
    # left => right
    '|' => '|',
    0xff62.chr => 0xff63.chr,
);

=begin comment
say "bracket sets: L, R";
for %bracket-sets.kv -> $lb, $rb {
    say "Left: '$lb'; Right: '$rb'";
}
=end comment

my $i = 0;
for %bracket-sets.kv -> $lb is copy, $rb is copy {
    ++$i;
    my $f = "openers-{$i}.pod6";
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

    =begin table :caption<Opener Graphemes>
    Char | Hex | Char | Hex | Char | Hex | Char | Hex
    =====+=====+======+=====+======+=====+======+====
    HERE

    my $n   = @opener-chars.elems;
    my $inc = 4;
    # we need to march through the list $inc elements at a time
    # a hack for now

    loop (my $i = 0;  $i < $n; $i += 4)  {
        my $i0 = $i;
        my $i1 = $i+1;
        my $i2 = $i+2;
        my $i3 = $i+3;

        my ($a, $b, $c, $d);

        $a = $i0 < $n ?? @opener-chars[$i0] !! '';
        $b = $i1 < $n ?? @opener-chars[$i1] !! '';
        $c = $i2 < $n ?? @opener-chars[$i2] !! '';
        $d = $i3 < $n ?? @opener-chars[$i3] !! '';

        =begin comment
        say $a.^name;
        say $a.Int;
        say $a.chr;
        say "|$a|";
        =end comment

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
    # contents of the following array are the hex values of the "token opener"
    # chars
    @opener-chars = <
         0x0028 0x003C 0x005B 0x007B 0x00AB 0x0F3A 0x0F3C 0x169B 0x2018 0x201A 0x201B
         0x201C 0x201E 0x201F 0x2039 0x2045 0x207D 0x208D 0x2208 0x2209 0x220A 0x2215
         0x223C 0x2243 0x2252 0x2254 0x2264 0x2266 0x2268 0x226A 0x226E 0x2270 0x2272
         0x2274 0x2276 0x2278 0x227A 0x227C 0x227E 0x2280 0x2282 0x2284 0x2286 0x2288
         0x228A 0x228F 0x2291 0x2298 0x22A2 0x22A6 0x22A8 0x22A9 0x22AB 0x22B0 0x22B2
         0x22B4 0x22B6 0x22C9 0x22CB 0x22D0 0x22D6 0x22D8 0x22DA 0x22DC 0x22DE 0x22E0
         0x22E2 0x22E4 0x22E6 0x22E8 0x22EA 0x22EC 0x22F0 0x22F2 0x22F3 0x22F4 0x22F6
         0x22F7 0x2308 0x230A 0x2329 0x23B4 0x2768 0x276A 0x276C 0x276E 0x2770 0x2772
         0x2774 0x27C3 0x27C5 0x27D5 0x27DD 0x27E2 0x27E4 0x27E6 0x27E8 0x27EA 0x2983
         0x2985 0x2987 0x2989 0x298B 0x298D 0x298F 0x2991 0x2993 0x2995 0x2997 0x29C0
         0x29C4 0x29CF 0x29D1 0x29D4 0x29D8 0x29DA 0x29F8 0x29FC 0x2A2B 0x2A2D 0x2A34
         0x2A3C 0x2A64 0x2A79 0x2A7D 0x2A7F 0x2A81 0x2A83 0x2A8B 0x2A91 0x2A93 0x2A95
         0x2A97 0x2A99 0x2A9B 0x2AA1 0x2AA6 0x2AA8 0x2AAA 0x2AAC 0x2AAF 0x2AB3 0x2ABB
         0x2ABD 0x2ABF 0x2AC1 0x2AC3 0x2AC5 0x2ACD 0x2ACF 0x2AD1 0x2AD3 0x2AD5 0x2AEC
         0x2AF7 0x2AF9 0x2E02 0x2E04 0x2E09 0x2E0C 0x2E1C 0x2E20 0x2E28 0x3008 0x300A
         0x300C 0x300E 0x3010 0x3014 0x3016 0x3018 0x301A 0x301D 0xFD3E 0xFE17 0xFE35
         0xFE37 0xFE39 0xFE3B 0xFE3D 0xFE3F 0xFE41 0xFE43 0xFE47 0xFE59 0xFE5B 0xFE5D
         0xFF08 0xFF1C 0xFF3B 0xFF5B 0xFF5F 0xFF62
   >;

}
