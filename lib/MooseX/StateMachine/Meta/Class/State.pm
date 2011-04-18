package MooseX::StateMachine::Meta::Class::State;
# ABSTRACT: metaclass role for each state class
use Moose::Role;
use true;
use namespace::autoclean;

# XXX: everything is RW because i don't know how to set these at
# Moose::Util::MetaRole application time

has 'state_name' => (
    is  => 'rw',
    isa => 'Str',
);

has 'base' => (
    is      => 'rw',
    does    => 'MooseX::StateMachine::Meta::Class::Base',
    handles => ['class_for_state'],
);

has 'on_enter' => (
    is        => 'rw',
    isa       => 'CodeRef',
    required  => 0,
    predicate => 'has_on_enter',
);

has 'on_leave' => (
    is        => 'rw',
    isa       => 'CodeRef',
    required  => 0,
    predicate => 'has_on_leave',
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

sub run_on_enter {
    my ($meta, $self, @args) = @_;
    $meta->on_enter->($self, @args) if $meta->has_on_enter;
}

sub run_on_leave {
    my ($meta, $self, @args) = @_;
    $meta->on_leave->($self, @args) if $meta->has_on_leave;
}
