#!/usr/bin/perl

my (@data) = <STDIN>;

my (@multi, @multi_array_ref);
my (%ids_not_overlapped, %ids_overlapped);
my $overlapped_squares = 0;
foreach my $data (@data) {
    chomp($data);
    $data =~ /^\#(\d+).\@.(\d+),(\d+):\s(\d+)x(\d+)/;
    my $id = $1;
    my $posx = $2;
    my $posy = $3;
    my $w = $4;
    my $h = $5;
    for (my $x = $posx; $x < $posx+$w; $x++) {
        for (my $y = $posy; $y < $posy+$h; $y++) {
            push(@{$multi_array_ref[$x][$y]}, $id);
            $multi[$x][$y]+=1;
            if ($multi[$x][$y] == 2) {
                $overlapped_squares++;
                $ids_overlapped{$id} = 1;
            } elsif ($multi[$x][$y] == 1 && !$ids_overlapped{$id}) {
                $ids_not_overlapped{$id} = 1;
            }
            if ($#{$multi_array_ref[$x][$y]} > 0) {
                foreach my $tmpid (@{$multi_array_ref[$x][$y]}) {
                    delete $ids_not_overlapped{$tmpid};
                }
            }
        }
    }
}
foreach my $olkey (keys %ids_overlapped) {
    delete $ids_not_overlapped{$olkey};
}
print "overlapped_squares = $overlapped_squares\n";
foreach my $key (keys %ids_not_overlapped) {
    print STDERR "ids_not_overlapped: $key\n";
}
