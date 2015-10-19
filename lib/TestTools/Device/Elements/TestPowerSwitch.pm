package TestTools::Device::Elements::TestPowerSwitch;
use strict;
use warnings;
use Class::Interface;
&implements('TestTools::Device::Elements::PowerSwitchIF');

use TestTools::Device::Types::PowerSwitchStatus;

my %defaults = (
    status => TestTools::Device::Types::PowerSwitchStatus::OFF # Assume off for the initial status
    );

sub New
{
    my ($this, %params) = @_;

    my %obj_hash;
    foreach my $field (keys %defaults)
    {
        $obj_hash{$field} = $params{$field} // $defaults{$field};
    }
    
    my $class = ref($this) || $this;
    my $self = bless \%obj_hash => $class;
    return $self;
}

sub SwitchOn
{
    my ($this) = @_;
    return $this->{'status'} = TestTools::Device::Types::PowerSwitchStatus::ON;
}

sub SwitchOff
{
    my ($this) = @_;
    return $this->{'status'} = TestTools::Device::Types::PowerSwitchStatus::OFF;
}

sub SwitchStatus
{
    my ($this) = @_;
    return $this->{'status'};
}

1;
