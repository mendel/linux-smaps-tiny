package Linux::Smaps::Tiny;
use strict;
use warnings FATAL => "all";

use Exporter 'import';

our @EXPORT_OK = qw(get_smaps_summary);

=encoding utf8

=head1 NAME

Linux::Smaps::Tiny - A minimal and fast alternative to L<Linux::Smaps>

=head1 SYNOPSIS

    use Linux::Smaps::Tiny qw(get_smaps_summary);

    my $summary = get_smaps_summary();
    my $size = $summary->{Size};
    my $shared_clean = $summary->{Shared_Clean};
    my $shared_dirty = $summary->{Shared_Dirty};

    warn "Size / Clean / Dirty = $size / $shared_clean/ $shared_dirty";

=head1 DESCRIPTION

This module is a tiny interface to F</proc/$$/smaps> files. It was
written because when we rolled out L<Linux::Smaps> at a Big Internet
Company

=head1 FUNCTIONS

=head2 get_smaps_summary

Takes an optional process id (defaults to $$) and returns a summary of
the smaps data for the given process. Dies if the process does not
exist.

Returns a hashref like this:

        {
          'MMUPageSize' => '184',
          'Private_Clean' => '976',
          'Swap' => '0',
          'KernelPageSize' => '184',
          'Pss' => '1755',
          'Private_Dirty' => '772',
          'Referenced' => '2492',
          'Size' => '5456',
          'Shared_Clean' => '744',
          'Shared_Dirty' => '0',
          'Rss' => '2492'
        };

Values are in kB.

=cut

sub get_smaps_summary {
    my $proc_id= shift || $$;
    my $smaps_file= "/proc/$proc_id/smaps";
    open my $fh, "<", $smaps_file
        or die "Failed to read '$smaps_file': $!";
    my %sum;
    while (<$fh>) {
        if (/^([A-Za-z_]+):\s*([0-9]+) kB$/) {
            $sum{$1} += $2;
        }
    }
    close $fh;
    return \%sum;
}

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Yves Orton <yves@cpan.org> and Ævar Arnfjörð Bjarmason
<avar@cpan.org>

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

1;
