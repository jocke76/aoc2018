#!/usr/bin/perl

my (@data) = <STDIN>;
my $current_freq = 0;
my (%matched_freq) = ('0' => 1);
my $counter = 0;
my $found_match = 0;
myloop: foreach $data (@data) {
    $counter++;
    $current_freq += $data;
    $matched_freq{$current_freq}++;
    if ($matched_freq{$current_freq} > 1) {
        print STDERR "First matched twice: " . $current_freq . "\n";
        $found_match = 1;
        last;
    }
}
print STDERR "$counter = $counter\n";
goto myloop unless ($found_match);
