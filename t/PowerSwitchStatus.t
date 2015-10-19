use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN { use_ok "TestTools::Device::Types::PowerSwitchStatus"; }

use Package::Alias PowerSwitchStatus => 'TestTools::Device::Types::PowerSwitchStatus';
use TestTools::Device::Types::PowerSwitchStatus qw(:all);
is(PowerSwitchStatus::ERR, ERR, 'ERR defined'); 
is(PowerSwitchStatus::ON, ON, 'ON defined'); 
is(PowerSwitchStatus::OFF, OFF, 'OFF defined'); 

done_testing();
