#!/usr/bin/perl
# $File: /local/member/autrijus/encoding-warnings//t/1-warning.t $ $Author: autrijus $
# $Revision: #5 $ $Change: 3574 $ $DateTime: 2004-03-14T16:50:39.261078Z $

use Test;
BEGIN { plan tests => 2 }

use strict;
use encoding::warnings;
ok(encoding::warnings->VERSION);

if ($] < 5.008) {
    ok(1);
    exit;
}

my ($a, $b, $c, $ok);

$SIG{__WARN__} = sub {
    if ($_[0] =~ /upgraded/) { ok(1); exit }
};

utf8::encode($a = chr(20000));
$b = chr(20000);
$c = $a . $b;

ok($ok);
