local cron = require 'cron' 

context( 'cron', function()

  local counter = 0
  local function count(amount)
    amount = amount or 1
    counter = counter + amount
  end

  before(function()
    counter = 0
    cron.reset()
  end)

  context('update', function()
    test( 'Should throw an error if dt is not a positive number', function()
      assert_error(function() cron.update() end)
      assert_error(function() cron.update(-1) end)
      assert_not_error(function() cron.update(1) end)
    end)
  end)

  context('reset', function()
    test('Should cancel all actions', function()
      cron.after(1, count)
      cron.after(2, count)
      cron.update(1)
      assert_equal(counter, 1)
      cron.reset()
      cron.update(1)
      assert_equal(counter, 1)
    end)
  end)

  context( 'after', function()
    test( 'Should throw error if time is not a positive number, or f is not function', function()
      assert_error(function() cron.after('error', count) end)
      assert_error(function() cron.after(2, 'error') end)
      assert_error(function() cron.after(-2, count) end)
      assert_not_error(function() cron.after(2, count) end)
    end)
    
    test( 'Should execute timed actions are executed only once, at the right time', function()
      cron.after(2, count)
      cron.after(4, count)
      cron.update(1)
      assert_equal(counter, 0)
      cron.update(1)
      assert_equal(counter, 1)
      cron.update(1)
      assert_equal(counter, 1)
      cron.update(1)
      assert_equal(counter, 2)
    end)

    test( 'Should pass on parameters to the function, if specified', function()
      cron.after(1, count, 2)
      cron.update(1)
      assert_equal(counter, 2)
    end)
  end)



end)
