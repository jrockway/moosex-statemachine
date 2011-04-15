package MooseX::StateMachine::Meta::State;
# ABSTRACT: class representing a single state
use Moose;
use true;
use namespace::autoclean;

has 'associated_class' => (
    is       => 'rw',
    isa      => 'Class',
    required => 1,
);

has 'transitions' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
