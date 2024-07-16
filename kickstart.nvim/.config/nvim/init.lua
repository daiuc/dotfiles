if vim.g.vscode then
  require 'config-vscode.global'
  require 'config-vscode.autocommands'
  require 'config-vscode.lazy'
else
  require 'config.global'
  require 'config.autocommands'
  require 'config.lazy'
end
