#!/usr/bin/perl
# $File: /local/member/autrijus/encoding-warnings//t/3-normal.t $ $Author: autrijus $
# $Revision: #4 $ $Change: 3557 $ $DateTime: 2004-03-14T14:30:00.950648Z $

use Test;
BEGIN { plan tests => 2 }

use strict;
use encoding::warnings 'FATAL';
ok(encoding::warnings->VERSION);

if ($] < 5.008) {
    ok(1);
    exit;
}

my ($a, $b, $c, $ok);
$ok = 1;

$SIG{__DIE__} = sub { $ok = 0 };
$SIG{__WARN__} = sub { $ok = 0 };

$a = chr(20000);
$b = chr(20000);
$c = $a . $b;

ok($ok);
