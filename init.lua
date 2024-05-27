local gui = require('oriole.gui')
local database = require('oriole.database')
local oriole = {

}

local actions = require('oriole.actions')

function oriole:tests()
    gui.prev_window = vim.api.nvim_get_current_win()
    print(gui.prev_window)
  gui:create_buffer()
  gui:create_main_win()
  gui:create_prompt()
  gui:create_autocmd()
 -- do below somewhere else
    actions.reload() 
   vim.keymap.set('n','k',function ()
   actions.moveCursorUp()
   end
   ,{buffer= gui.prompt_buf})
   vim.keymap.set('n','j',function ()
   actions.moveCursorDown()
   end
   ,{buffer= gui.prompt_buf})
   vim.keymap.set('n','<CR>',function ()
   actions.openBuffer()
   end
   ,{buffer= gui.prompt_buf})
   vim.keymap.set('n','d',function ()
   actions.saveAndClose()
   end
   ,{buffer= gui.prompt_buf})
end
    --print(database.buffers[1])



vim.api.nvim_create_user_command('OrioleBufferManager', function()
    oriole:tests()
end, {})

return oriole

