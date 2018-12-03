#!/usr/bin/perl

my ($data) = <STDIN>;

my (%values) = ('^' => [0,1], '<' => [-1,0], '>' => [1,0], 'v' => [0,-1]);
my (@multi);
$multi[10000][10000] = 2; # Leverans på startpos.
my $x = 10000;
my $xr = 10000;
my $y = 10000;
my $yr = 10000;
my $count_houses_with_present = 1; # Starta med 1
my $counter = 0;
foreach $dir (split('', $data)) {
    next if $dir !~ /[\<\>\^v]/;
    my ($curx, $cury);
    if ($counter % 2 == 0) {
        $y+=$values{$dir}->[1];
        $x+=$values{$dir}->[0];
        $curx = $x;
        $cury = $y;
    } else {
        $yr+=$values{$dir}->[1];
        $xr+=$values{$dir}->[0];
        $curx = $xr;
        $cury = $yr;
    }
    $multi[$curx][$cury]++;
    print "$dir gives x = $curx // y = $cury  => deliveries " . $multi[$curx][$cury];
    if ($multi[$curx][$cury] == 1) {
        $count_houses_with_present++;
        print " for first time ($count_houses_with_present)\n";
    } else {
        print " already counted\n";
    }
    $counter++;
}
print "count_houses_with_present = $count_houses_with_present (of $counter deliviers)\n";
