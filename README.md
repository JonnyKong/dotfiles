# Dot Files

### Setup

Install [packer.nvim](https://github.com/wbthomason/packer.nvim)

```
ln -s <this_repo>/.config/nvim/init.lua init.lua
ln -s <this_repo>/.config/nvim/lua lua
ln -s <this_repo>/.config/nvim/coc-settings.json coc-settings.json

:PackerSync
:CocCommand clangd.install
```
