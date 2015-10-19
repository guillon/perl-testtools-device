use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN { use_ok "TestTools::Device::Elements::TestPowerSwitch"; }

use TestTools::Device::Types::PowerSwitchStatus qw(:all);

my $switch = TestTools::Device::Elements::TestPowerSwitch->New();
isnt($switch->SwitchStatus(), ERR, "power status is not ERR at start");
is($switch->SwitchOn(), ON, "power on");
is($switch->SwitchStatus(), ON, "power status after on");
is($switch->SwitchOff(), OFF, "power off");
is($switch->SwitchStatus(), OFF, "power status after off");
is($switch->SwitchOff(), OFF, "power off 2nd");
is($switch->SwitchStatus(), OFF, "power status after off 2nd");
is($switch->SwitchOn(), ON, "power on 2nd");
is($switch->SwitchStatus(), ON, "power status after on 2nd");
is($switch->SwitchOn(), ON, "power on 3rd");
is($switch->SwitchStatus(), ON, "power status after on 3rd");
is($switch->SwitchOff(), OFF, "power off 3rd");
is($switch->SwitchStatus(), OFF, "power status after off 3rd");

done_testing();
