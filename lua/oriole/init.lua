
-- init.lua
local gui = require('oriole.gui')
local database = require('oriole.database')
local oriole = {}
local actions = require('oriole.actions')

function oriole:open()
    gui.prev_window = vim.api.nvim_get_current_win()
    gui:create_buffer()
    gui:create_main_win()
    gui:create_autocmd()
    actions.reload()
    
    -- Key mappings
    vim.keymap.set('n', 'k', actions.moveCursorUp, {buffer = gui.main_buf})
    vim.keymap.set('n', 'j', actions.moveCursorDown, {buffer = gui.main_buf})
    vim.keymap.set('n', '<CR>', actions.openBuffer, {buffer = gui.main_buf})
    vim.keymap.set('n', 's', actions.openBufferSplit, {buffer = gui.main_buf})
    vim.keymap.set('n', 'd', actions.saveAndClose, {buffer = gui.main_buf})
end

vim.api.nvim_create_user_command('OrioleBufferManager', function()
    oriole:open()
end, {})

return oriole
