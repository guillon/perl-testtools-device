use strict;
use warnings;
use Test::More;

BEGIN { use_ok "TestTools::Device::Handlers::TimedPoweredDeviceHandler"; }

use Time::HiRes qw(gettimeofday);
use Package::Alias TestPowerSwitch => 'TestTools::Device::Elements::TestPowerSwitch';
use Package::Alias TimedPoweredDeviceHandler => 'TestTools::Device::Handlers::TimedPoweredDeviceHandler';

my $cycle_delay = 0;
my $power_on_delay = 0;
my $power_off_delay = 0;
my $hdl = TimedPoweredDeviceHandler->New(TestPowerSwitch->New(),
                                         'cycle_delay' => $cycle_delay,
                                         'power_on_delay' => $power_on_delay,
                                         'power_off_delay' => $power_off_delay,
    );

is($hdl->PowerOn(), 'ON', "power on");
is($hdl->PowerStatus(), 'ON', "power is on");
is($hdl->PowerOff(), 'OFF', "power off");
is($hdl->PowerStatus(), 'OFF', "power is off");
is($hdl->PowerRestart(), 'ON', "power restart");
is($hdl->PowerStatus(), 'ON', "power is on");
is($hdl->PowerOff(), 'OFF', "power off 2nd");
is($hdl->PowerStatus(), 'OFF', "power is off 2nd");

# Set power_on / power_off delay for the following tests
$hdl->{'power_on_delay'} = $power_on_delay = 0.5;
$hdl->{'power_off_delay'} = $power_off_delay = 0.3;
$hdl->{'cycle_delay'} = $cycle_delay = 0;

my $t0 = gettimeofday();
is($hdl->PowerOn(), 'ON', "power status is on");
cmp_ok(gettimeofday() - $t0, '>', $power_on_delay, "power on delay enforced");

$t0 = gettimeofday();
is($hdl->PowerOff(), 'OFF', "power status is off");
cmp_ok(gettimeofday() - $t0, '>', $power_off_delay, "power off delay enforced");

# Set cycle delay for the following tests
$hdl->{'power_on_delay'} = $power_on_delay = 0;
$hdl->{'power_off_delay'} = $power_off_delay = 0;
$hdl->{'cycle_delay'} = $cycle_delay = 1;

Time::HiRes::sleep($cycle_delay); # ensure cycle delay exhausted
$t0 = gettimeofday();
is($hdl->PowerOn(), 'ON', "power status is on");
is($hdl->PowerOff(), 'OFF', "power status is off");
cmp_ok(gettimeofday() - $t0, '>', $cycle_delay, "ON->OFF cycle delay enforced on power off");

is($hdl->PowerOn(), 'ON', "power status is on");
Time::HiRes::sleep($cycle_delay); # ensure cycle delay exhausted
$t0 = gettimeofday();
is($hdl->PowerOff(), 'OFF', "power status is off");
is($hdl->PowerOn(), 'ON', "power status is on");
cmp_ok(gettimeofday() - $t0, '>', $cycle_delay, "OFF->ON cycle delay enforced on power on");

Time::HiRes::sleep($cycle_delay); # ensure cycle delay exhausted
$t0 = gettimeofday();
is($hdl->PowerRestart(), 'ON', "power restart status is on");
cmp_ok(gettimeofday() - $t0, '>', $cycle_delay, "OFF->ON cycle delay enforced on restart");

# Set cycle and power on/off delays for the following tests
# Note, keep cycle delay > power on/off delay
$hdl->{'power_on_delay'} = $power_on_delay = 0.5;
$hdl->{'power_off_delay'} = $power_off_delay = 0.3;
$hdl->{'cycle_delay'} = $cycle_delay = 1;

Time::HiRes::sleep($cycle_delay); # ensure cycle delay exhausted
$t0 = gettimeofday();
is($hdl->PowerRestart(), 'ON', "power restart status is on");
cmp_ok(gettimeofday() - $t0, '>', $cycle_delay + $power_on_delay , "OFF->ON cycle delay plus power on delay enforced on restart");

is($hdl->PowerOff(), 'OFF', "power off status is off");
cmp_ok(gettimeofday() - $t0, '>', 2 * $cycle_delay + $power_off_delay , "OFF->ON->OFF double cycle delay plus power off delay enforced on restart plus power off");

$t0 = gettimeofday();


done_testing();
