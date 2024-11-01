-- gui.lua
local lines = vim.o.lines
local columns = vim.o.columns

local gui = {
    buffers = {},
    win_width = (columns-columns%2)/2,
    win_height = (lines - lines%3)/3,
    main_window = 0,
    main_buf = nil,
    prev_window = nil 
}

function gui:create_buffer()
    if not self.main_buf then
        self.main_buf = vim.api.nvim_create_buf(false, false)
        local buf_opts = vim.api.nvim_buf_set_option
        buf_opts(self.main_buf, 'buftype', 'nofile')
        buf_opts(self.main_buf, 'swapfile', false)
        self:init_main_buffer()
    end
end

function gui:init_main_buffer()
end

function gui:create_main_win()
    local row = vim.o.lines/2
    local col = vim.o.columns/2
    local opts = {
        relative = 'editor',
        width = self.win_width,
        height = self.win_height,
        row = row - self.win_height/2 - 4,
        col = col - self.win_width/2,
        style = 'minimal',
        border = {'╭','─', '╮','│', '╯','─','╰','│'}
    }
    self.ns_id = vim.api.nvim_create_namespace("OrioleHighlights")
    self.main_window = vim.api.nvim_open_win(self.main_buf, true, opts)
    vim.api.nvim_win_set_option(self.main_window, 'winhighlight', 'Normal:Normal')
    vim.api.nvim_win_set_option(self.main_window, 'cul', true)
end

function gui:create_autocmd()
    local o_events = {"BufLeave", "BufWinLeave", "WinLeave", "WinClosed"}
    self.augroup = vim.api.nvim_create_augroup("OrioleAutoGroup", {clear = true})
    vim.api.nvim_create_autocmd(o_events, {
        buffer = self.main_buf,
        callback = function(ev)
            self:close()
        end,
        group = self.augroup
    })
end

function gui:close()
    -- Remove autocmds first
    self:remove_autocmd()
    
    -- Close window if it exists
    if self.main_window and vim.api.nvim_win_is_valid(self.main_window) then
        vim.api.nvim_win_close(self.main_window, true)
    end
    
    -- Delete buffer if it exists and is valid
    if type(self.main_buf) == "number" and vim.api.nvim_buf_is_valid(self.main_buf) then
        vim.api.nvim_buf_delete(self.main_buf, { force = true })
    end
    
    -- Reset state
    self.main_window = nil
    self.main_buf = nil
end

function gui:remove_autocmd()
    if self.augroup then
        vim.api.nvim_clear_autocmds({group = self.augroup})
    end
end

return gui
