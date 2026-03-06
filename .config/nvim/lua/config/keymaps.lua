-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Manual code action keybinding as fallback
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })

-- LSP Keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- File Operations
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>wa', ':wa<CR>', { desc = 'Save all files' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close file' })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { desc = 'Close all files' })

-- Comment toggle (Space + /)
vim.keymap.set('n', '<leader>/', function()
  vim.api.nvim_command('normal! gcc')
end, { desc = 'Toggle comment' })
vim.keymap.set('v', '<leader>/', ':norm gcc<CR>', { desc = 'Toggle comment (visual)' })

-- Run current GDScript EditorScript via TCP to Godot Editor
vim.keymap.set('n', '<leader>Xx', function()
  local filepath = vim.fn.expand('%:p')
  
  if filepath == '' then
    vim.notify('No file to execute', vim.log.levels.ERROR)
    return
  end
  
  -- Create scratch buffer for output
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].filetype = 'godot-output'
  vim.bo[buf].bufhidden = 'wipe'
  
  -- Open buffer in horizontal split
  vim.api.nvim_command('split | buffer ' .. buf)
  
  local tcp = vim.uv.new_tcp()
  
  tcp:connect('127.0.0.1', 6008, function(err)
    if err then
      vim.notify('Failed to connect to Godot: ' .. err, vim.log.levels.ERROR)
      return
    end
    
    tcp:write(filepath .. '\n', function(write_err)
      if write_err then
        vim.notify('Failed to send path: ' .. write_err, vim.log.levels.ERROR)
        tcp:close()
        return
      end
      
      -- Wait for response from Godot
      local chunks = {}
      tcp:read_start(function(read_err, chunk)
        if read_err then
          vim.notify('Read error: ' .. read_err, vim.log.levels.ERROR)
          tcp:read_stop()
          tcp:close()
          return
        end
        
        if chunk then
          table.insert(chunks, chunk)
        else
          tcp:read_stop()
          local response = table.concat(chunks)
          local lines = vim.split(response, '\n', { plain = true })
          
          -- Write response to scratch buffer (deferred to safe context)
          vim.schedule(function()
            vim.bo[buf].modifiable = true
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
            vim.bo[buf].modifiable = false
            -- Move cursor to top
            vim.api.nvim_buf_call(buf, function()
              vim.api.nvim_command('normal! gg')
            end)
          end)
          
          -- Close TCP connection
          tcp:close()
        end
      end)
    end)
  end)
end, { desc = 'Run EditorScript in Godot via TCP' })

