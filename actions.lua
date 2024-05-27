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

return actions
