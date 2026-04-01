return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- QUITAR: "nvim-treesitter/nvim-treesitter-refactor",
  },
  opts = {
    ensure_installed = {
      "astro","bash","c","css","dockerfile","eex","elixir","erlang","gitignore","gleam",
      "go","graphql","heex","html","javascript","json","jsonc","lua","markdown","markdown_inline",
      "prisma","python","regex","rust","scss","sql","toml","tsx","typescript","vim","xml","yaml",
      "zig","diff",
    },
    sync_install = false,
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "grn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    -- refactor = { ... }  -- QUITAR (va ligado al plugin refactor)
    textobjects = {
      enable = true,
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ad"] = { query = "@lexical_declaration.outer", desc = "Select a whole assignment" },
          ["id"] = { query = "@lexical_declaration.inner", desc = "Select inner part of an assignment" },
          ["vd"] = { query = "@lexical_declaration.value", desc = "Select value (rhs) part of an assignment" },
          ["nd"] = { query = "@lexical_declaration.name", desc = "Select name (lhs) part of an assignment" },
          ["at"] = { query = "@ts_type.full", desc = "Select type definition" },
          ["vt"] = { query = "@ts_type.value", desc = "Select type definition value" },
          ["nt"] = { query = "@ts_type.name", desc = "Select type definition name" },
          ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
          ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
          ["ak"] = { query = "@property.key", desc = "Select left part of an object property" },
          ["av"] = { query = "@property.value", desc = "Select right part of an object property" },
          ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
          ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
          ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
          ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
          ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
          ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
          ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
          ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>na"] = "@parameter.inner",
          ["<leader>n:"] = "@property.outer",
          ["<leader>nm"] = "@function.outer",
        },
        swap_previous = {
          ["<leader>pa"] = "@parameter.inner",
          ["<leader>p:"] = "@property.outer",
          ["<leader>pm"] = "@function.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]d"] = { query = "@lexical_declaration.outer", desc = "Next lexical declaration start" },
          ["]f"] = { query = "@call.outer", desc = "Next function call start" },
          ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
          ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["]t"] = { query = "@ts_type.full", desc = "Next type start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
        },
        goto_next_end = {
          ["]D"] = { query = "@lexical_declaration.outer", desc = "Next lexical declaration end" },
          ["]F"] = { query = "@call.outer", desc = "Next function call end" },
          ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
          ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          ["]T"] = { query = "@ts_type.type", desc = "Next type end" },
        },
        goto_previous_start = {
          ["[d"] = { query = "@lexical_declaration.outer", desc = "Prev lexical declaration start" },
          ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
          ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
          ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
          ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
          ["[t"] = { query = "@ts_type.type", desc = "Prev type start" },
        },
        goto_previous_end = {
          ["[D"] = { query = "@lexical_declaration.outer", desc = "Prev lexical declaration end" },
          ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
          ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
          ["[C"] = { query = "@class.outer", desc = "Prev class end" },
          ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
          ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
          ["[T"] = { query = "@ts_type.type", desc = "Prev type end" },
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if ok then
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end
  end,
}
