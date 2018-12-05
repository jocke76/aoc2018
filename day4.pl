#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use DateTime::Duration;

my (@data) = <STDIN>;

my (%guard_arrayref, %guard_at_date, %guard_schema);
my (%guard_sleep_hours);
my $current_guardid = 0;

foreach my $row (@data) {
    next if ($row !~ /\#/);
    $row =~ /^\[(\d+)\-(\d+)\-(\d+)\s(\d+):(\d+)\]\s(.*)$/;
    my $year = $1;
    my $month = $2;
    my $day = $3;
    my $hour = $4;
    my $min  = $5;
    my $act = $6;
    $act =~ /\#(\d+)/;
    my $guardid = $1;

    my $dt = DateTime->new(year => $year, month => $month, day => $day, hour => $hour, minute => $min);
    if ($hour > 0) {
        my $nextday = $dt + DateTime::Duration->new( days => 1 );
        $nextday =~ /(\d+)\-(\d+)\-(\d+)T/;
        $year = $1;
        $month = $2;
        $day = $3;
    }
    $guard_at_date{$year.$month.$day} = $guardid;
}
foreach my $row (@data) {
    next if ($row =~ /\#/);
    $row =~ /^\[(\d+)\-(\d+)\-(\d+)\s(\d+):(\d+)\]\s(.*)$/;
    my $year = $1;
    my $month = $2;
    my $day = $3;
    my $hour = $4;
    my $min  = $5;
    my $act = $6;
    my $guardid = $guard_at_date{$year.$month.$day};
    push(@{$guard_schema{$guardid}}, $year.$month.$day . " " . $hour . ":" . $min . " " . $act);
}

my $sleeping = 0;
foreach my $guard (keys %guard_schema) {
    foreach my $schema (sort @{$guard_schema{$guard}}) {
        $schema =~ /^(\d+)\s(\d+):(\d+)\s(.*)$/;
        my $date = $1;
        my $hour = $2;
        my $min  = $3;
        my $act = $4;
        next unless ($act);
        #print $guard . ": $schema ($hour:$min) ($act) \n";
        if ($act =~ /falls/ && !$sleeping) {
            $sleeping = $min;
        } elsif ($act =~ /falls/ && $sleeping) {
            #print "$guard somnar igen, utan att vakna!!\n";
        } elsif ($act =~ /wakes/) {
            my $before = $guard_sleep_hours{$guard} || 0;
            for (my $x = $sleeping; $x < $min; $x++) {
                $guard_arrayref{$guard}[$x]++;
                $guard_sleep_hours{$guard}++;
            }
            my $diff = $guard_sleep_hours{$guard} - $before;
            #print $guard . ": slept for $diff minutes (between: $sleeping and $min) (before = $before // after = " . $guard_sleep_hours{$guard} . ")\n";
            $sleeping = 0;
        }
    }
    if ($sleeping) {
        print "WARNING: $guard still sleeps!\n";
    }
}
my $guard_slept_most = 0;
my $max_slept_hour = 0;
foreach my $guardid (keys %guard_sleep_hours) {
    #print $guardid . " " . $guard_sleep_hours{$guardid} . " > " . $max_slept_hour . "\n";
    if ($guard_sleep_hours{$guardid} > $max_slept_hour) {
        $max_slept_hour = $guard_sleep_hours{$guardid};
        $guard_slept_most = $guardid;
    }
}
print "Guardid that slept most: $guard_slept_most\n";
my $best_time = 0;
my $max_times = 0;
for (my $i = 0; $i <= 59; $i++) {
    my $key = $i;
    if ($i < 10) {
        $key = "0" . $i;
    }
    if ($guard_arrayref{$guard_slept_most}[$key]) {
        #print "00:".$key . ": " . $guard_arrayref{$guard_slept_most}[$key] . " > " . $max_times . "\n";
        if ($guard_arrayref{$guard_slept_most}[$key] > $max_times) {
            $best_time = $key;
            $max_times = $guard_arrayref{$guard_slept_most}[$key];
        }
    }
}
print "Best time: $best_time\n";
print "Gives: " . $best_time*$guard_slept_most . "\n";

my $best_guard = 0;
foreach my $guardid (keys %guard_sleep_hours) {
    for (my $i = 0; $i <= 59; $i++) {
        my $key = $i;
        if ($i < 10) {
            $key = "0" . $i;
        }
        if ($guard_arrayref{$guardid}[$key]) {
            #print "00:".$key . ": " . $guard_arrayref{$guard_slept_most}[$key] . " > " . $max_times . "\n";
            if ($guard_arrayref{$guardid}[$key] > $max_times) {
                $best_time = $key;
                $max_times = $guard_arrayref{$guardid}[$key];
                $best_guard = $guardid;
            }
        }
    }
}
print $best_guard . " slept $max_times @ $best_time\n";
print "gives: " . $best_guard * $best_time . "\n";
