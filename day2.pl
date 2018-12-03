#!/usr/bin/perl

my (@data) = <STDIN>;

my $total_two_times = 0;
my $total_three_times = 0;
foreach my $row (@data) {
    chomp($row);
    my (%hash);
    foreach my $letter (split('', $row)) {
        $hash{$letter}++;
    }
    my $two_times = 0;
    my $three_times = 0;
    foreach my $key (keys %hash) {
        $two_times = 1 if (!$two_times && $hash{$key} == 2);
        $three_times = 1 if (!$three_times && $hash{$key} == 3);
    }
    $total_two_times+=$two_times;
    $total_three_times+=$three_times;
}
print "two_times = $total_two_times\n";
print "three_times = $total_three_times\n";
my $checksum = $total_two_times * $total_three_times;
print "checksum: $checksum\n";

my $found_it = 0;
my $miss_postion;
my ($correct_string);
for (my $i = 0; $i <= $#data; $i++) {
    my $row = $data[$i];
    chomp($row);
    for (my $p = $i+1; $p <= $#data; $p++) {
        next if ($p == $i);
        my $copy = $data[$p];
        chomp($copy);
        my $misses = 0;
        my (@copy) = split('', $copy);
        my (@row) = split('', $row);
        my $current_string = '';
        for (my $x = 0; $x <= length($copy); $x++) {
            if ($copy[$x] ne $row[$x]) {
                $misses++;
                last if $misses > 1;
            } else {
                $current_string .= $copy[$x];
            }
        }
        if ($misses == 1) {
            $correct_string = $current_string;
            last;
        }
    }
    last if ($correct_string);
}
print "correct_letters: $correct_string\n";
