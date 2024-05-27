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
    database:index_buffers()
    local lines =  database:gen_line_array()
    for index,value in ipairs(lines) do 
        vim.api.nvim_buf_set_lines(gui.main_buf,index-1,index,false,{value.line})  -- index can be got here from row value of highlight
        vim.api.nvim_buf_add_highlight(gui.main_buf,gui.ns_id,value.highlight.highlight_group,value.highlight.row,value.highlight.col,value.highlight.col+ 1)
    end
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
end
    --print(database.buffers[1])



vim.api.nvim_create_user_command('OrioleBufferManager', function()
    oriole:tests()
end, {})

return oriole

