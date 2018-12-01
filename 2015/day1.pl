#!/usr/bin/perl

my $floor = 0;
my $counter = 1;
foreach my $data (split //, <STDIN>) {
    $floor++ if ($data eq '(');
    $floor-- if ($data eq ')');
    if (!$found_basement_counter && $floor == -1) {
        $found_basement_counter = $counter;
    }
    $counter++;
}
print "floor: $floor\n";
print "counter: $found_basement_counter\n";
