package MooseX::StateMachine::App::GraphViz;
# ABSTRACT: dump a MX::StateMachine to a pretty graph
use Moose;
use true;
use namespace::autoclean;

use String::TT qw(tt strip);
use File::Slurp qw(write_file);
use MooseX::Types::Path::Class qw(File);

with 'MooseX::Runnable', 'MooseX::Getopt::Dashes';

has 'class' => (
    is            => 'ro',
    isa           => 'Str',
    required      => 1,
    documentation => 'the class to inspect',
);

has 'name' => (
    is            => 'ro',
    isa           => 'Str',
    lazy          => 1,
    default       => sub { my $_ = $_[0]->class; s/::/_/g; lc },
    documentation => 'name of the graph; defaults to class name with s/::/_/g',
);

has 'output_file' => (
    is            => 'ro',
    isa           => File,
    coerce        => 1,
    lazy          => 1,
    default       => sub { -t *STDOUT ? $_[0]->name . '.gv' : '-' },
    documentation => 'the file to write the graph data to',
);

sub BUILD {
    my $self = shift;
    Class::MOP::load_class($self->class);
}

sub _build_output_file {
    my $self = shift;
    my $name = $self->name;
    return "$name.gv";
}

sub build_dot {
    my $self = shift;
    my $machine = $self->class->meta->state_machine;

    return tt strip qq{
        digraph [% self.name %] {
            rankdir=LR;
            node [shape = box];
            [% machine.start_state %];
            [%- FOREACH state IN machine.states %]
            [%- FOREACH transition IN state.transitions %]
            [% state.state_name %] -> [% transition %];
            [%- END %]
            [%- END %]
        }
    };
}

sub run {
    my $self = shift;

    my $dot = $self->build_dot;

    if($self->output_file eq '-'){
        print $dot;
        return 0;
    }

    write_file($self->output_file->stringify, $dot);
    return 0;
}

__PACKAGE__->meta->make_immutable;
