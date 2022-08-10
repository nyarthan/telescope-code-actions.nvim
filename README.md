# telescope-code-actions.nvim

## Requirements

Neovim 0.7.0+  
telescope.nvim (obviously)

## Installation

Similar to every other plugin, e.g. with Packer:

```lua
require('packer').startup(function()
  use('nyarthan/telescope-code-actions.nvim')
end)
```

## Configuration

Load the extension with telescope

```lua
require('telescope').load_extensions('telescope-code-actions')
```

## Usage

via command:

```vim
:Telescope code_actions open
```

via lua api:

```lua
require('telescope').extensions.code_actions.open()
```
