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

=item Edit your F</opt/rt5/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::ChangeManagement');

=item C<make initdb>

Only run this the first time you install this module. If you run this twice, 
you may end up with duplicate data in your database.

=item Clear your mason cache

    rm -rf /opt/rt5/var/mason_data/obj

=item Restart your webserver

=back 

=head1 DESCRIPTION

Implements a minimalistic change management process within RT.

It is often the case that businesses that have achieved some level of ISO or
SOC compliance must have a standardized process by which to handle changes to
software, hardware, infrastructure, etc. This extension implements a minimal
change management system within RT. It provides a framework for handling a 
variety of change types, and leaves a lot of room for growth and flexibility
with regards to your organization's practices and procedures. Out of the box,
it resembles a scaled down version of an ITIL-like change management process.

When combined with L<RT::Extension::MandatoryOnTransition>, this extension 
can transform into a fully-featured change management system.

=head2 Change Management Queue

After installing, you'll see a new queue called B<Change Management> for tracking
all of the incoming change requests. You can change the name to anything you like 
after installing. In a typical configuration, you will also want to assign an RT 
email address, like changes@example.com or crb@example.com (Change Review Team)
to create tickets in this queue.

=head2 Custom Roles

There are two roles than can be assigned to users that are part of the change 
management process:

=over

=item Change Reviewer

Someone who can approve a change request

=item Change Implementor

Someone who can implement a change request

=back

=head2 Groups

The Change Management extension introduces one new group to RT: Change Review Team.
Any members of this group are capable of approving or rejecting proposed changes in
the Change Management queue.

=head2 Ticket Statuses

Tickets in the change management queue can have any one of the following statuses:

=over 

=item Requested

Status given to a new item. Indicates than a change has been requested and is 
awaiting approval.

=item Approved

Tickets with a status of Requested can be moved to Approved if the change has been
accepted by the change review team.

=item In Progress

An approved change that is in the process of being deployed.

=item Partially Deployed

The change has been partially deployed; it is either taking an unusually long time
to complete, or part of the deployment succeeded while another part failed. Reasons
as to why should be detailed in a comment.

=item Deployed

The change has been deployed successfully.

=item Failed

The change failed to deploy. Reasons should be detailed in a comment.

=item Cancelled

This change was cancelled. Reasoning should be provided in a comment.

=item Rejected

The change was rejected by the review team. Reasoning should be provided in a 
comment on the ticket.

=back

=head2 Custom Fields

=head3 Change Category

Specifies the kind of change that is to be performed. Possible values include:

=over

=item Configuration Change

=item OS Patching

=item Firmware Update

=item Software Update

=item New Software Install

=item Hardware Repair

=item New Hardware Install

=item Project Implementation

=back

=head3 Change Type

One of the three types of change types outlined in ITIL:

=over 

=item Standard 

A low risk, pre-authorized change that follows a repeatable process. This is the
default for new tickets in the Change Management queue.

=item Emergency

A change that must be performed ASAP, potentially bypassing approval steps.

=item Normal

Any change that doesn't fall into the other types.

=back

=head3 Rollback Plan

A description of the steps necessary to perform a rollback of the proposed
changes in the event that the deployment process is unsuccessful.

=head3 Change Started

Date that the change was started. This is B<not> the same as the normal Started
date on the ticket - Started is set when the ticket is moved to an open status
(such as approved); Change Started is when someone actually started implementation 
of the change.

=head3 Change Complete

Date that the change was successfully deployed (or, partially deployed).

=head2 Actions

=head3 Submit Request

Changes the status of a ticket to requested.

=head3 Approve Request

Mark a change management request ticket as approved. Requires the Change Reviewer role.

=head3 Deny Request

Deny the change management request. Requires the Change Reviewer role.

=head3 Start Deployment

Changes the ticket status to in progress. Requires the Change Implementor role.

=head3 Deployment Complete

Marks the change request as deployed. Requires the Change Implementor role.

=head3 Partially Deployed

Marks the change request as partially deployed. Requires the Change Implementor role.

=head3 Deployment Failed

Changes the status of the request to failed. Requires the Change Implementor role.

=head3 Deployment Cancelled

Cancels the change request (changes status to failed). Requires the Change Implementor role.

=head2 Rights

=head3 Change Reviewer

Person who reviews incoming change requests, and is responsible for approving or
denying a change request. Can be assigned to a group.

=head3 Change Implementor

Person who is responsible for implementing a change request. This role can be assigned
to a group.

=head1 CUSTOMIZING AND EXTENDING

There are some ways RT::Extension::ChangeManagement can be customized to provide
an even more robust change management system.

=head2 Additional Custom Fields

Some ideas of fields that could be added to the change management process might include:

=over

=item Change Origin

Customer, Vendor, Internal. Dropdown.

=item Location

Datacenter, customer site, etc. Text.

=item Implementation Steps

Steps needed to implement proposed change. Text.

=item Validation Steps

Process for validating a change was deployed successfully. Text.

=item Impact Assessment

A description of what potential side effects of a proposed change might be, what 
could happen if the change goes awry, etc. Text.

=back

=head3 Making Custom Fields Required

Using L<RT::Extension::MandatoryOnTransition>, any of the above fields can be made
required upon a status change. For example, you may wish to make Implementation Steps,
Validation Steps, and Impact Assessment required fields before a change request can
be approved.

=head3 Calendar View

With L<RTx::Calendar>, you can add a calendar portlet to your dashboard, as well
as a full page calendar view of change management tickets and reminders.

=head3 Default Values for Custom Fields

If you look at F<etc/initialdata> in the plugin directory, you will find a section
called C<@Final> (unsurprisingly, it is the last section of configuration).
There you will find some sample code and documentation for setting a default value 
for a custom field.

The process basically boils down to:

=over

=item Load a named queue

=item Load a custom field by name

=item Set the default value for that custom field in that queue

=back

=head2 Approvals Queue

If you have an established Change Review Board, your organization is likely dealing
with a high volume of change requests. Separating requests into a second queue can 
make it quicker and easier to process, as new requests are not interspersed with 
other changes in various stages of completion.

To separate change requests into a separate approvals queue, see the docs in the
L<Customizing/Approvals> guide.

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
