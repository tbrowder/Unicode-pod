#!/usr/bin/env raku

my $ucd-ver = '15.0'; # use same as rakudo
my $ucd-dir = "./UCD.v{$ucd-ver}";
my $ucd     = 'UnicodeData.txt';
my $fi = "$ucd-dir/$ucd";
my $fo = 'space-chars.list';
my $fh = open $fo, :w;

my @v;
my @h;
my @nb;

# a hash of unicode control chars and aliases
# from: http://www.unicode.org/Public/UCD/latest/ucd/NameAliases.txt
my %aliases = [
    "\x[0009]" => "HORIZONTAL TABULATION;",
    "\x[000A]" => "NEW LINE",
    "\x[000B]" => "VERTICAL TABULATION",
    "\x[000C]" => "FORM FEED",
    "\x[000D]" => "CARRIAGE RETURN",
    "\x[000E]" => "LOCKING-SHIFT ONE",
    "\x[000F]" => "LOCKING-SHIFT ZERO",
    "\x[0085]" => "NEXT LINE",

];

my $n = 0;
for 0x0000..0x3000 -> $intchar {
    ++$n;

    # check for various properties
    my $c = $intchar.chr;
    my $uname = $c.uniname;
    my $hexchar = sprintf "0x%04X", $intchar;
    say "checking unicode hex char $hexchar ($uname)...";

    my $h = $c ~~ /\h/;
    my $v = $c ~~ /\v/;

    # eliminate non-space chars
    next if !($v || $h);

    my $proplist = $c.uniprop;
    if $uname ~~ /:i control/ {
        if %aliases{$c}:exists {
            $uname ~=  " ; alias: {%aliases{$c}}";
        }
    }

    my $text = "    # $hexchar $uname ; $proplist";

    if $v {
        $text ~= " ; \\v space char";
        if $uname ~~ /:i no '-' break / {
            @nb.push: $text;
        }
        else {
            @v.push: $text;
        }
    }
    elsif $h {
        $text ~= " ; \\h space char";
        if $uname ~~ /:i no '-' break / {
            @nb.push: $text;
        }
        else {
            @h.push: $text;
        }
    }
    else {
        note "unexpected $text";
    }

    =begin comment
    $fh.say: "$i. unicode hex char $hexchar";
    $fh.say: "  name: $uname";
    my $z  = $c ~~ /<:Z>/;
    my $zs = $c ~~ /<:Zs>/;
    $fh.say("  has Z property") if $z;
    $fh.say("  has Zs property") if $zs;
    =end comment
}

my $v = +@v;
my $h = +@h;
my $b = +@nb;
my $t = $v + $h + $b;

say "$n chars considered";
say "See file '$fo'";

$fh.say: "    #=== $t total chars =========";
$fh.say: "    #=== $b total no-break chars:";
$fh.say($_) for @nb;
$fh.say: "    #=== $v total vertical chars:";
$fh.say($_) for @v;
$fh.say: "    #=== $h total horizontal chars:";
$fh.say($_) for @h;
