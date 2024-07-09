if vim.g.vscode then
  require 'config-vscode.global'
  require 'config-vscode.lazy'
  require 'config-vscode.autocommands'
else
  require 'config.global'
  require 'config.lazy'
  require 'config.autocommands'
end
