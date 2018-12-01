#!/usr/bin/perl

my (@data) = <STDIN>;

my $total_sqf = 0;
my $total_rib = 0;
my $counter = 0;
foreach my $dim (@data) {
    chomp($dim);
    my ($l, $w, $h) = split('x', $dim);
    my $side_one = $l*$w;
    my $side_two = $w*$h;
    my $side_tre = $l*$h;
    @sorted = sort { $a <=> $b } $side_one, $side_two, $side_tre;
    $total = 2*$side_one + 2*$side_two + 2*$side_tre + $sorted[0];
    $total_sqf += $total;

    @sorted_for_ribbon = sort { $a <=> $b } $l, $w, $h;
    $ribbon_length = $sorted_for_ribbon[0]*2 + $sorted_for_ribbon[1]*2 + $l*$w*$h;
    $total_rib += $ribbon_length;
    $counter++;
}
print "total_sqf = $total_sqf\n";
print "total_rib = $total_rib\n";
