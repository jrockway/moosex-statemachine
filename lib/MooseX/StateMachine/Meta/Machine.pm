package MooseX::StateMachine::Meta::Machine;
# ABSTRACT: class representing an entire state machine
use Moose;
use true;
use namespace::autoclean;

use Carp qw(cluck);
use Set::Object qw(set);

has 'base' => (
    is       => 'ro',
    isa      => 'Moose::Meta::Class',
    required => 1,
    handles  => ['name'],
);

has 'states' => (
    init_arg => 'states',
    isa      => 'ArrayRef[Moose::Meta::Class]',
    traits   => ['Array'],
    required => 1,
    handles  => {
        states => 'elements',
    },
);

has 'start_state' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'transitions' => (
    init_arg => 'transitions',
    isa      => 'ArrayRef[Str]',
    traits   => ['Array'],
    required => 1,
    handles  => { transitions => 'elements' },
);

sub BUILD {
    my $self = shift;
    my $name = $self->name;

    my $valid_states = set(map { $_->state_name } $self->states);

    my $start = $self->start_state;
    confess "The start state '$start' is not a vaild state in machine '$name'!"
        unless $valid_states->member($start);

    my $transitions = set($self->transitions, $start);
    my $invalid_transitions = $transitions - $valid_states;

    confess "There are some transitions in machine '$name' that have no states: ".
        join(', ', $invalid_transitions->members)
            if $invalid_transitions->size > 0;

    my $unused_states = $valid_states - $transitions;
    cluck "There are some unreachable states in machine '$name': ".
        join(', ', $unused_states->members)
            if $unused_states->size > 0;
}

__PACKAGE__->meta->make_immutable;
