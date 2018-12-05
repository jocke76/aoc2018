#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use DateTime::Duration;

my ($data) = <STDIN>;
#chomp($data);
my (@data) = split('', $data);

my (%chars);
my $something_was_removed = 1;
while ($something_was_removed) {
    $something_was_removed = 0;
    for (my $i = 0; $i < length($data); $i++) {
        next if (!$data[$i+1]);
        my $cl = $data[$i];
        my $nl = $data[$i+1];
        $chars{uc $cl} = 1;
        if (ord($cl) == ord($nl)+32 || ord($nl) == ord($cl)+32) {
            $something_was_removed = 1;
            splice @data, $i, 2;
#            print "eliminated $cl && $nl @ $i \n";
            $i-=5;
        }
    }
}
for (my $x = 0; $x <= scalar(@data); $x++) {
    if ($data[$x] !~ /[a-zA-z]+/) {
        print "empty @ $x\n";
        splice @data, $x, 1;
    }
}
my $new_data = join('', @data);
print "längd på data: " . scalar(@data) . "\n";
#print join('', @data);
#foreach my $letter (@data) {
#    print "> $letter\n";
#}
$something_was_removed = 1;
my $shortest_string = $new_data;
foreach my $char (keys %chars) {
    next unless ($char =~ /[A-Z]/);
    my $this_data = $new_data;
    my $small_case = lc $char;
    my $upper_case = $char;
    $this_data =~ s/[$small_case$upper_case]//g;
    #print "$small_case$upper_case (length after removed: " . length($this_data) . "\n";
    my (@this_data) = split('', $this_data);
    $something_was_removed = 1;
    while ($something_was_removed) {
        $something_was_removed = 0;
        for (my $i = 0; $i < length($this_data); $i++) {
            next if (!$this_data[$i+1]);
            my $cl = $this_data[$i];
            my $nl = $this_data[$i+1];
            if (ord($cl) == ord($nl)+32 || ord($nl) == ord($cl)+32) {
                $something_was_removed = 1;
                splice @this_data, $i, 2;
                $i-=5;
            }
        }
    }
    my $temp_string = join('', @this_data);
    if (length($temp_string) < length($shortest_string)) {
        $shortest_string = $temp_string;
    }
}
print "längd på kortaste sträng: " . length($shortest_string) ."\n";
