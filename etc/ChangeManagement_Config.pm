# Groups the change management fields together in their own section on the
# ticket display
Set(%CustomFieldGroupings,
    'RT::Ticket' => [
        'Dates' => ['Change Started','Change Completed'],
        'Change Management' => [
            'Change Category',
            'Change Type',
            'Rollback Plan',
        ],
    ],
);

# Creates the change management lifecycle. Allowed status changes, menu actions, 
# rights, ACLs are defined here. If you're going to make customizations to this
# extension, most of that work will happen here.
Set(%Lifecycles,
    'Change Management' => {
        initial         => [ qw( requested ) ], # loc_qw
        active          => [ 'approved', 'in progress', 'partially deployed' ], # loc_qw
        inactive        => [ qw( deployed failed cancelled rejected deleted ) ], # loc_qw
        defaults => {
            on_create   => 'requested',
        },
        transitions => {
            # The following transition is required for ticket creation
            ''                   => [ qw( requested ) ],
            requested            => [ qw( approved deployed failed cancelled rejected deleted ), 'in progress', 'partially deployed' ],
            approved             => [ qw( deployed failed cancelled rejected deleted ), 'in progress', 'partially deployed' ],
            'in progress'        => [ qw( approved deployed failed cancelled rejected deleted ), 'partially deployed' ],
            'partially deployed' => [ qw( approved deployed failed cancelled rejected deleted ), 'in progress' ],
            deployed             => [ qw( approved failed cancelled rejected deleted ), 'in progress', 'partially deployed' ],
            failed               => [ qw( approved deployed cancelled rejected deleted ), 'in progress', 'partially deployed' ],
            cancelled            => [ qw( approved deployed failed rejected deleted ), 'in progress', 'partially deployed' ],
            rejected             => [ qw( approved deployed failed cancelled deleted ), 'in progress', 'partially deployed' ],
        },
        rights => {
            'requested -> approved'             => 'Change Reviewer',
            'requested -> rejected'             => 'Change Reviewer',
            'approved -> in progress'           => 'Change Implementor',
            'in progress -> deployed'           => 'Change Implementor',
            'in progress -> partially deployed' => 'Change Implementor',
            'in progress -> failed'             => 'Change Implementor',
        },
        actions => [
            '* -> requested' => {
                label  => 'Submit Request',
            },
            'requested -> approved' => {
                label  => 'Approve Request',
            },
            'requested -> rejected' => {
                label  => 'Deny Request',
                update => 'Respond',
            },
            'requested -> cancelled' => {
                label  => 'Deployment Cancelled',
                update => 'Respond',
            },
            'approved -> in progress' => {
                label  => 'Start Deployment',
            },
            'approved -> cancelled' => {
                label  => 'Deployment Cancelled',
            },
            'in progress -> deployed' => {
                label  => 'Deployment Complete',
            },
            'in progress -> partially deployed' => {
                label  => 'Partially Deployed',
                update => 'Respond',
            },
            'in progress -> failed' => {
                label  => 'Deployment Failed',
                update => 'Respond',
            },
            'in progress -> cancelled' => {
                label  => 'Deployment Cancelled',
                update => 'Respond',
            },
            'partially deployed -> deployed' => {
                label  => 'Deployment Complete',
            },
            'partially deployed -> failed' => {
                label  => 'Deployment Failed',
                update => 'Respond',
            },
            'partially deployed -> cancelled' => {
                label  => 'Deployment Cancelled',
                update => 'Respond',
            },
        ]
    },
    __maps__ => {
        'default -> Change Management' => {
            'new'         => 'requested',
            'resolved'    => 'deployed',
            'open'        => 'in progress',
            'rejected'    => 'rejected',
            'open'        => 'partially deployed',
            'deleted'     => 'deleted',
        },
        'Change Management -> default' => {
            'requested'          => 'new',
            'deployed'           => 'resolved',
            'rejected'           => 'rejected',
            'deleted'            => 'deleted',
            'in progress'        => 'open',
            'approved'           => 'open',
            'partially deployed' => 'open', 
            'failed'             => 'resolved',
            'cancelled'          => 'resolved',
        },
    }
);

1;

