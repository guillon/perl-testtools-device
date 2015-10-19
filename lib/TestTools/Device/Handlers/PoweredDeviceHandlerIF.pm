package TestTools::Device::Handlers::PoweredDeviceHandlerIF;

use Class::Interface;
&interface;

sub PowerOn;
sub PowerOff;
sub PowerStatus;
sub PowerRestart;

1;
