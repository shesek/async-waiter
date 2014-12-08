iferr = require 'iferr'

waiter = (fn, out) ->
  out = once out
  left = 1
  ctx = {}

  wait = (inner) ->
    throw new Error 'waiter is terminated' unless left
    ++left
    once iferr out, (a...) ->
      inner?.apply ctx, a
      out null, ctx unless --left

  fn.call ctx, wait, ctx

  out null, ctx unless --left

once = (fn) -> called=false; (a...) ->
  throw new Error 'already called' if called
  called = true
  fn a...

module.exports = waiter
