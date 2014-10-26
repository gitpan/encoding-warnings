#!/usr/bin/perl
# $File: /local/member/autrijus/encoding-warnings//t/0-signature.t $ $Author: autrijus $
# $Revision: #4 $ $Change: 3561 $ $DateTime: 2004-03-14T14:33:23.045153Z $

use strict;
print "1..1\n";

if (!-s 'SIGNATURE') {
    print "ok 1 # skip No signature file found\n";
}
elsif (!eval { require Module::Signature; 1 }) {
    print "ok 1 # skip ",
	    "Next time around, consider install Module::Signature, ",
	    "so you can verify the integrity of this distribution.\n";
}
elsif (!eval { require Socket; Socket::inet_aton('pgp.mit.edu') }) {
    print "ok 1 # skip ",
	    "Cannot connect to the keyserver\n";
}
else {
    (Module::Signature::verify() == Module::Signature::SIGNATURE_OK())
	or print "not ";
    print "ok 1 # Valid signature\n";
}

__END__
