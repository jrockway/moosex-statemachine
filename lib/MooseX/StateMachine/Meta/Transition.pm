package MooseX::StateMachine::Meta::Transition;
# ABSTRACT: class representing a state transition
use Moose;
use true;
use namespace::autoclean;

has [qw/previous_state next_state/] => (
    is       => 'ro',
    isa      => 'Class',
    required => 1,
);

for (qw/before_transition after_transition/) {
    has $_ => (
        is        => 'ro',
        isa       => 'CodeRef',
        predicate => "has_$_",
    );
}

__PACKAGE__->meta->make_immutable;
