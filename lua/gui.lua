

local lines  = vim.o.lines
local columns = vim.o.columns

local gui = {
    buffers={},
    prompt_events={},
    win_width=(columns-columns%2)/2,
    win_height=(lines - lines%3)/3,
    main_window = 0,
    prompt_window = 0,
    prev_window = nil 
}



function gui:create_buffer()
    if(self.prompt_buf==nil or self.main_buf == nil) then
        self.prompt_buf = nil; self.main_buf =nil
        
        self.prompt_buf = vim.api.nvim_create_buf(false,false)
        self.main_buf = vim.api.nvim_create_buf(false,false)
        
        local buf_opts = vim.api.nvim_buf_set_option

        buf_opts(self.main_buf,'buftype','nofile')
        buf_opts(self.main_buf,'swapfile',false)
        
        buf_opts(self.prompt_buf,'buftype','prompt')
        buf_opts(self.prompt_buf,'swapfile',false)       
       -- vim.api.nvim_buf_attach(
       --     self.prompt_buf, false,{
       --         on_lines = function(...)
       --             table.insert(self.prompt_events,{...})
       --         end,
       --     })
       self:init_main_buffer()
        --buf_opts(self.main_buf,'modifiable',false)
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
      col = col - self.win_width/2 ,
      style = 'minimal',
      border = {'╭','─', '╮','│', '╯','─','╰','│'}  -- Use Unicode box drawing characters for the border
    }
    self.ns_id = vim.api.nvim_create_namespace("OrioleHighlights")
    self.main_window = vim.api.nvim_open_win(self.main_buf, true, opts)
    vim.api.nvim_win_set_option(self.main_window,'winhighlight','Normal:Normal')
    vim.api.nvim_win_set_option(self.main_window,'cul',true)
end

function gui:create_autocmd()
    local o_events = {"BufLeave","BufWinLeave","WinLeave","WinClosed"}
    self.augroup = vim.api.nvim_create_augroup("OrioleAutoGroup",{clear= true})
    vim.api.nvim_create_autocmd(o_events,
        {
            buffer = self.prompt_buf,
            callback= function (ev)
                self:auto_close()
            end,
           group = self.augroup 
        }
    )
    vim.api.nvim_create_autocmd(o_events,
        {
            buffer = self.main_buf,
            callback= function (ev)
                self:auto_close()
            end,
            group = self.augroup 
        }
        )
end

function gui:create_prompt()
   local height = vim.api.nvim_get_option('cmdheight')
   local width = self.win_width
   local row = self.win_height +1
   local col = -1
   local opts = {
      relative = 'win',
      win = self.main_window,
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = {'╭','─', '╮','│', '╯','─','╰','│'}  -- Use Unicode box drawing characters for the border
    }              
    self.prompt_window = vim.api.nvim_open_win(self.prompt_buf, true, opts)
    vim.api.nvim_win_set_option(self.prompt_window,'winhighlight','Normal:Normal')
end

function gui:auto_close()

    vim.api.nvim_win_close(self.main_window,false)
    vim.api.nvim_win_close(self.prompt_window,false)
    vim.api.nvim_buf_delete(self.prompt_buf,{force= true})
    vim.api.nvim_buf_delete(self.main_buf,{force= true})
    self.main_window=nil
    self.prompt_window=nil
    self.prompt_buf = nil
    self.main_buf = nil
    self:remove_autocmd()
end

function gui:remove_autocmd()
    vim.api.nvim_clear_autocmds({group = self.augroup})
end



return gui 

