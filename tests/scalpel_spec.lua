local helpers = require('helpers')

describe('scalpel', function()
  local scalpel

  before_each(function()
    helpers.setup_mocks()
    package.loaded['scalpel'] = nil
    scalpel = require('scalpel')
  end)

  after_each(function()
    helpers.teardown_mocks()
  end)

  describe('setup', function()
    it('does not error', function()
      assert.has_no.errors(function()
        scalpel.setup()
      end)
    end)
  end)

  describe('substitute', function()
    describe('normal mode', function()
      it('feeds substitution command with word under cursor', function()
        helpers.set_mode('n')
        helpers.set_expand('hello')

        scalpel.substitute()

        assert.equals(1, #helpers.feedkeys_calls)
        local call = helpers.feedkeys_calls[1]
        assert.truthy(call.keys:find('hello'))
        assert.truthy(call.keys:find(':%%s/\\v'))
        assert.truthy(call.keys:find('//gc'))
      end)

      it('uses very magic regex pattern', function()
        helpers.set_mode('n')
        helpers.set_expand('myVar')

        scalpel.substitute()

        local call = helpers.feedkeys_calls[1]
        assert.truthy(call.keys:find('\\v'))
      end)

      it('includes cursor move keys to position in replacement field', function()
        helpers.set_mode('n')
        helpers.set_expand('test')

        scalpel.substitute()

        local call = helpers.feedkeys_calls[1]
        assert.truthy(call.keys:find('<Left><Left><Left>'))
      end)

      it('notifies when word is blank', function()
        helpers.set_mode('n')
        helpers.set_expand('   ')

        scalpel.substitute()

        assert.equals(0, #helpers.feedkeys_calls)
        assert.equals(1, #helpers.notifications)
        assert.truthy(helpers.notifications[1].msg:find('blank'))
      end)

      it('notifies when word is empty', function()
        helpers.set_mode('n')
        helpers.set_expand('')

        scalpel.substitute()

        assert.equals(0, #helpers.feedkeys_calls)
        assert.equals(1, #helpers.notifications)
        assert.truthy(helpers.notifications[1].msg:find('blank'))
      end)
    end)

    describe('visual mode', function()
      -- Note: get_visual_range() calls nvim_feedkeys with <Esc> first,
      -- so visual mode tests have an extra feedkeys call at index 1.

      it('feeds substitution command with selected text', function()
        helpers.set_mode('v')
        helpers.set_visual_marks({ 1, 4 }, { 1, 8 })
        helpers.set_buffer_lines({ 'the hello world line' })

        scalpel.substitute()

        assert.equals(2, #helpers.feedkeys_calls)
        local call = helpers.feedkeys_calls[2]
        assert.truthy(call.keys:find('hello'))
        assert.truthy(call.keys:find(':%%s/\\v'))
        assert.truthy(call.keys:find('//gc'))
      end)

      it('extracts correct substring from line', function()
        helpers.set_mode('v')
        helpers.set_visual_marks({ 1, 0 }, { 1, 2 })
        helpers.set_buffer_lines({ 'foo bar baz' })

        scalpel.substitute()

        local call = helpers.feedkeys_calls[2]
        assert.truthy(call.keys:find('foo'))
      end)

      it('notifies when selection spans multiple lines', function()
        helpers.set_mode('v')
        helpers.set_visual_marks({ 1, 0 }, { 3, 5 })

        scalpel.substitute()

        -- Only the <Esc> feedkeys call, no substitution
        assert.equals(1, #helpers.feedkeys_calls)
        assert.equals(1, #helpers.notifications)
        assert.truthy(helpers.notifications[1].msg:find('Cannot substitute'))
      end)

      it('notifies when selected text is blank', function()
        helpers.set_mode('v')
        helpers.set_visual_marks({ 1, 4 }, { 1, 6 })
        helpers.set_buffer_lines({ 'test   end' })

        scalpel.substitute()

        -- Only the <Esc> feedkeys call, no substitution
        assert.equals(1, #helpers.feedkeys_calls)
        assert.equals(1, #helpers.notifications)
        assert.truthy(helpers.notifications[1].msg:find('blank'))
      end)
    end)

    describe('visual line mode', function()
      it('feeds line-scoped substitution command without a word', function()
        helpers.set_mode('V')

        scalpel.substitute()

        assert.equals(1, #helpers.feedkeys_calls)
        local call = helpers.feedkeys_calls[1]
        assert.truthy(call.keys:find(':s///gc'))
        -- Should NOT contain %s (buffer-wide) or \v (very magic)
        assert.falsy(call.keys:find('%%s'))
        assert.falsy(call.keys:find('\\v'))
      end)

      it('includes cursor move keys to position in search field', function()
        helpers.set_mode('V')

        scalpel.substitute()

        local call = helpers.feedkeys_calls[1]
        assert.truthy(call.keys:find('<Left><Left><Left>'))
      end)

      it('does not trigger any notifications', function()
        helpers.set_mode('V')

        scalpel.substitute()

        assert.equals(0, #helpers.notifications)
      end)
    end)
  end)
end)
