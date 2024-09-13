-- Set highlight on search, but clear on pressing <Esc> in normal mode
-- vim.opt.hlsearch = true

-- required in which-key plugin spec in plugins/ui.lua as `require 'config.keymap'`
local wk = require 'which-key'

P = vim.print

vim.g['quarto_is_r_mode'] = nil
vim.g['reticulate_running'] = false

local nmap = function(key, effect)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true })
end

local vmap = function(key, effect)
  vim.keymap.set('v', key, effect, { silent = true, noremap = true })
end

local imap = function(key, effect)
  vim.keymap.set('i', key, effect, { silent = true, noremap = true })
end

local cmap = function(key, effect)
  vim.keymap.set('c', key, effect, { silent = true, noremap = true })
end

-- Move between windows using <ctrl> direction
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')

-- Resize window using <shift> arrow keys
nmap('<S-Up>', '<cmd>resize +2<CR>')
nmap('<S-Down>', '<cmd>resize -2<CR>')
nmap('<S-Left>', '<cmd>vertical resize -2<CR>')
nmap('<S-Right>', '<cmd>vertical resize +2<CR>')

nmap('Q', '<Nop>')

-- move in command line
cmap('<C-a>', '<Home>')

-- exit insert mode with jk
imap('jk', '<esc>')

-- exit terminal mode with jk
vim.keymap.set('t', 'jk', '<C-\\><C-n>')

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
--- TODO: incorpoarate this into quarto-nvim plugin
--- such that QuartoRun functions get the same capabilities
--- TODO: figure out bracketed paste for reticulate python repl.
local function send_cell()
  if vim.b['quarto_is_r_mode'] == nil then
    vim.fn['slime#send_cell']()
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.fn['slime#send_cell']()
  end
end

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
local slime_send_region_cmd = ':<C-u>call slime#send_op(visualmode(), 1)<CR>'
slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)
local function send_region()
  -- if filetyps is not quarto, just send_region
  if vim.bo.filetype ~= 'quarto' or vim.b['quarto_is_r_mode'] == nil then
    vim.cmd('normal' .. slime_send_region_cmd)
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.cmd('normal' .. slime_send_region_cmd)
  end
end

-- keep selection after indent/dedent
vmap('>', '>gv')
vmap('<', '<gv')

-- center after search and jumps
nmap('n', 'nzz')
nmap('<c-d>', '<c-d>zz')
nmap('<c-u>', '<c-u>zz')

-- move between splits and tabs
nmap('<c-h>', '<c-w>h')
nmap('<c-l>', '<c-w>l')
nmap('<c-j>', '<c-w>j')
nmap('<c-k>', '<c-w>k')

-- Move between tabs, note mini.tabline uses bnext and bprev
-- nmap('H', '<cmd>tabprevious<cr>')
-- nmap('L', '<cmd>tabnext<cr>')
nmap('H', '<cmd>bprev<cr>')
nmap('L', '<cmd>bnext<cr>')

local function toggle_light_dark_theme()
  if vim.o.background == 'light' then
    vim.o.background = 'dark'
  else
    vim.o.background = 'light'
  end
end

local is_code_chunk = function()
  local current, _ = require('otter.keeper').get_current_language_context()
  if current then
    return true
  else
    return false
  end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if is_code_chunk() then
    keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
  else
    keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

local insert_r_chunk = function()
  insert_code_chunk 'r'
end

local insert_py_chunk = function()
  insert_code_chunk 'python'
end

local insert_bash_chunk = function()
  insert_code_chunk 'bash'
end

-- normal mode
wk.add({
  { '<c-LeftMouse>', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'go to definition' },
  { '<c-q>', '<cmd>q<cr>', desc = 'close buffer' },
  { '<cm-i>', insert_py_chunk, desc = 'python code chunk' },
  { '<esc>', '<cmd>noh<cr>', desc = 'remove search highlight' },
  { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
  { '[q', ':silent cprev<cr>', desc = '[q]uickfix prev' },
  { ']q', ':silent cnext<cr>', desc = '[q]uickfix next' },
  { 'gN', 'Nzzzv', desc = 'center search' },
  { 'gf', ':e <cfile><CR>', desc = 'edit file' },
  { 'gl', '<c-]>', desc = 'open help link' },
  { 'n', 'nzzzv', desc = 'center search' },
  { 'z?', ':setlocal spell!<cr>', desc = 'toggle [z]pellcheck' },
  { 'zl', ':Telescope spell_suggest<cr>', desc = '[l]ist spelling suggestions' },
  { '<c-s>', ':Telescope session-lens<cr>', desc = 'session [s]earch' },
}, { mode = 'n', silent = true })

-- visual mode
wk.add {
  mode = { 'v' },
  { '.', ':norm .<cr>', desc = 'repat last normal mode command' },
  { '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z", desc = 'move line down' },
  { '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z", desc = 'move line up' },
  -- { '<cr>', send_region, desc = 'run code region' },
  {
    '<cr>',
    function()
      if vim.bo.filetype == 'qf' or vim.bo.filetype == 'quickfix' then
        vim.cmd 'cnext'
      else
        send_region()
      end
    end,
    desc = 'run code region or jump to Quickfix',
  },
  -- { "q", ":norm @q<cr>", desc = "repat q macro" },
}

-- visual with <leader>
wk.add({
  { '<leader>d', '"_d', desc = 'delete without overwriting reg', mode = 'v' },
  { '<leader>p', '"_dP', desc = 'replace without overwriting reg', mode = 'v' },
}, { mode = 'v', prefix = '<leader>' })

-- insert mode
wk.add({
  mode = { 'i' },
  { '<c-x><c-x>', '<c-x><c-o>', desc = 'omnifunc completion' },
  { '<cm-i>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-->', ' <- ', desc = 'assign' },
  { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
  { '<m-m>', ' |>', desc = 'pipe' },
}, { mode = 'i' })

local function new_terminal(lang)
  vim.cmd('vsplit term://' .. lang)
end

local function new_terminal_python()
  new_terminal 'python'
  vim.cmd 'sleep 100m'
  vim.cmd 'normal! G' -- move to end of terminal
end

local function new_terminal_r()
  new_terminal 'R --no-save'
  vim.cmd 'sleep 100m'
  vim.cmd 'normal! G' -- move to end of terminal
end

local function new_terminal_ipython()
  new_terminal 'ipython --no-confirm-exit'
  vim.cmd 'sleep 100m'
  vim.cmd 'normal! G' -- move to end of terminal
end

local function new_terminal_shell()
  new_terminal '$SHELL'
  vim.cmd 'sleep 100m'
  vim.cmd 'normal! G' -- move to end of terminal
end

local function goto_next_code_chunk()
  local pattern = '^```%{%w+%}'
  local current_line = vim.fn.line '.'
  local last_line = vim.fn.line '$'
  for i = current_line + 1, last_line do
    local line_content = vim.fn.getline(i)
    if line_content:match(pattern) then
      vim.cmd('normal! ' .. i + 1 .. 'G')
      return
    end
  end
end

local function goto_previous_code_chunk()
  local pattern = '^```%{%w+%}'
  local current_line = vim.fn.line '.'
  for i = current_line - 1, 1, -1 do
    local line_content = vim.fn.getline(i)
    if line_content:match(pattern) then
      vim.cmd('normal! ' .. i .. 'G')
      return
    end
  end
end

vim.keymap.set('n', '[[', goto_previous_code_chunk, { noremap = true, silent = true })
vim.keymap.set('n', ']]', goto_next_code_chunk, { noremap = true, silent = true })

-- send code with Enter and leader Enter
vmap('<cr>', '<Plug>SlimeRegionSend')
nmap('<leader><cr>', '<Plug>SlimeSendCell')

-- normal mode with <leader>
wk.add({
  { '<leader><cr>', send_cell, desc = 'run code cell' },

  { '<leader>c', group = '[c]ode / [c]ell / [c]hunk' },
  { '<leader>ci', new_terminal_ipython, desc = 'new [i]python terminal' },
  { '<leader>cn', new_terminal_shell, desc = '[n]ew terminal with shell (vsplit)' },
  {
    '<leader>cN',
    function()
      vim.cmd 'split term://$SHELL'
      vim.cmd 'sleep 100m'
      vim.cmd 'normal! G' -- move to end of terminal
    end,
    desc = '[N]ew terminal with shell (hsplit)',
  },
  { '<leader>cp', new_terminal_python, desc = 'new [p]ython terminal' },
  { '<leader>cr', new_terminal_r, desc = 'new [R] terminal' },
  { '<leader>d', group = '[d]ebug' },
  { '<leader>dt', group = '[t]est' },
  { '<leader>e', group = '[e]dit' },

  { '<leader>f', group = '[f]ind (telescope)' },
  { '<leader>f<space>', '<cmd>Telescope buffers<cr>', desc = '[ ] buffers' },
  { '<leader>fM', '<cmd>Telescope man_pages<cr>', desc = '[M]an pages' },
  { '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'current [b]uffer fuzzy find' },
  { '<leader>fc', '<cmd>Telescope git_commits<cr>', desc = 'git [c]ommits' },
  { '<leader>fd', '<cmd>Telescope buffers<cr>', desc = '[d] buffers' },
  { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = '[f]iles' },
  { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = '[g]rep' },
  { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = '[h]elp' },
  { '<leader>fj', '<cmd>Telescope jumplist<cr>', desc = '[j]umplist' },
  { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = '[k]eymaps' },
  { '<leader>fl', '<cmd>Telescope loclist<cr>', desc = '[l]oclist' },
  { '<leader>fm', '<cmd>Telescope marks<cr>', desc = '[m]arks' },
  { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = '[q]uickfix' },

  { '<leader>l', group = '[l]anguage/lsp' },
  { '<leader>la', vim.lsp.buf.code_action, desc = 'code [a]ction' },
  { '<leader>ld', group = '[d]iagnostics' },
  {
    '<leader>ldd',
    function()
      vim.diagnostic.enable(false)
    end,
    desc = '[d]isable',
  },
  { '<leader>lde', vim.diagnostic.enable, desc = '[e]nable' },
  { '<leader>le', vim.diagnostic.open_float, desc = 'diagnostics (show hover [e]rror)' },
  { '<leader>lg', ':Neogen<cr>', desc = 'neo[g]en docstring' },
  { '<leader>lD', vim.lsp.buf.type_definition, desc = 'type [D]efinition' },
  { '<leader>lR', desc = '[R]ename' },
  { '<leader>lr', vim.lsp.buf.references, desc = '[r]eferences' },

  { '<leader>o', group = '[o]tter & c[o]de' },
  { '<leader>oa', require('otter').activate, desc = 'otter [a]ctivate' },
  { '<leader>ob', insert_bash_chunk, desc = '[b]ash code chunk' },
  { '<leader>oc', 'O# %%<cr>', desc = 'magic [c]omment code chunk # %%' },
  { '<leader>od', require('otter').activate, desc = 'otter [d]eactivate' },
  { '<leader>op', insert_py_chunk, desc = '[p]ython code chunk' },
  { '<leader>or', insert_r_chunk, desc = '[r] code chunk' },
  { '<leader>ol', '<cmd>Oil --float<cr>', desc = '[o]pen oi[l]' },

  { '<leader>q', group = '[q]uarto' },
  {
    '<leader>qE',
    function()
      require('otter').export(true)
    end,
    desc = '[E]xport with overwrite',
  },
  { '<leader>qa', ':QuartoActivate<cr>', desc = '[a]ctivate' },
  { '<leader>qe', require('otter').export, desc = '[e]xport' },
  { '<leader>qh', ':QuartoHelp ', desc = '[h]elp' },
  { '<leader>qp', ":lua require'quarto'.quartoPreview()<cr>", desc = '[p]review' },
  { '<leader>qq', ":lua require'quarto'.quartoClosePreview()<cr>", desc = '[q]uiet preview' },
  { '<leader>qr', group = '[r]un' },
  { '<leader>qra', ':QuartoSendAll<cr>', desc = 'run [a]ll' },
  { '<leader>qrb', ':QuartoSendBelow<cr>', desc = 'run [b]elow' },
  { '<leader>qrr', ':QuartoSendAbove<cr>', desc = 'to cu[r]sor' },

  { '<leader>v', group = '[v]im' },
  { '<leader>vc', ':Telescope colorscheme<cr>', desc = '[c]olortheme' },
  { '<leader>vh', ':execute "h " . expand("<cword>")<cr>', desc = 'vim [h]elp for current word' },
  { '<leader>vl', ':Lazy<cr>', desc = '[l]azy package manager' },
  { '<leader>vm', ':Mason<cr>', desc = '[m]ason software installer' },
  { '<leader>vs', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>', desc = '[s]ettings, edit vimrc' },
  { '<leader>vt', toggle_light_dark_theme, desc = '[t]oggle light/dark theme' },
}, { mode = 'n', prefix = '<leader>' })
