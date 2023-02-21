#!/usr/bin/env raku 

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM-NAME file ['uniname']

    Finds and reports non-ascii chars in the input file.
    If a specific char is specified, only it is searched.

    HERE

    exit;
}

my $f = @*ARGS.shift;
my $uniname = @*ARGS.elems ?? @*ARGS !! 0;
my $uord = 0;
my $ord  = 0;

die "FATAL: No such file '$f'!" if !$f.IO.f;

my $ff = $f.IO.basename;
$ff ~= '.non-ascii.log';
#say "log file: '$ff'"; die "DEBUG exit";

my $non-ascii-chars = 0;
my $total-chars     = 0;
my $line-num        = 0;
my $fp = 0;
END { $fp.close if $fp; }

for $f.IO.lines -> $line {
    ++$line-num;
    my $cnum = 1;
    my @c = $line.comb;
    my $found = 0;

    for @c -> $c {
        ++$cnum;
        ++$total-chars;

        $ord = $c.ord;

        if $ord > 127 {
            my $name = $c.uniname;
            next if $uniname && $name !~~ /^ :i $uniname $/; 

            $uord = $ord;
            $found = 1;
            ++$non-ascii-chars;
            say qq:to/HERE/;
            Found non-ascii char '$c' at line: $line-num, char $cnum
              Decimal code point: $ord
              Hex code point:     {sprintf "0x%04X", $ord}
              Name: $name
            HERE
        }
    }
    if $found {
        if !$fp {
            $fp = open $ff, :w;
            $fp.say: "# file: $f";
        }
        # output the file in a log file
        if $uniname {
            #  Hex code point:     {sprintf "0x%04X", $ord}
            my $hex = sprintf "0x%04X", $uord;
            $fp.say: "$line-num '$uniname', \\c[$uord], \\x[$hex]: $line";
        }
        else {
            $fp.say: "$line-num: $line";
        }
    }
}

if $uniname {
    my $hex = sprintf "0x%04X", $uord;
    say qq:to/HERE/;
        Searching for char '$uniname'
        Decimal value:     $uord
        Hex value:         $hex
        Normal completion.
        File:                    $f
        Number lines:            $line-num
        Total number chars:      {$total-chars + $line-num}
        Number '$uniname' chars: $non-ascii-chars
    HERE
}
else {
    say qq:to/HERE/;
        Normal completion.
        File:                   $f
        Number lines:           $line-num
        Total number chars:     {$total-chars + $line-num}
        Number non-ascii chars: $non-ascii-chars
    HERE
}


