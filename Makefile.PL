#!/usr/bin/perl
# $File: /member/local/autrijus/encoding-warnings/Makefile.PL $ $Author: autrijus $
# $Revision: #3 $ $Change: 1625 $ $DateTime: 2004-03-14T16:50:26.012462Z $

use inc::Module::Install;

name		('encoding-warnings');
author		('Autrijus Tang <autrijus@autrijus.org>');
license		('perl');
abstract_from	('lib/encoding/warnings.pm');
version_from	('lib/encoding/warnings.pm');

WriteAll( sign => 1 );
