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

It is often the case that businesses that have achieved some level of ISO or
SOC compliance must have a standardized process by which to handle changes to
software, hardware, infrastructure, etc. This extension implements a minimal
change management system within RT. It provides a framework for handling a 
variety of change types, and leaves a lot of room for growth and flexibility
with regards to your organization's practices and procedures.

When combined with L<RT::Extension::MandatoryOnTransition>, this extension 
can transform into a fully-featured change management system.

=head2 Change Management Queue

After installing, you'll see a new queue called L<Change Management> for tracking
all of the incoming change requests. You can change the name to anything you like 
after installing. In a typical configuration, you will also want to assign an RT 
email address, like changes@example.com or crb@example.com (Change Review Board)
to create tickets in this queue.

=head2 Custom Roles

=head2 Groups

=head3 Ticket Statuses

Tickets in the change management queue can have any one of the following statuses:

=over 4

=item * Requested

Status given to a new item. Indicates than a change has been requested and is 
awaiting approval.

=item * Approved

Tickets with a status of Requested can be moved to Approved if the change has been
accepted by the change review team.

=item * Deployed

=back

=head2 Change Management Lifecycle

=head2 Custom Fields

=head3 Change Category

=head3 Change Type

=head3 Deployed Date

=head3 Rollback Plan

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
