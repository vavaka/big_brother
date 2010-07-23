#!/usr/bin/ruby

require 'lib/main'

# Don't be confused with the name of this method.
# We actually keep the current (main) thread alive while letting listener thread to do its job.
# So we have no need to set up an any infinite loop.
Thread.stop