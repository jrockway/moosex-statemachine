package MooseX::StateMachine::Meta::Class::State;
# ABSTRACT: metaclass role for each state class
use Moose::Role;
use true;
use namespace::autoclean;

has 'state_name' => (
    is  => 'rw',
    isa => 'Str',
);

has 'base' => (
    is      => 'rw',
    does    => 'MooseX::StateMachine::Meta::Class::Base',
    handles => ['class_for_state'],
);

has 'transitions' => (
    init_arg => 'transitions',
    writer   => 'set_transitions',
    isa      => 'ArrayRef[Str]',
    traits   => ['Array'],
    handles  => { transitions => 'elements' },
);

around make_immutable => sub {
    my ($orig, $self, @args) = @_;
    $self->$orig(@args);
    return;
};
