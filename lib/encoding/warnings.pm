# $File: //member/autrijus/.vimrc $ $Author: autrijus $
# $Revision: #14 $ $Change: 4137 $ $DateTime: 2003/02/08 11:41:59 $

package encoding::warnings;
$VERSION = '0.01';

use strict;

=head1 NAME

encoding::warnings - Warn on implicit encoding conversions

=head1 SYNOPSIS

    use encoding::warnings; # or 'FATAL' to raise fatal exceptions

    utf8::encode($a = chr(20000));  # a byte string
    $b = chr(20000);		    # a unicode string

    # Bytes implicitly upgraded into wide characters as iso-8859-1"
    $c = $a . $b;

=head1 DESCRIPTION

=head2 Overview of the problem

By default, there is a fundamental asymmetry in Perl's unicode model:
implicit upgrading from byte strings to Unicode strings assumes that
they were encoded in I<ISO 8859-1 (Latin-1)>, but Unicode strings are
downgraded with UTF-8 encoding.  This happens because the first 256
codepoints in Unicode happens to agree with Latin-1.  

However, this silent upgrading can easily cause problems, if you happen
to mix unicode strings with non-latin1 data -- i.e. byte strings encoded
in UTF-8 or other encodings.  The error will not manifest until the
combined string is written to output, at which time it would be impossible
to see where did the silent upgrading occur.

=head2 Detecting the problem

This module simplifies the process of diagnosing such problems.  Just put
this line on top of your main program:

    use encoding::warnings;

Afterwards, implicit upgrading of high-bit bytes will raise a warning.
Ex.: C<Bytes implicitly upgraded into wide characters as iso-8859-1 at
- line 7>.

You can also make the warnings fatal by importing this module as:

    use encoding::warnings 'FATAL';

=head2 Solving the problem

Most of the time, this warning occurs when a byte-string is concatenated
with a unicode-string.  There are a number of ways to solve it

=over 4

=item * Upgrade both sides to unicode-strings

If your program does not need compatibility for Perl 5.6 and earlier,
the recommended approach is to apply appropriate IO disciplines so all
data in your program are unicode strings.  See L<encoding>, L<open> and
L<perlfunc/binmode> for how.

=item * Downgrade both sides to byte-strings

The other way works too, especially if you are sure that all your data
are under the same encoding, or compatibility with older perls is desired.

You may downgrade strings with C<Encode::encode> and C<utf8::encode>.
See L<Encode> and L<utf8> for details.

=item * Specify the encoding for implicit byte-string upgrading

If you are confident that all byte-strings will be in a specific
encoding like UTF-8, I<and> need not to support older perls, use the
C<encoding> pragma:

    use encoding 'utf8';

Similarly, this will silence warnings from this module, and preserve the
default behaviour:

    use encoding 'iso-8859-1';

=back

=head1 CAVEATS

The module currently affects the whole script, instead of inside its
lexical block.  This is expected to be addressed during Perl 5.9 development.

=cut

# Constants.
sub ASCII  () { 0 }
sub LATIN1 () { 1 }
sub FATAL  () { 2 }

# Install a ^ENCODING handler if no other one are already in place.
sub import {
    my $class = shift;
    my $fatal = shift || '';

    return if ${^ENCODING} and ref(${^ENCODING}) ne $class;
    return unless eval { require Encode; 1 };

    my $ascii  = Encode::find_encoding('us-ascii') or return;
    my $latin1 = Encode::find_encoding('iso-8859-1') or return;

    # Have to undef explicitly here
    undef ${^ENCODING};

    # Install a warning handler for decode()
    ${^ENCODING} = bless(
	[
	    $ascii,
	    $latin1,
	    (($fatal eq 'FATAL') ? 'Carp::croak' : 'Carp::carp'),
	], $class,
    );
}

# Don't worry about source code literals.
sub cat_decode {
    my $self = shift;
    return $self->[LATIN1]->cat_decode(@_);
}

# Warn if the data is not purely US-ASCII.
sub decode {
    my $self = shift;

    local $@;
    eval { $self->[ASCII]->decode($_[0], Encode::FB_CROAK()); 1 };
    if ($@) {
	require Carp;
	no strict 'refs';
	$self->[FATAL]->(
	    "Bytes implicitly upgraded into wide characters as iso-8859-1"
	);
    }
    return $self->[LATIN1]->decode(@_);
}

1;

__END__

=head1 SEE ALSO

L<perlunicode>, L<perluniintro>

L<open>, L<utf8>, L<encoding>, L<Encode>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2004 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
