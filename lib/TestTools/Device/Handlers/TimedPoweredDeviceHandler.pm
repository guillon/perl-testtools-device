package TestTools::Device::Handlers::TimedPoweredDeviceHandler;

use Class::Interface;
&implements('TestTools::Device::Handlers::PoweredDeviceHandlerIF');

use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);

use Time::HiRes;
use TestTools::Device::Types::PowerSwitchStatus;

my %defaults = (
    'cycle_delay' => 5,
    'power_on_delay' => 2,
    'power_off_delay' => 2,
);
                   
sub New
{
    my ($this, $switch_if, %params) = @_;
    
    croak "invalid switch_if" unless blessed($switch_if) && $switch_if->isa('TestTools::Device::Elements::PowerSwitchIF');

    my %obj_hash;
    foreach my $field (keys %defaults)
    {
        $obj_hash{$field} = $params{$field} // $defaults{$field};
    }
    my $time = Time::HiRes::gettimeofday();
    # Assume could be just switched on or off, used to enforce cycle delay
    $obj_hash{'last_on'} = $time;
    $obj_hash{'last_off'} = $time;
    $obj_hash{'status'} = 'UND';
    $obj_hash{'switch_if'} = $switch_if;

    my $class = ref($this) || $this;
    my $self = bless \%obj_hash => $class;

    return $self;
    
}

sub PowerOn()
{
    my ($this) = @_;
    my $status = $this->_WaitStableStatus();
    return $status if $status eq 'ERR';
    if ($status eq 'OFF')
    {
        _SleepUntil($this->{'last_off'} + $this->{'cycle_delay'}); 
        $this->{'last_on'} = Time::HiRes::gettimeofday();
        $this->{'switch_if'}->SwitchOn();
        $status = $this->_WaitStableStatus();
        return 'ERR' if $status ne 'ON';
    }
    return $status;
}

sub PowerOff()
{
    my ($this) = @_;
    my $status = $this->_WaitStableStatus();
    return $status if $status eq 'ERR';
    if ($status eq 'ON')
    {
        _SleepUntil($this->{'last_on'} + $this->{'cycle_delay'}); 
        $this->{'last_off'} = Time::HiRes::gettimeofday();
        $this->{'switch_if'}->SwitchOff();
        $status = $this->_WaitStableStatus();
        return 'ERR' if $status ne 'OFF';
    }
    return $status;
}


sub PowerRestart
{
    my ($this) = @_;
    my $status = $this->_WaitStableStatus();
    return $status if $status eq 'ERR';
    if ($status eq 'ON')
    {
        $status = $this->PowerOff();
        return 'ERR' if $status ne 'OFF';
    }
    $status = $this->PowerOn();
    return 'ERR' if $status ne 'ON';
    return $status;
}

sub PowerStatus()
{
    my ($this) = @_;
    return $this->_UpdateStatus();
}

sub _WaitStableStatus()
{
    my ($this) = @_;
    my $status = $this->{'switch_if'}->SwitchStatus();
    if ($status == TestTools::Device::Types::PowerSwitchStatus::ON)
    {
        _SleepUntil($this->{'last_on'} + $this->{'power_on_delay'});
        return $this->{'status'} = 'ON';
    }
    elsif ($status  == TestTools::Device::Types::PowerSwitchStatus::OFF)
    {
        _SleepUntil($this->{'last_off'} + $this->{'power_off_delay'});
        return $this->{'status'} = 'OFF';
    }
    else
    {
        return $this->{'status'} = 'ERR';
    }
}
    
sub _UpdateStatus()
{
    my ($this) = @_;
    my $status = $this->{'switch_if'}->SwitchStatus();
    my $time = Time::HiRes::gettimeofday();
    if ($status == TestTools::Device::Types::PowerSwitchStatus::ON)
    {
        return $this->{'status'} = 'UND' if $time < $this->{'last_on'} + $this->{'power_on_delay'};
        return $this->{'status'} = 'ON';
    }
    elsif ($status == TestTools::Device::Types::PowerSwitchStatus::OFF)
    {
        return $this->{'status'} = 'UND' if $time < $this->{'last_off'} + $this->{'power_off_delay'};
        return $this->{'status'} = 'OFF';
    }
    else
    {
        return $this->{'status'} = 'ERR';
    }
    
}

sub _SleepUntil
{
    my ($expected) = @_;
    my $t0 = Time::HiRes::gettimeofday();
    my $current = $t0;
    while ($current < $expected) {
        Time::HiRes::sleep($expected - $current);
        $current = Time::HiRes::gettimeofday();
    }
    return $current - $t0;
}

1;

