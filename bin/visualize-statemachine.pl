#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';

use FindBin qw($Bin);
use lib "$Bin/../lib";

use MooseX::Runnable::Run 'MooseX::StateMachine::App::GraphViz';
