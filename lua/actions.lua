local actions = {

}
local gui = require('oriole.gui')
local database = require('oriole.database')
function actions.motion(args)
    local cursor_pos = vim.api.nvim_win_get_cursor(args.win)
    --print(cursor_pos[2],cursor_pos[1])
    if args.direction == "Up" then
        vim.api.nvim_win_set_cursor(args.win,{cursor_pos[1]+1,cursor_pos[2]})
    elseif args.direction == "Down" then  
        vim.api.nvim_win_set_cursor(args.win,{cursor_pos[1]-1,cursor_pos[2]})
    end
end


function actions.reload()
    database:index_buffers()
    local lines =  database:gen_line_array()
    vim.api.nvim_buf_set_lines(gui.main_buf,0,-1,false,{""})
    for index,value in ipairs(lines) do 
        vim.api.nvim_buf_set_lines(gui.main_buf,index-1,index,false,{value.line})  -- index can be got here from row value of highlight
        vim.api.nvim_buf_add_highlight(gui.main_buf,gui.ns_id,value.highlight.highlight_group,value.highlight.row,value.highlight.col,value.highlight.col+ 1)
    end
     
end

function actions.moveCursorUp()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    if not( cursor_pos[1] <= 1)then
        vim.api.nvim_win_set_cursor(gui.main_window,{cursor_pos[1]-1,cursor_pos[2]})
    end
end

function actions.moveCursorDown()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    if not(cursor_pos[1] >= vim.api.nvim_buf_line_count(gui.main_buf))  then
        vim.api.nvim_win_set_cursor(gui.main_window,{cursor_pos[1]+1,cursor_pos[2]})
    end
end

function actions.openBuffer()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    print(database.lines[cursor_pos[1]].bufnr)  
    vim.api.nvim_win_set_buf(gui.prev_window, database.lines[cursor_pos[1]].bufnr)
end

function actions.saveAndClose()

    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    local bufnr = database.lines[cursor_pos[1]].bufnr
    vim.api.nvim_buf_call(bufnr,function()
        vim.api.nvim_command("w")
    end)
    vim.api.nvim_buf_delete(bufnr,{})
    actions.reload()
    if cursor_pos[1] >= #database.buffers then 
        vim.api.nvim_win_set_cursor(gui.main_window,{cursor_pos[1] - 1,cursor_pos[2]})
    else
        vim.api.nvim_win_set_cursor(gui.main_window,cursor_pos)
    end
end

function actions.openVSplit()

    local prev_window_bufnr = vim.api.nvim_win_get_buf(gui.prev_window)
    vim.api.nvim_buf_call(prev_window_bufnr,function ()
        vim.api.nvim_commmand("vsplit")
    end) 
    
end

return actions
