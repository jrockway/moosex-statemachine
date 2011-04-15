package MooseX::StateMachine::Meta::Class::Base;
# ABSTRACT: metaclass role for the "entry point" class
use Moose::Role;
use Moose::Util::MetaRole;
use true;
use namespace::autoclean;

use MooseX::StateMachine::Meta::Machine::Partial;
use MooseX::StateMachine::Meta::Machine;
use List::Util qw(first);

has 'partial_state_machine' => (
    is         => 'ro',
    isa        => 'MooseX::StateMachine::Meta::Machine::Partial',
    lazy_build => 1,
    handles    => {
        set_start_state      => 'start_state',
        has_start_state      => 'has_start_state',
        _build_state_machine => 'build_state_machine',
    },
);

has 'state_machine' => (
    is       => 'ro',
    isa      => 'MooseX::StateMachine::Meta::Machine',
    handles  => [qw/start_state states transitions/],
    required => 0,
    lazy     => 1,
    builder  => '_build_state_machine',
);

sub base { $_[0] }

sub _build_partial_state_machine {
    my $self = shift;
    return MooseX::StateMachine::Meta::Machine::Partial->new( base => $self );
}

sub class_for_state {
    my ($self, $want) = @_;
    return first { $want eq $_->state_name } $self->states;
}
