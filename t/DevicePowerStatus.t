use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN { use_ok "TestTools::Device::Types::DevicePowerStatus"; }

use Package::Alias DevicePowerStatus => 'TestTools::Device::Types::DevicePowerStatus';
use TestTools::Device::Types::DevicePowerStatus qw(:all);
is(DevicePowerStatus::ERR, ERR, 'ERR defined'); 
is(DevicePowerStatus::ON, ON, 'ON defined'); 
is(DevicePowerStatus::OFF, OFF, 'OFF defined'); 
is(DevicePowerStatus::UND, UND, 'UND defined'); 

done_testing();
