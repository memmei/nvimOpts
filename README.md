# init on windows
```sh
winget install Neovim.Neovim
winget install neovide.neovide
# livegrep: smart grep
winget install -e --id BurntSushi.ripgrep.MSVC
# treesitter: syntax analysis
winget install -e --id tree-sitter.tree-sitter-cli
```

# init on mac
```sh
brew install neovim
brew install --cask neovide
# livegrep: smart grep
brew install ripgrep
# treesitter: syntax analysis
brew install tree-sitter
```

# init.lua limitations
lua only reads lua/* in init.lua.
