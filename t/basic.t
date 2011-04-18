use strict;
use warnings;
use Test::More;
use Test::Exception;

lives_ok {
    package Connection;
    use MooseX::StateMachine;

    has 'logger' => (
        is      => 'ro',
        isa     => 'ArrayRef[Str]',
        traits  => ['Array'],
        default => sub { [] },
        handles => { log => 'push' },
    );

    has 'username' => (
        is        => 'rw',
        isa       => 'Str',
        predicate => 'is_logged_in',
        clearer   => 'clear_username',
    );

    start_state 'bound' => (
        transitions => {
            error     => sub { $_[0]->log("error after bind: $_[1]") },
            connected => sub { $_[0]->log("client $_[1] connected") },
        },
    );

    state 'error' => ();

    state 'connected' => (
        transitions => {
            error         => sub { $_[0]->log("error after connection: $_[1]") },
            authenticated => sub {
                $_[0]->log("client logged in as: $_[1]");
                $_[0]->username($_[1]);
            },
        },
    );

    state 'authenticated' => (
        methods => {
            delete_crap => sub { $_[0]->log($_[0]->username. " deleted some crap") },
        },
        transitions => {
            logout => sub { $_[0]->log("client logged out"); $_[0]->clear_username },
        },
        on_leave => sub {
            $_[0]->log("deleting session data");
        },
    );

    state 'logout' => (
        on_enter => sub {
            $_[0]->log("removing user from user list");
        },
    );
}q 'created state machine ok';

my $machine = Connection->new;
isa_ok $machine, 'Connection';
$machine->start;
isa_ok $machine, 'Connection::Bound';
ok $machine->is_bound, 'is_bound';

$machine->connected('localhost:1234');
isa_ok $machine, 'Connection::Connected';
ok $machine->is_connected, 'is_connected';

$machine->authenticated('foo');
isa_ok $machine, 'Connection::Authenticated';
ok $machine->is_authenticated, 'is_authenticated';
ok $machine->is_logged_in, 'is_logged_in';
is $machine->username, 'foo', 'username stuck';

lives_ok {
    $machine->delete_crap;
} 'can delete crap';

$machine->logout;
isa_ok $machine, 'Connection::Logout';
ok $machine->is_logout, 'is_logout';

dies_ok {
    $machine->delete_crap;
} 'can no longer delete crap (or anything)';

is $machine->logger->[-2], 'deleting session data', 'on_leave ran';
is $machine->logger->[-1], 'removing user from user list', 'on_enter ran';

done_testing;
