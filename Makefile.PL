#!/usr/bin/env perl

use inc::Module::Install;

name 'TestTools-Device';
version_from 'lib/TestTools/Device.pm';
author 'Christophe Guilln <christophe.guillon@st.com';
abstract 'Device Interfaces Module';
license 'perl';
perl_version '5.010';

requires 'Class::Interface'  => 0;
requires 'Scalar::Util' => 0;
requires 'Time::HiRes' => 0;

test_requires 'Test::More' => 0;
test_requires 'Test::Exception' => 0;
test_requires 'Package::Alias' => 0;

WriteAll;
