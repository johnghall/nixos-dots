return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "antonk52/bad-practices.nvim",
    opts = {
      most_splits = 6, -- how many splits are considered a good practice(default: 3)
      most_tabs = 3, -- how many tabs are considered a good practice(default: 3)
      max_hjkl = 10, -- how many times you can spam hjkl keys in a row(default: 10)
    },
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true,
          },
        },
      })
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
        "DBUI",
        "DBUIAddConnection",
        "DBUIClose",
        "DBUIToggle",
        "DBUIFindBuffer",
        "DBUIRenameBuffer",
        "DBUILastQueryInfo",
    },
    config = function()
        vim.g.db_ui_notification_width = 1
        vim.g.db_ui_debug = 1

        local cmp = require("cmp")

        cmp.setup.filetype({ "sql" }, {
            sources = {
                { name = "vim-dadbod-completion" },
                { name = "buffer" },
            },
        })
    end,
  }
}
