package MooseX::StateMachine;
# ABSTRACT: build state machines with Moose classes representing each state
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use true;
use namespace::autoclean;

no feature 'state'; # so that nobody gets confused

use Carp qw(cluck);

Moose::Exporter->setup_import_methods(
    also      => 'Moose',
    with_meta => [qw/start_state state/],
);

sub init_meta {
    my ($class, %args) = @_;

    Moose->init_meta(%args);

    Moose::Util::MetaRole::apply_metaroles(
        for             => $args{for_class},
        class_metaroles => {
            class => ['MooseX::StateMachine::Meta::Class::Base'],
        },
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $args{for_class},
        roles => ['MooseX::StateMachine::Role::Base'],
    );

    return $args{for_class}->meta;
}

sub start_state($;@) {
    my ($meta, $name, %params) = @_;
    cluck 'overwriting start state!' if $meta->has_start_state;
    $meta->set_start_state($name);
    return &state($meta, $name, %params);
}

sub state($;@) {
    my ($meta, $name, %params) = @_;

    $meta->partial_state_machine->add_state_definition($name, \%params);

    for my $t (keys %{ $params{transitions} || {} }) {
        $meta->partial_state_machine->add_transition( $t );
    }
}
