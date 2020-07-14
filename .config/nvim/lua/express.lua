local helper = require 'el.helper'
local el_segments = {}

-- Statusline options can be of several different types.
-- Option 1, just a string.

-- table.insert(el_segments, '[literal_string]')

-- Keep in mind, these can be the builtin strings,
-- which are found in |:help statusline|
-- table.insert(el_segments, '%f')

-- expresss_line provides a helpful wrapper for these.
-- You can check out el.builtin
local builtin = require('el.builtin')
table.insert(el_segments, builtin.file)

-- Option 2, just a function that returns a string.
-- local extensions = require('el.extensions')
-- table.insert(el_segments, extensions.mode) -- mode returns the current mode.

-- Option 4, you can return a coroutine.
--  In lua, you can cooperatively multi-thread.
--  You can use `coroutine.yield()` to yield execution to another coroutine.
--
-- For example, in luvjob.nvim, there is `co_wait` which is a coroutine version of waiting for a job to complete. So you can start multiple jobs at once and wait for them to all be done.
-- table.insert(el_segments, extensions.git_changes)

-- And then when you're all done, just call
require('el').set_statusline_generator(el_segments)
