# async-waiter

Higher-level functions to simplify waiting for multiple concurrent async
operations to finish.

### Install

    npm install --save async-waiter

### Example

```coffee

waiter = require 'waiter'

# Wait for `doFoo()` and `doBar()` to finish, then call `cb`
doFooAndBar = (cb) ->
  waiter (wait) ->
    doFoo wait()
    doBar wait()
  , cb

# Wait for all update() operations to finish
updateUsers = (user_ids, data, cb) ->
  waiter (wait) ->
    user_ids.forEach (user_id) ->
      User.update user_id, data, wait()
  , cb

# The wait() function can delegate to a provided callback,
# and the `this` context can be used to pass data to the callback
loadUserWithFriends = (user_id, cb) ->
  waiter (wait) ->
    User.loadUser user_id, wait (user) -> @data = user.data
    User.loadFriends user_id, wait (@friends) ->
  , (err, ctx) ->
    if err? then cb err
    else cb null, ctx.data, ctx.friends

````

### License
MIT
