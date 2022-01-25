Set(%Lifecycles,
    'Change Management' => {
        initial         => [ qw( requested ) ], # loc_qw
        active          => [ 'approved', 'in progress', 'partially deployed' ], # loc_qw
        inactive        => [ qw( deployed failed cancelled rejected deleted ) ], # loc_qw
        defaults => {
            on_create            => 'requested',
            approved             => 'approved',
            denied               => 'rejected',
        },
        transitions => {
            # TODO: ease these, handle more with actions.
            # The following transition is required for ticket creation
            ''                   => [ qw( requested ) ],
            requested            => [ qw( approved cancelled rejected deleted ) ],
            approved             => [ 'in progress', qw( cancelled rejected deleted ) ],
            'in progress'        => [ 'partially deployed', qw( deployed failed cancelled deleted ) ],
            'partially deployed' => [ qw( deployed failed cancelled deleted ) ],
            deployed             => [ 'in progress', 'partially deployed', qw( failed cancelled deleted ) ],
            failed               => [ qw( cancelled deleted ) ],
            cancelled            => [ qw( requested approved ) ],
            rejected             => [ qw( requested approved ) ],
        },
        rights => {
            'requested -> *' => 'Change Reviewer',
        },
        actions => [
            #'* -> Requested' => {
                #label  => 'Submit For Approval',
            #},
            'requested -> approved' => {
                label  => 'Submit For Approval',
            },
        ]
    },
    __maps__ => {
        'default -> Change Management' => {
            'new'         => 'requested',
            'resolved'    => 'deployed',
            'open'        => 'in progress',
            'rejected'    => 'rejected',
            'stalled'     => 'partially deployed', # TODO: ???
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

