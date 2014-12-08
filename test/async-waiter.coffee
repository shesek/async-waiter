iferr = require 'iferr'
waiter = require '../async-waiter.coffee'
{ ok, equal: eq } = require 'assert'

describe 'async-waiter', ->
  it 'calls the provided function with the wait function', (done) ->
    waiter (wait) ->
      ok typeof wait is 'function'
    , done

  it 'waits until multiple callbacks are called', (done) ->
    called = false
    waiter (wait) ->
      done1 = wait()
      done2 = wait()
      done3 = wait()

      process.nextTick ->
        done1()
        ok not called
      process.nextTick ->
        done3()
        ok not called
        done2()
    , iferr done, ->
      called = true
      done null

  it 'passes errors immediately to the outer callback', (done) ->
    waiter (wait) ->
      done1 = wait()
      done2 = wait()
      done3 = wait()
      
      done1 null
      done2 'foobar'
      done3 null
    , (err) ->
      eq err, 'foobar'
      done null

  it 'can wrap an existing callback and pass arguments', (done) ->
    wrapped_called = null
    waiter (wait) ->
      done1 = wait (a, b) -> wrapped_called = a+b
      done2 = wait -> ++wrapped_called

      done1 null, 2, 3
      done2 null
    , iferr done, ->
      eq wrapped_called, 6
      done null

  it 'provides a context object to store data on', (done) ->
    waiter (wait) ->
      @foo = 'foo'
      done1 = wait (x) -> @bar = x
      done1 null, 'bar'
    , iferr done, (ctx) ->
      eq ctx.foo, 'foo'
      eq ctx.bar, 'bar'
      done null
