-- ============================================================
-- Native Neovim config: zero plugins, zero Mason
-- Target: Neovim >= 0.11
-- Languages: Python, C/C++, Rust, Bash
-- No Zig LSP. No Assembly LSP.
--
-- Required external programs: none.
-- Optional LSP binaries:
--   pylsp          Python
--   clangd         C/C++
--   rust-analyzer  Rust
--
-- Disable all LSPs:       NVIM_NO_LSP=1 nvim
-- Disable Python LSP:     NVIM_NO_PY_LSP=1 nvim
-- Disable C/C++ LSP:      NVIM_NO_C_LSP=1 nvim
-- Disable Rust LSP:       NVIM_NO_RUST_LSP=1 nvim
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- ------------------------------------------------------------
-- Base options
-- ------------------------------------------------------------

opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 400

-- Native completion menu. No nvim-cmp.
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12

-- Light disk behavior.
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true

-- Native :find support.
opt.path:append("**")
opt.wildmenu = true
opt.wildignore:append({
  "*/.git/*",
  "*/target/*",
  "*/__pycache__/*",
  "*/.venv/*",
  "*/venv/*",
  "*.o",
  "*.a",
  "*.so",
  "*.dylib",
  "*.pyc",
})

vim.filetype.add({
  extension = {
    -- Syntax/filetype only. No Assembly LSP is configured.
    asm = "asm",
    s = "asm",
    S = "asm",
    nasm = "asm",
    sh = "sh",
    bash = "sh",
  },
})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
pcall(vim.cmd.colorscheme, "habamax")

-- ------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------

local function env_true(name)
  local value = vim.env[name]
  return value == "1" or value == "true" or value == "yes" or value == "on"
end

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function first_executable(candidates)
  for _, cmd in ipairs(candidates) do
    if executable(cmd) then
      return cmd
    end
  end
  return nil
end

local function unique_insert(tbl, value)
  for _, item in ipairs(tbl) do
    if item == value then
      return
    end
  end
  table.insert(tbl, value)
end

-- ------------------------------------------------------------
-- Native keymaps
-- ------------------------------------------------------------

vim.keymap.set("n", "<leader>e", "<cmd>Explore<CR>", {
  desc = "Native file explorer",
})

vim.keymap.set("n", "<leader>ff", function()
  local name = vim.fn.input("find file: ")
  if name ~= "" then
    vim.cmd("find " .. vim.fn.fnameescape(name))
  end
end, {
  desc = "Find file with native :find",
})

vim.keymap.set("n", "<leader>fb", "<cmd>buffers<CR>:buffer ", {
  desc = "List buffers",
})

vim.api.nvim_create_user_command("Grep", function(opts_cmd)
  local pattern = opts_cmd.args
  if pattern == "" then
    pattern = vim.fn.input("vimgrep pattern: ")
  end
  if pattern == "" then
    return
  end

  local escaped = vim.fn.escape(pattern, [[/\]])
  vim.cmd("silent! vimgrep /" .. escaped .. "/gj **/*")
  vim.cmd("copen")
end, {
  nargs = "*",
  desc = "Search text with native vimgrep, no ripgrep needed",
})

vim.keymap.set("n", "<leader>fg", function()
  vim.cmd("Grep")
end, {
  desc = "Native text search",
})

vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Native completion.
-- LSP omnifunc when an LSP is attached; normal Ctrl-n/Ctrl-p still work.
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", {
  desc = "Native LSP completion",
})
vim.keymap.set("i", "<C-@>", "<C-x><C-o>", {
  desc = "Native LSP completion",
})

-- ------------------------------------------------------------
-- Diagnostics
-- ------------------------------------------------------------

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Line diagnostic" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- ------------------------------------------------------------
-- Native LSP, no nvim-lspconfig
-- ------------------------------------------------------------

if not env_true("NVIM_NO_LSP") then
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local bufnr = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client then
        -- Keep it light. Syntax highlighting stays native.
        client.server_capabilities.semanticTokensProvider = nil
      end

      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
        })
      end

      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "gi", vim.lsp.buf.implementation, "Implementation")
      map("n", "K", vim.lsp.buf.hover, "Hover")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "LSP format")
    end,
  })

  local servers = {}

  -- Python: optional, enabled by default if pylsp exists.
  if not env_true("NVIM_NO_PY_LSP") and executable("pylsp") then
    vim.lsp.config("pylsp", {
      cmd = { "pylsp" },
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        ".git",
      },
      settings = {
        pylsp = {
          plugins = {
            -- Keep pylsp light: Jedi only, no optional formatters/linters.
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            mccabe = { enabled = false },
            pylint = { enabled = false },
            flake8 = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            rope_completion = { enabled = false },
            rope_autoimport = { enabled = false },
            jedi_completion = { enabled = true, fuzzy = true },
            jedi_hover = { enabled = true },
            jedi_references = { enabled = true },
            jedi_definition = { enabled = true },
          },
        },
      },
    })
    table.insert(servers, "pylsp")
  end

  -- C/C++: optional, enabled by default if clangd exists.
  if not env_true("NVIM_NO_C_LSP") then
    local clangd_bin = first_executable({
      "/opt/homebrew/opt/llvm/bin/clangd",
      "/usr/local/opt/llvm/bin/clangd",
      "clangd",
      "clangd-22",
      "clangd-21",
      "clangd-20",
      "clangd-19",
      "clangd-18",
      "clangd-17",
      "clangd-16",
      "clangd-15",
    })

    if clangd_bin then
      vim.lsp.config("clangd", {
        cmd = {
          clangd_bin,
          "--background-index=false",
          "--completion-style=bundled",
          "--function-arg-placeholders=0",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          ".clangd",
          ".git",
        },
      })
      table.insert(servers, "clangd")
    end
  end

  -- Rust: optional, enabled by default if rust-analyzer exists.
  if not env_true("NVIM_NO_RUST_LSP") and executable("rust-analyzer") then
    vim.lsp.config("rust_analyzer", {
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      root_markers = { "Cargo.toml", "rust-project.json", ".git" },
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = false },
          check = { command = "check" },
          diagnostics = { experimental = { enable = false } },
        },
      },
    })
    table.insert(servers, "rust_analyzer")
  end


  if #servers > 0 then
    vim.lsp.enable(servers)
  end
end

-- ------------------------------------------------------------
-- Info command
-- ------------------------------------------------------------

vim.api.nvim_create_user_command("NvimNativeInfo", function()
  local lsp_disabled = env_true("NVIM_NO_LSP")
  local clients = lsp_disabled and {} or vim.lsp.get_clients({ bufnr = 0 })
  local names = {}

  for _, client in ipairs(clients) do
    unique_insert(names, client.name)
  end

  local function yes_no(value)
    return value and "yes" or "no"
  end

  local clangd_bin = first_executable({
    "/opt/homebrew/opt/llvm/bin/clangd",
    "/usr/local/opt/llvm/bin/clangd",
    "clangd",
    "clangd-22",
    "clangd-21",
    "clangd-20",
    "clangd-19",
    "clangd-18",
    "clangd-17",
    "clangd-16",
    "clangd-15",
  })

  local lines = {
    "Profile: native LSP, no Assembly LSP",
    "Plugins: 0",
    "Mason: no",
    "AI: no",
    "Zig LSP: removed",
    "Assembly LSP: removed",
    "Completion: native (<C-x><C-o> / <C-Space>)",
    "LSP active in buffer: " .. (lsp_disabled and "disabled by NVIM_NO_LSP=1" or (#names > 0 and table.concat(names, ", ") or "none")),
    "pylsp installed: " .. yes_no(executable("pylsp")) .. "; disabled: " .. yes_no(env_true("NVIM_NO_PY_LSP")),
    "clangd installed: " .. yes_no(clangd_bin ~= nil) .. (clangd_bin and (" (" .. clangd_bin .. ")") or "") .. "; disabled: " .. yes_no(env_true("NVIM_NO_C_LSP")),
    "rust-analyzer installed: " .. yes_no(executable("rust-analyzer")) .. "; disabled: " .. yes_no(env_true("NVIM_NO_RUST_LSP")),
    "Explorer: netrw (:Explore)",
    "Grep: :Grep with native vimgrep",
  }

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})
