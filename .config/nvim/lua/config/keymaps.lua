-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Godot Configuration
local config = {
  godot_path = vim.fn.expand("~/System/Godot/godot"),
  tcp_port = 6008,
}

-- Manual code action keybinding as fallback
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })

-- LSP Keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- File Operations
vim.keymap.set('n', '<leader>w', function()
  if vim.bo.buftype == "" then
    vim.cmd('w')
  end
end, { desc = 'Save file' })
vim.keymap.set('n', '<leader>wa', function()
  -- :wa tries to write all buffers, which includes terminal buffers
  -- Instead of erroring out when :wa hits the term window, we can just call it
  -- wrapped in a pcall or ignore terminal buffers manually.
  -- Pcall is easiest here since `:wa` inherently checks all buffers.
  pcall(vim.cmd, 'wa')
end, { desc = 'Save all files' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close file' })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { desc = 'Close all files' })

-- Comment toggle (Space + /)
vim.keymap.set('n', '<leader>/', function()
  vim.api.nvim_command('normal! gcc')
end, { desc = 'Toggle comment' })
vim.keymap.set('v', '<leader>/', ':norm gcc<CR>', { desc = 'Toggle comment (visual)' })

-- Godot: Run EditorScript via TCP to Godot Editor
vim.keymap.set('n', '<leader>Ge', function()
  local filepath = vim.fn.expand('%:p')
  
  if filepath == '' then
    vim.notify('No file to execute', vim.log.levels.ERROR)
    return
  end
  
  -- Check if this is actually an EditorScript
  local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
  local content = table.concat(lines, '\n')
  
  if not content:match('extends%s+EditorScript') then
    vim.notify('This is not an EditorScript. Use <leader>Gs instead', vim.log.levels.WARN)
    return
  end
  
  local tcp = vim.uv.new_tcp()
  
  tcp:connect('127.0.0.1', config.tcp_port, function(err)
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
          
          -- Check if response is an error
          if response:match("^Error:") then
            vim.notify(response, vim.log.levels.ERROR)
          else
            -- Create scratch buffer and write response (deferred to safe context)
            vim.schedule(function()
              local buf = vim.api.nvim_create_buf(false, true)
              vim.bo[buf].buftype = 'nofile'
              vim.bo[buf].filetype = 'godot-output'
              vim.bo[buf].bufhidden = 'wipe'
              
              -- Open buffer in horizontal split
              vim.api.nvim_command('split | buffer ' .. buf)
              
              local lines = vim.split(response, '\n', { plain = true })
              
              -- Write response to scratch buffer
              vim.bo[buf].modifiable = true
              vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
              vim.bo[buf].modifiable = false
              -- Move cursor to top
              vim.api.nvim_buf_call(buf, function()
                vim.api.nvim_command('normal! gg')
              end)
            end)
          end
          
          -- Close TCP connection
          tcp:close()
        end
      end)
    end)
  end)
end, { desc = 'Run EditorScript in Godot via TCP' })

-- Godot: Run SceneTree via headless Godot terminal
vim.keymap.set('n', '<leader>Gs', function()
  local filepath = vim.fn.expand('%:p')
  
  if filepath == '' then
    vim.notify('No file to execute', vim.log.levels.ERROR)
    return
  end
  
  -- Read first lines to detect script type
  local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
  local content = table.concat(lines, '\n')
  
  if content:match('extends%s+EditorScript') then
    vim.notify('This is an EditorScript. Use <leader>Ge instead', vim.log.levels.WARN)
    return
  end
  
  vim.cmd('write')
  
  -- Create split window with new empty buffer
  vim.cmd('botright split | enew')
  local buf = vim.api.nvim_get_current_buf()
  
  -- Run Godot headless in terminal
  vim.fn.termopen(config.godot_path .. ' --headless -s "' .. filepath .. '"', {
    cwd = vim.fn.expand('%:p:h'),
  })
  
  -- Hide from bufferline/tabs
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = 'wipe'
end, { desc = 'Run GDScript as SceneTree (headless)' })

-- C/C++ Shortcuts
vim.keymap.set('n', '<leader>Cc', function()
  local dir = vim.fn.expand('%:p:h')
  local output = vim.fn.expand('%:p:r')
  local cmd = string.format('cd "%s" && g++ -Wall -Wextra -std=c++20 $(find . -name "*.cpp") -o "%s"', dir, output)
  
  vim.cmd('split | terminal ' .. cmd)
end, { desc = 'Compile C++ file' })

vim.keymap.set('n', '<leader>Cr', function()
  local output = vim.fn.expand('%:p:r')
  if vim.fn.executable(output) == 1 then
    vim.cmd('split | terminal "' .. output .. '"')
  else
    vim.notify('Executable not found. Compile first with <leader>Cc', vim.log.levels.ERROR)
  end
end, { desc = 'Run C++ executable' })

vim.keymap.set('n', '<leader>Cb', function()
  local dir = vim.fn.expand('%:p:h')
  local output = vim.fn.expand('%:p:r')
  -- Compile all .cpp files in the directory and immediate subdirectories
  local cmd = string.format('cd "%s" && g++ -Wall -Wextra -std=c++20 $(find . -name "*.cpp") -o "%s" && "%s"', dir, output, output)
  
  vim.cmd('split | terminal ' .. cmd)
end, { desc = 'Build and Run C++' })

-- Auto-close terminal buffers when the process exits successfully
vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    -- v:event.status returns the exit code of the external command
    if vim.v.event.status == 0 then
      -- Automatically delete the terminal buffer but require confirmation for non-zero statuses 
      -- Wait a tiny bit (Wait for user to press Space/Enter before closing the split if you want, 
      -- or just safely wipe it if horizontal split is manually closed)
      -- The optimal behavior for this user's request is to wipe the buffer from the background
      -- when the user manually closes the split window with <space>wd, so we'll set bufhidden to wipe
      local buf = vim.api.nvim_get_current_buf()
      -- If they want it immediately closed instead of waiting for a keypress, we can quit it.
      -- But since they want it to show stdout and just not persist when they close the window:
      vim.bo[buf].bufhidden = 'wipe'
    end
  end,
  desc = "Wipe terminal buffers after successful exit",
})
