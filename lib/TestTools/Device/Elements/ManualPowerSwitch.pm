package TestTools::Device::Elements::ManualPowerSwitch;
use strict;
use warnings;
use Class::Interface;
&implements('TestTools::Device::Elements::PowerSwitchIF');

use Carp;
use Scalar::Util qw(blessed);

use TestTools::Device::Types::PowerSwitchStatus;

my %defaults = ();

sub New
{
    my ($this, $term_if, %params) = @_;

    croak "invalid term_if" unless blessed($term_if) && $term_if->isa('TestTools::Console::ReadLineIF');

    my %obj_hash;
    foreach my $field (keys %defaults)
    {
        $obj_hash{$field} = $params{$field} // $defaults{$field};
    }
    $obj_hash{'term_if'} = $term_if;

    my $class = ref($this) || $this;
    my $self = bless \%obj_hash => $class;
    return $self;
}

sub SwitchOn
{
    my ($this) = @_;
    $this->{'term_if'}->ReadLine('please switch ON and press enter...');
    return $this->{'status'} = TestTools::Device::Types::PowerSwitchStatus::ON;
}

sub SwitchOff
{
    my ($this) = @_;
    $this->{'term_if'}->ReadLine('please switch OFF and press enter...');
    return $this->{'status'} = TestTools::Device::Types::PowerSwitchStatus::OFF;
}

sub SwitchStatus
{
    my ($this) = @_;
    my $status = $this->{'term_if'}->ReadLine('please type in the current switch status (ON/OFF) > ');
    $status = uc($status // "");
    return $status eq 'ON' ? TestTools::Device::Types::PowerSwitchStatus::ON :
        $status eq 'OFF' ? TestTools::Device::Types::PowerSwitchStatus::OFF :
        TestTools::Device::Types::PowerSwitchStatus::ERR;
}

1;
