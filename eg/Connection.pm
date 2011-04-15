package Connection;
use MooseX::StateMachine;

state 'closed';

start_state 'waiting' => (
    transitions => {
        error     => sub {},
        connected => sub {},
    },
);

state 'error' => (
    transitions => {
        closed => sub {},
    },
);

state 'connected' => (
    transitions => {
        authenticated => sub {},
    },
);

state 'in_use' => (
    transitions => {
        in_use        => sub {},
        authenticated => sub {},
    },
);

state 'authenticated' => (
    methods => {
        delete_crap => sub {},
    },
    transitions => {
        logout  => sub {},
        in_use  => sub {},
        expired => sub {},
    },
);

state 'expired' => (
    transitions => {
        logout => sub {},
    },
);

state 'logout' => (
    transitions => {
        closed => sub {},
    },
);

1;
