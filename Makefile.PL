#!/usr/bin/perl
# $File: /local/member/autrijus/encoding-warnings//Makefile.PL $ $Author: autrijus $
# $Revision: #5 $ $Change: 3558 $ $DateTime: 2004-03-14T14:32:20.135953Z $

use inc::Module::Install;

name		('encoding-warnings');
author		('Autrijus Tang <autrijus@autrijus.org>');
license		('perl');
abstract_from	('lib/encoding/warnings.pm');
version_from	('lib/encoding/warnings.pm');

WriteAll( sign => 1 );
