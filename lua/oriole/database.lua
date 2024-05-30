local database = {
    buffers={}
}


function database:index_buffers()
    local buffers = vim.api.nvim_list_bufs()
    self.buffers={}
    for _,value in pairs(buffers) do
        if vim.api.nvim_buf_get_option(value,"buflisted") then
            local bufName = vim.api.nvim_buf_get_name(value)
            local fileType = vim.api.nvim_buf_get_option(value,"filetype")
            table.insert(self.buffers, {name=bufName,bufnr=value,filetype = fileType})
        end
    end
end

function database:gen_line_array()
     database.lines  =  {}
    local count =1
    local h_col = 1
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

  if has_devicons then
    if not devicons.has_loaded() then
      devicons.setup()
    end
end

    for index,value in ipairs(self.buffers) do
        local icon, icon_highlight= devicons.get_icon(value.name,value.filetype,{default = true}) 
        local line = string.format(" %s %s", icon, value.name) 
        table.insert(database.lines,count,{
            line=line,
            bufnr=value.bufnr,
            highlight = {
                row=index - 1,
                col=h_col,
                highlight_group = icon_highlight
            }
    })
        count = count +1
    end
    return database.lines
end
return database
