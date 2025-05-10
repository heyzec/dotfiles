# neovim

Single config for vim, neovim and neovim + VS Code

## Directory structure
```
.
├── init.lua             entry point for neovim
├── vimrc                entry point for vim, contains basic configs and also sourced by neovim
├── plugins.vim          if vim, vim-plug will install some basic plugins
└── lua/                 if neovim, files within this directory will be sourced
    ├── keymaps.lua      defines all keymaps used for neovim and neovim + VS Code
    ├── tooling.lua      defines and configures tools (such as LSPs, formatters)
    └── plugins/         contains plugins specs which lazy.nvim will install
```

## Debugging Lua configs with VS Code
1. Open the `debug.code-workspace` workspace with VS Code.

2. Run Neovim with "debug mode":
    ```sh
    NVIM_INIT_DEBUG=1 nvim"
    ```
    Neovim should wait for debugger to be attached, with the message "Server started on port 8086".

3. Launch the "Debug Neovim via OSV" debug configuration in VS Code. This should trigger Neovim to continue its normal loading of configs.
