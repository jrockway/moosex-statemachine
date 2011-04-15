package MooseX::StateMachine::Role::Base;
# ABSTRACT: role consumed by a class that is a state machine base
use Moose::Role;
use true;
use namespace::autoclean;

sub start {
    my $self = shift;
    confess 'state machine already started'
        unless $self->meta eq $self->meta->base;

    my $class = $self->meta->class_for_state($self->meta->start_state);
    $class->rebless_instance($self);
    return $self;
}
