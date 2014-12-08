// Generated by CoffeeScript 1.8.0
(function() {
  var iferr, once, waiter,
    __slice = [].slice;

  iferr = require('iferr');

  waiter = function(fn, out) {
    var ctx, left, wait;
    out = once(out);
    left = 1;
    ctx = {};
    wait = function(inner) {
      if (!left) {
        throw new Error('waiter is terminated');
      }
      ++left;
      return once(iferr(out, function() {
        var a;
        a = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (inner != null) {
          inner.apply(ctx, a);
        }
        if (!--left) {
          return out(null, ctx);
        }
      }));
    };
    fn.call(ctx, wait, ctx);
    if (!--left) {
      return out(null, ctx);
    }
  };

  once = function(fn) {
    var called;
    called = false;
    return function() {
      var a;
      a = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (called) {
        throw new Error('already called');
      }
      called = true;
      return fn.apply(null, a);
    };
  };

  module.exports = waiter;

}).call(this);
