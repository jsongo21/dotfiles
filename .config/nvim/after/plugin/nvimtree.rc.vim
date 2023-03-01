lua << EOF
require("nvim-tree").setup {
  disable_netrw        = true,
  open_on_setup        = true,
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  git = {
    timeout = 500,
    ignore = false
  },
  filters = {
    dotfiles = false
  },
  view = {
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
  },
}
EOF
