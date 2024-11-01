local actions = {}
local gui = require('oriole.gui')
local database = require('oriole.database')

function actions.motion(args)
    local cursor_pos = vim.api.nvim_win_get_cursor(args.win)
    if args.direction == "Up" then
        vim.api.nvim_win_set_cursor(args.win,{cursor_pos[1]+1,cursor_pos[2]})
    elseif args.direction == "Down" then  
        vim.api.nvim_win_set_cursor(args.win,{cursor_pos[1]-1,cursor_pos[2]})
    end
end

function actions.reload()
    database:index_buffers()
    local lines = database:gen_line_array()
    vim.api.nvim_buf_set_lines(gui.main_buf,0,-1,false,{""})
    for index,value in ipairs(lines) do 
        vim.api.nvim_buf_set_lines(gui.main_buf,index-1,index,false,{value.line})
        vim.api.nvim_buf_add_highlight(gui.main_buf,gui.ns_id,value.highlight.highlight_group,value.highlight.row,value.highlight.col,value.highlight.col+ 1)
    end
end

function actions.moveCursorUp()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    if not(cursor_pos[1] <= 1) then
        vim.api.nvim_win_set_cursor(gui.main_window,{cursor_pos[1]-1,cursor_pos[2]})
    end
end

function actions.moveCursorDown()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    if not(cursor_pos[1] >= vim.api.nvim_buf_line_count(gui.main_buf)) then
        vim.api.nvim_win_set_cursor(gui.main_window,{cursor_pos[1]+1,cursor_pos[2]})
    end
end


function actions.openBuffer()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window) 
    local bufnr = database.lines[cursor_pos[1]].bufnr
    -- Store the target buffer number
    local target_bufnr = bufnr
    -- Store the target window
    local target_window = gui.prev_window
    
    -- Schedule the buffer switch after Oriole closes
    vim.schedule(function()
        if vim.api.nvim_win_is_valid(target_window) then
            vim.api.nvim_win_set_buf(target_window, target_bufnr)
        end
    end)
    
    -- Close Oriole
    gui:close()
end

function actions.openBufferSplit()
    local cursor_pos = vim.api.nvim_win_get_cursor(gui.main_window)
    local bufnr = database.lines[cursor_pos[1]].bufnr
    -- Store the target buffer number
    local target_bufnr = bufnr
    
    gui:close()
    -- Create split and schedule buffer set
    vim.cmd('vsplit')
    local new_win = vim.api.nvim_get_current_win()
    vim.schedule(function()
        if vim.api.nvim_win_is_valid(new_win) then
            vim.api.nvim_win_set_buf(new_win, target_bufnr)
        end
    end)
    
    -- Close Oriole
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

return actions
