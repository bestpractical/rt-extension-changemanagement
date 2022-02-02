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
            },
            'approved -> in progress' => {
                label  => 'Start Implementation',
            },
            'in progress -> deployed' => {
                label  => 'Complete Implementation',
            },
            'in progress -> partially deployed' => {
                label  => 'Partially Complete',
            },
            'in progress -> failed' => {
                label  => 'Deployment Failed',
            },
            'in progress -> cancelled' => {
                label  => 'Deployment Cancelled',
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

