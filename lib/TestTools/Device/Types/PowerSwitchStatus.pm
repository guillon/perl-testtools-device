package TestTools::Device::Types::PowerSwitchStatus;
use strict;
use warnings;
use Exporter qw(import);

my %constants;
BEGIN {
    %constants = (
        ERR => -1,
        OFF => 0,
        ON => 1,
        );
}
        
use constant \%constants;
our @EXPORT = ();
our @EXPORT_OK = keys(%constants);
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
    default => \@EXPORT,
    );

1;
