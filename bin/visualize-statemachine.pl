#!/usr/bin/env perl

# PODNAME: visualize-statemachine.pl
# ABSTRACT: script to invoke L<MooseX::StateMachine::App::GraphViz>

use strict;
use warnings;
use feature ':5.10';

use FindBin qw($Bin);
use lib "$Bin/../lib";

use MooseX::Runnable::Run 'MooseX::StateMachine::App::GraphViz';
