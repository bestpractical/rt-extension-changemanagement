Set(%Lifecycles,
    'ChangeManagement' => {
        initial         => [ qw( Requested ) ], # loc_qw
        active          => [ 'Approved', 'In Progress', 'Partially Deployed' ], # loc_qw
        inactive        => [ qw( Deployed Failed Cancelled Rejected deleted ) ], # loc_qw
        defaults => {
            on_create            => 'Requested',
            approved             => 'Approved',
            denied               => 'Rejected',
        },
        transitions => {
            # The following transition is required for ticket creation
            ''                   => [ qw( Requested ) ],
            Submitted            => [ qw( Approved Cancelled Rejected deleted ) ],
            Approved             => [ 'In Progress', qw( Cancelled Rejected deleted ) ],
            'In Progress'        => [ 'Partially Deployed', qw( Deployed Failed Cancelled deleted ) ],
            'Partially Deployed' => [ qw( Deployed Failed Cancelled deleted ) ],
            Deployed             => [ 'In Progress', 'Partially Deployed', qw( Failed Cancelled deleted ) ],
            Failed               => [ qw( Cancelled deleted ) ],
            Cancelled            => [ qw( Requested Approved ) ],
            Rejected             => [ qw( Requested Approved ) ],
        },
        rights => {
            'Requested -> *' => 'Change Reviewer',
        },
        actions => [
            '* -> Requested' => {
                label  => 'Submit For Approval',
            },
        ]
    },
    __maps__ => {
        'default -> Change Management' => {
            'new'         => 'Requested',
            'resolved'    => 'Deployed',
            'open'        => 'In Progress',
            'rejected'    => 'Rejected',
            'stalled'     => 'Partially Deployed', # TODO: ???
            'deleted'     => 'deleted',
        },
        'Change Management -> default' => {
            'Requested'          => 'new',
            'Deployed'           => 'resolved',
            'Rejected'           => 'rejected',
            'deleted'            => 'deleted',
            'In Progress'        => 'open',
            'Approved'           => 'open',
            # TODO: Not sure what to do with these
            'Partially Deployed' => 'stalled', 
            'Failed'             => 'resolved',
            'Cancelled'          => 'resolved',
        },
    }
);

1;

