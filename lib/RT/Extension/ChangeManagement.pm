use strict;
use warnings;
package RT::Extension::ChangeManagement;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-ChangeManagement - Default Change Management configuration for RT

=head1 RT VERSION

Works with RT 5.

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::ChangeManagement');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=head1 DESCRIPTION

Implements a minimalistic change management process within RT.

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-ChangeManagement@rt.cpan.org">bug-RT-Extension-ChangeManagement@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-ChangeManagement">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-ChangeManagement@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-ChangeManagement

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Best Practical Solutions, LLC.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
