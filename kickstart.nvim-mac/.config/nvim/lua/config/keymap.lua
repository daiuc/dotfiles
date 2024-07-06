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
nmap('H', '<cmd>tabprevious<cr>')
nmap('L', '<cmd>tabnext<cr>')

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
wk.register({
  ['<c-LeftMouse>'] = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'go to definition' },
  ['<c-q>'] = { '<cmd>q<cr>', 'close buffer' },
  ['<esc>'] = { '<cmd>noh<cr>', 'remove search highlight' },
  ['n'] = { 'nzzzv', 'center search' },
  ['gN'] = { 'Nzzzv', 'center search' },
  ['gl'] = { '<c-]>', 'open help link' },
  ['gf'] = { ':e <cfile><CR>', 'edit file' },
  ['<m-i>'] = { insert_r_chunk, 'r code chunk' },
  ['<cm-i>'] = { insert_py_chunk, 'python code chunk' },
  ['<m-I>'] = { insert_py_chunk, 'python code chunk' },
  [']q'] = { ':silent cnext<cr>', '[q]uickfix next' },
  ['[q'] = { ':silent cprev<cr>', '[q]uickfix prev' },
  ['z?'] = { ':setlocal spell!<cr>', 'toggle [z]pellcheck' },
  ['zl'] = { ':Telescope spell_suggest<cr>', '[l]ist spelling suggestions' },
}, { mode = 'n', silent = true })

-- visual mode
wk.register({
  ['<cr>'] = { send_region, 'run code region' },
  ['<M-j>'] = { ":m'>+<cr>`<my`>mzgv`yo`z", 'move line down' },
  ['<M-k>'] = { ":m'<-2<cr>`>my`<mzgv`yo`z", 'move line up' },
  ['.'] = { ':norm .<cr>', 'repat last normal mode command' },
  ['q'] = { ':norm @q<cr>', 'repat q macro' },
}, { mode = 'v' })

-- visual with <leader>
wk.register({
  p = { '"_dP', 'replace without overwriting reg' },
  d = { '"_d', 'delete without overwriting reg' },
}, { mode = 'v', prefix = '<leader>' })

-- insert mode
wk.register({
  ['<m-->'] = { ' <- ', 'assign' },
  ['<m-m>'] = { ' |>', 'pipe' },
  ['<m-i>'] = { insert_r_chunk, 'r code chunk' },
  ['<cm-i>'] = { insert_py_chunk, 'python code chunk' },
  ['<m-I>'] = { insert_py_chunk, 'python code chunk' },
  ['<c-x><c-x>'] = { '<c-x><c-o>', 'omnifunc completion' },
}, { mode = 'i' })

local function new_terminal(lang)
  vim.cmd('vsplit term://' .. lang)
end

local function new_terminal_python()
  new_terminal 'python'
end

local function new_terminal_r()
  new_terminal 'R --no-save'
end

local function new_terminal_ipython()
  new_terminal 'ipython --no-confirm-exit'
end

local function new_terminal_shell()
  new_terminal '$SHELL'
end

-- normal mode with <leader>
wk.register({
  ['<cr>'] = { send_cell, 'run code cell' },
  c = {
    name = '[c]ode / [c]ell / [c]hunk',
    n = { new_terminal_shell, '[n]ew terminal with shell' },
    r = {
      function()
        vim.b['quarto_is_r_mode'] = true
        new_terminal_r()
      end,
      'new [R] terminal',
    },
    p = { new_terminal_python, 'new [p]ython terminal' },
    i = { new_terminal_ipython, 'new [i]python terminal' },
  },
  e = {
    name = '[e]dit',
  },
  d = {
    name = '[d]ebug',
    t = {
      name = '[t]est',
    },
  },
  f = {
    name = '[f]ind (telescope)',
    f = { '<cmd>Telescope find_files<cr>', '[f]iles' },
    h = { '<cmd>Telescope help_tags<cr>', '[h]elp' },
    k = { '<cmd>Telescope keymaps<cr>', '[k]eymaps' },
    g = { '<cmd>Telescope live_grep<cr>', '[g]rep' },
    b = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'current [b]uffer fuzzy find' },
    m = { '<cmd>Telescope marks<cr>', '[m]arks' },
    M = { '<cmd>Telescope man_pages<cr>', '[M]an pages' },
    c = { '<cmd>Telescope git_commits<cr>', 'git [c]ommits' },
    -- ['<space>'] = { '<cmd>Telescope buffers<cr>', '[ ] buffers' },
    -- d = { '<cmd>Telescope buffers<cr>', '[d] buffers' },
    q = { '<cmd>Telescope quickfix<cr>', '[q]uickfix' },
    l = { '<cmd>Telescope loclist<cr>', '[l]oclist' },
    j = { '<cmd>Telescope jumplist<cr>', '[j]umplist' },
  },
  l = {
    name = '[l]anguage/lsp',
    r = { vim.lsp.buf.references, '[r]eferences' },
    R = { '[R]ename' },
    D = { vim.lsp.buf.type_definition, 'type [D]efinition' },
    a = { vim.lsp.buf.code_action, 'code [a]ction' },
    e = { vim.diagnostic.open_float, 'diagnostics (show hover [e]rror)' },
    d = {
      name = '[d]iagnostics',
      d = {
        function()
          vim.diagnostic.enable(false)
        end,
        '[d]isable',
      },
      e = { vim.diagnostic.enable, '[e]nable' },
    },
    g = { ':Neogen<cr>', 'neo[g]en docstring' },
  },
  o = {
    name = '[o]tter & c[o]de',
    a = { require('otter').activate, 'otter [a]ctivate' },
    d = { require('otter').deactivate, 'otter [d]eactivate' },
    c = { 'O# %%<cr>', 'magic [c]omment code chunk # %%' },
    r = { insert_r_chunk, '[r] code chunk' },
    p = { insert_py_chunk, '[p]ython code chunk' },
    b = { insert_bash_chunk, '[b]ash code chunk' },
  },
  q = {
    name = '[q]uarto',
    a = { ':QuartoActivate<cr>', '[a]ctivate' },
    p = { ":lua require'quarto'.quartoPreview()<cr>", '[p]review' },
    q = { ":lua require'quarto'.quartoClosePreview()<cr>", '[q]uiet preview' },
    h = { ':QuartoHelp ', '[h]elp' },
    r = {
      name = '[r]un',
      r = { ':QuartoSendAbove<cr>', 'to cu[r]sor' },
      a = { ':QuartoSendAll<cr>', 'run [a]ll' },
      b = { ':QuartoSendBelow<cr>', 'run [b]elow' },
    },
    e = { require('otter').export, '[e]xport' },
    E = {
      function()
        require('otter').export(true)
      end,
      '[E]xport with overwrite',
    },
  },
  v = {
    name = '[v]im',
    t = { toggle_light_dark_theme, '[t]oggle light/dark theme' },
    c = { ':Telescope colorscheme<cr>', '[c]olortheme' },
    s = { ':e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>', '[s]ettings, edit vimrc' },
    h = { ':execute "h " . expand("<cword>")<cr>', 'vim [h]elp for current word' },
  },
}, { mode = 'n', prefix = '<leader>' })
