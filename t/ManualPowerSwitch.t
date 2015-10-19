use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN { use_ok "TestTools::Device::Elements::ManualPowerSwitch"; }

use TestTools::Console::TestFixedReadLine;
use TestTools::Device::Types::PowerSwitchStatus qw(:all);

my $console = TestTools::Console::TestFixedReadLine->New(
    output => [
        'off', # swicth status
        '', 'on', # switch on action and status
        '', 'off', # switch off action and status
    ],
    silent => 1,
    );

my $switch = TestTools::Device::Elements::ManualPowerSwitch->New($console);
isnt($switch->SwitchStatus(), ERR, "power status is not ERR at start");
is($switch->SwitchOn(), ON, "power on");
is($switch->SwitchStatus(), ON, "power status after on");
is($switch->SwitchOff(), OFF, "power off");
is($switch->SwitchStatus(), OFF, "power status after off");

done_testing();
