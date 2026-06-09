-- ============================================================
-- init.lua minimale:
-- Python, C, Rust, Zig, Bash, Assembly
-- No Node, no SQL, plugin open-source e stabili
-- ============================================================

-- Imposta il tasto leader su spazio.
-- Quindi le scorciatoie tipo <leader>e diventano Space + e.
vim.g.mapleader = " "

-- Imposta anche il localleader su spazio.
-- Serve per eventuali scorciatoie specifiche per filetype/plugin.
vim.g.maplocalleader = " "

-- Mostra il numero assoluto della riga corrente.
vim.opt.number = true

-- Mostra numeri relativi sulle altre righe.
-- È utile per muoversi con comandi tipo 5j, 3k, 10dd.
vim.opt.relativenumber = true

-- Abilita colori truecolor nel terminale.
vim.opt.termguicolors = true

-- Abilita il mouse dentro Neovim.
vim.opt.mouse = "a"

-- Usa la clipboard di sistema.
-- Così yy/y/p comunicano con la clipboard di macOS.
vim.opt.clipboard = "unnamedplus"

-- Converte i tab in spazi.
vim.opt.expandtab = true

-- L'indentazione automatica usa 4 spazi.
vim.opt.shiftwidth = 4

-- Un carattere tab viene visualizzato come 4 colonne.
vim.opt.tabstop = 4

-- Quando premi Tab in insert mode, inserisce 4 spazi logici.
vim.opt.softtabstop = 4

-- Abilita indentazione automatica semplice.
vim.opt.smartindent = true

-- Non spezza visivamente le righe lunghe.
vim.opt.wrap = false

-- Ignora maiuscole/minuscole nelle ricerche.
vim.opt.ignorecase = true

-- Se nella ricerca scrivi una maiuscola, la ricerca diventa case-sensitive.
vim.opt.smartcase = true

-- Tiene sempre visibile la colonna laterale per errori/warning/git signs.
-- Così il testo non si sposta quando appaiono diagnostiche.
vim.opt.signcolumn = "yes"

-- Tiene 8 righe visibili sopra e sotto il cursore.
vim.opt.scrolloff = 8

-- Tiene margine laterale quando scorri orizzontalmente.
vim.opt.sidescrolloff = 8

-- Gli split verticali nuovi si aprono a destra.
vim.opt.splitright = true

-- Gli split orizzontali nuovi si aprono sotto.
vim.opt.splitbelow = true

-- Riduce il tempo di attesa per aggiornamenti LSP/diagnostica.
vim.opt.updatetime = 250

-- Configura il menu autocomplete.
-- "menu": mostra il menu.
-- "menuone": mostra il menu anche con un solo risultato.
-- "noselect": non seleziona automaticamente il primo risultato.
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Disabilita netrw, il file explorer integrato di Vim.
-- Lo facciamo perché useremo nvim-tree.
vim.g.loaded_netrw = 1

-- Disabilita anche il plugin netrw.
vim.g.loaded_netrwPlugin = 1

-- Aggiunge riconoscimento esplicito per alcuni filetype.
vim.filetype.add({
  extension = {
    -- File assembly generici.
    asm = "asm",

    -- File assembly Unix/GAS.
    s = "asm",

    -- File assembly con preprocessing C.
    S = "asm",

    -- File NASM.
    nasm = "asm",

    -- File Zig.
    zig = "zig",

    -- Script shell.
    sh = "sh",

    -- Script Bash.
    bash = "sh",
  },
})

-- ============================================================
-- Bootstrap lazy.nvim
-- ============================================================

-- Usa vim.uv se disponibile, altrimenti vim.loop.
-- Serve per controllare se lazy.nvim è già installato.
local uv = vim.uv or vim.loop

-- Calcola il path in cui verrà installato lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Se lazy.nvim non esiste ancora, lo clona da GitHub.
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

-- Aggiunge lazy.nvim al runtime path di Neovim.
-- Da qui in poi require("lazy") funziona.
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Plugin
-- ============================================================

require("lazy").setup({

  -- ------------------------------------------------------------
  -- Tema colore
  -- ------------------------------------------------------------
  {
    -- Tema molto usato, stabile, open-source.
    "folke/tokyonight.nvim",

    -- Lo carichiamo subito, non in lazy-load.
    lazy = false,

    -- Priorità alta: il tema deve caricarsi prima degli altri plugin visuali.
    priority = 1000,

    -- Configurazione del tema.
    config = function()
      -- Applica variante scura del tema.
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- ------------------------------------------------------------
  -- File explorer laterale
  -- ------------------------------------------------------------
  {
    -- File tree laterale.
    "nvim-tree/nvim-tree.lua",

    -- Opzioni del file explorer.
    opts = {
      -- Larghezza pannello laterale.
      view = {
        width = 34,
      },

      -- Collassa directory vuote annidate.
      renderer = {
        group_empty = true,
      },

      -- Mostra anche file nascosti tipo .env, .gitignore, .clangd.
      filters = {
        dotfiles = false,
      },
    },

    -- Scorciatoie.
    keys = {
      -- Space + e apre/chiude il file tree.
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Apri/chiudi file tree" },
    },
  },

  -- ------------------------------------------------------------
  -- Ricerca file/testo nel progetto
  -- ------------------------------------------------------------
  {
    -- Fuzzy finder.
    "nvim-telescope/telescope.nvim",

    -- Usa release stabili.
    version = "*",

    -- Dipendenza necessaria a Telescope.
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- Configurazione Telescope.
    config = function()
      -- Importa il modulo principale.
      local telescope = require("telescope")

      -- Inizializza con default semplici.
      telescope.setup({})

      -- Importa i picker built-in.
      local builtin = require("telescope.builtin")

      -- Space + ff cerca file nel progetto.
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {
        desc = "Cerca file",
      })

      -- Space + fg cerca testo nel progetto.
      -- Usa ripgrep se installato.
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
        desc = "Cerca testo nel progetto",
      })

      -- Space + fb mostra i buffer aperti.
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {
        desc = "Cerca buffer aperti",
      })

      -- Space + fh cerca nella documentazione di Neovim.
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
        desc = "Cerca help",
      })
    end,
  },

  -- ------------------------------------------------------------
  -- Syntax highlighting avanzato
  -- ------------------------------------------------------------
  {
    -- Treesitter dà highlighting strutturale, migliore del regex highlighting classico.
    "nvim-treesitter/nvim-treesitter",

    -- Branch conservativo per Neovim stabile.
    branch = "master",

    -- Aggiorna i parser quando installi o aggiorni il plugin.
    build = ":TSUpdate",

    -- Carica Treesitter quando apri o crei un file.
    event = { "BufReadPost", "BufNewFile" },

    -- Configurazione Treesitter.
    config = function()
      require("nvim-treesitter.configs").setup({

        -- Parser da installare.
        ensure_installed = {
          -- Linguaggi che usi.
          "python",
          "c",
          "rust",
          "zig",
          "bash",
          "asm",
          "nasm",

          -- Necessari o utili per configurare Neovim stesso.
          "lua",
          "vim",
          "vimdoc",
          "query",
        },

        -- Abilita syntax highlighting Treesitter.
        highlight = {
          enable = true,
        },

        -- Abilita indentazione basata su Treesitter dove funziona bene.
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- ------------------------------------------------------------
  -- Mason: installa SOLO gli LSP che non stiamo gestendo con brew/rustup
  -- ------------------------------------------------------------
  {
    -- Mason gestisce binari esterni per Neovim.
    "mason-org/mason.nvim",

    -- Configurazione base.
    opts = {
      -- UI semplice.
      ui = {
        border = "rounded",
      },
    },
  },

  {
    -- Collega Mason a nvim-lspconfig.
    "mason-org/mason-lspconfig.nvim",

    -- Dipende da Mason e da nvim-lspconfig.
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    -- Qui installiamo solo roba che non hai già installato da sistema.
    opts = {
      ensure_installed = {
        -- Zig language server.
        "zls",

        -- Assembly language server.
        "asm_lsp",
      },
    },
  },

  -- ------------------------------------------------------------
  -- LSP config
  -- ------------------------------------------------------------
  {
    -- Configurazioni comuni per il client LSP integrato di Neovim.
    "neovim/nvim-lspconfig",

    -- Dipendenze per completion LSP.
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },

    -- Configurazione dei language server.
    config = function()
      -- Importa nvim-lspconfig.
      local lspconfig = require("lspconfig")

      -- Importa le capabilities di nvim-cmp.
      -- Questo dice ai language server che Neovim supporta completion avanzata.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Funzione comune chiamata quando un LSP si collega a un buffer.
      local on_attach = function(_, bufnr)
        -- Helper per creare keymap locali al buffer.
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        -- Vai alla definizione del simbolo sotto il cursore.
        map("n", "gd", vim.lsp.buf.definition, "Vai alla definizione")

        -- Vai alla dichiarazione.
        map("n", "gD", vim.lsp.buf.declaration, "Vai alla dichiarazione")

        -- Trova riferimenti del simbolo.
        map("n", "gr", vim.lsp.buf.references, "Trova riferimenti")

        -- Vai all'implementazione.
        map("n", "gi", vim.lsp.buf.implementation, "Vai all'implementazione")

        -- Mostra documentazione hover.
        map("n", "K", vim.lsp.buf.hover, "Documentazione hover")

        -- Rinomina simbolo nel progetto.
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rinomina simbolo")

        -- Mostra code action disponibili.
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

        -- Formatta il buffer.
        map("n", "<leader>f", function()
          local ft = vim.bo[bufnr].filetype

          -- Per shell script usiamo shfmt direttamente, senza plugin extra.
          if ft == "sh" or ft == "bash" then
            vim.cmd("silent write")
            vim.cmd("silent !shfmt -w %")
            vim.cmd("edit")
            return
          end

          -- Per Python preferiamo ruff come formatter se disponibile.
          if ft == "python" then
            vim.lsp.buf.format({
              async = true,
              filter = function(client)
                return client.name == "ruff"
              end,
            })
            return
          end

          -- Per gli altri linguaggi usa il formatter LSP disponibile.
          vim.lsp.buf.format({
            async = true,
          })
        end, "Formatta buffer")
      end

      -- --------------------------------------------------------
      -- Python: pylsp
      -- --------------------------------------------------------
      lspconfig.pylsp.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,

        -- Configurazione pylsp.
        settings = {
          pylsp = {
            plugins = {
              -- Disabilitiamo pycodestyle perché useremo ruff.
              pycodestyle = {
                enabled = false,
              },

              -- Disabilitiamo pyflakes perché useremo ruff.
              pyflakes = {
                enabled = false,
              },

              -- Disabilitiamo mccabe perché useremo ruff.
              mccabe = {
                enabled = false,
              },

              -- Lasciamo Jedi per completion, goto definition, hover.
              jedi_completion = {
                enabled = true,
                fuzzy = true,
              },

              -- Abilita hover tramite Jedi.
              jedi_hover = {
                enabled = true,
              },

              -- Abilita references tramite Jedi.
              jedi_references = {
                enabled = true,
              },

              -- Abilita rename tramite rope se disponibile.
              rope_completion = {
                enabled = true,
              },
            },
          },
        },
      })

      -- --------------------------------------------------------
      -- Python: ruff
      -- --------------------------------------------------------
      lspconfig.ruff.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,

        -- Usa il server integrato di ruff.
        cmd = {
          "ruff",
          "server",
        },
      })

      -- --------------------------------------------------------
      -- C: clangd da LLVM Homebrew
      -- --------------------------------------------------------

      -- Path di clangd installato da Homebrew LLVM.
      local homebrew_clangd = "/opt/homebrew/opt/llvm/bin/clangd"

      -- Se quel path esiste, usa quello.
      -- Altrimenti prova semplicemente "clangd" dal PATH.
      local clangd_bin = vim.fn.executable(homebrew_clangd) == 1 and homebrew_clangd or "clangd"

      lspconfig.clangd.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,

        -- Comando clangd.
        cmd = {
          clangd_bin,

          -- Indicizza il progetto in background.
          "--background-index",

          -- Abilita diagnostiche clang-tidy dove possibile.
          "--clang-tidy",

          -- Completion più dettagliata.
          "--completion-style=detailed",

          -- Include placeholder negli snippet di completion.
          "--function-arg-placeholders",
        },
      })

      -- --------------------------------------------------------
      -- Rust: rust-analyzer da rustup
      -- --------------------------------------------------------
      lspconfig.rust_analyzer.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,

        -- Configurazione rust-analyzer.
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              -- Analizza tutte le feature Cargo.
              allFeatures = true,
            },

            check = {
              -- Usa clippy al posto di cargo check.
              command = "clippy",
            },
          },
        },
      })

      -- --------------------------------------------------------
      -- Zig: zls installato da Mason
      -- --------------------------------------------------------
      lspconfig.zls.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,
      })

      -- --------------------------------------------------------
      -- Assembly: asm-lsp installato da Mason
      -- --------------------------------------------------------
      lspconfig.asm_lsp.setup({
        -- Usa keymap comuni.
        on_attach = on_attach,

        -- Usa capabilities completion di nvim-cmp.
        capabilities = capabilities,
      })
    end,
  },

  -- ------------------------------------------------------------
  -- Snippet engine
  -- ------------------------------------------------------------
  {
    -- Motore snippet.
    "L3MON4D3/LuaSnip",

    -- Carica in insert mode.
    event = "InsertEnter",

    -- Dipendenza: raccolta snippet già pronti.
    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    -- Configurazione snippet.
    config = function()
      -- Carica gli snippet in formato VSCode.
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- ------------------------------------------------------------
  -- AI autocomplete con llama.cpp locale o LAN
  -- ------------------------------------------------------------
  {
    -- Plugin AI completion.
    -- Open-source, non è Copilot, non richiede servizi proprietari.
    "milanglacier/minuet-ai.nvim",

    -- Lo carichiamo in insert mode, cioè quando può servire completion.
    event = "InsertEnter",

    -- Configurazione Minuet.
    config = function()
      -- Provider di default: endpoint OpenAI-compatible FIM.
      -- FIM = Fill In the Middle, migliore per autocomplete codice.
      local provider = vim.env.NVIM_AI_PROVIDER or "openai_fim_compatible"

      -- Endpoint locale default.
      -- Qui deve esserci llama-server con /v1/completions.
      local endpoint = vim.env.NVIM_AI_ENDPOINT or "http://127.0.0.1:8012/v1/completions"

      -- Nome modello.
      -- Con llama.cpp spesso è solo informativo.
      local model = vim.env.NVIM_AI_MODEL or "local"

      require("minuet").setup({
        -- Seleziona il provider.
        provider = provider,

        -- Numero approssimativo di token di contesto.
        -- Più è alto, più il modello capisce il file, ma più diventa lento.
        context_window = 768,

        -- Timeout per evitare che Neovim rimanga appeso.
        request_timeout = 6,

        -- Una sola completion AI per volta.
        n_completions = 1,

        -- Configurazione dei provider disponibili.
        provider_options = {
          openai_fim_compatible = {
            -- Chiave finta: llama.cpp locale non richiede API key.
            api_key = function()
              return "llama.cpp"
            end,

            -- Nome leggibile.
            name = "llama.cpp FIM",

            -- Endpoint /v1/completions.
            end_point = endpoint,

            -- Nome modello.
            model = model,

            -- Non usiamo streaming per completion inline.
            stream = false,

            -- Parametri generativi.
            optional = {
              -- Massimo testo generato.
              max_tokens = 96,

              -- Bassa temperatura: meglio per codice.
              temperature = 0.2,

              -- Campionamento moderato.
              top_p = 0.9,
            },

            -- Template FIM per Qwen2.5-Coder.
            template = {
              prompt = function(context_before_cursor, context_after_cursor, _)
                return "<|fim_prefix|>"
                  .. context_before_cursor
                  .. "<|fim_suffix|>"
                  .. context_after_cursor
                  .. "<|fim_middle|>"
              end,

              -- Non mandiamo suffix come campo separato.
              suffix = false,
            },
          },
        },
      })
    end,
  },

  -- ------------------------------------------------------------
  -- Completion engine
  -- ------------------------------------------------------------
  {
    -- Motore autocomplete principale.
    "hrsh7th/nvim-cmp",

    -- Carica quando entri in insert mode.
    event = "InsertEnter",

    -- Sorgenti di completamento.
    dependencies = {
      -- Completion dai language server.
      "hrsh7th/cmp-nvim-lsp",

      -- Completion dai path file.
      "hrsh7th/cmp-path",

      -- Completion dalle parole nel buffer.
      "hrsh7th/cmp-buffer",

      -- Completion dagli snippet.
      "saadparwaiz1/cmp_luasnip",

      -- Snippet engine.
      "L3MON4D3/LuaSnip",

      -- AI completion.
      "milanglacier/minuet-ai.nvim",
    },

    -- Configurazione completion.
    config = function()
      -- Importa nvim-cmp.
      local cmp = require("cmp")

      -- Importa LuaSnip.
      local luasnip = require("luasnip")

      -- Importa Minuet.
      local minuet = require("minuet")

      cmp.setup({
        -- Dice a cmp come espandere snippet.
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Mappature in insert mode.
        mapping = cmp.mapping.preset.insert({
          -- Ctrl+Space apre il menu completion.
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Ctrl+n va al suggerimento successivo.
          ["<C-n>"] = cmp.mapping.select_next_item(),

          -- Ctrl+p va al suggerimento precedente.
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Ctrl+y conferma il suggerimento.
          ["<C-y>"] = cmp.mapping.confirm({
            select = true,
          }),

          -- Ctrl+e chiude il menu completion.
          ["<C-e>"] = cmp.mapping.abort(),

          -- Alt+y chiede esplicitamente una completion AI.
          -- Così l'AI non rompe le palle a ogni carattere.
          ["<A-y>"] = minuet.make_cmp_map(),
        }),

        -- Sorgenti principali.
        sources = cmp.config.sources({
          -- LSP: completamento intelligente da pylsp, clangd, rust-analyzer, zls, asm-lsp.
          {
            name = "nvim_lsp",
          },

          -- Snippet.
          {
            name = "luasnip",
          },

          -- Path file.
          {
            name = "path",
          },

          -- AI completion.
          -- Rimane disponibile, ma la richiami soprattutto con Alt+y.
          {
            name = "minuet",
            group_index = 1,
            priority = 100,
          },
        }, {
          -- Sorgente secondaria: parole già presenti nel file.
          {
            name = "buffer",
          },
        }),

        -- Timeout più alto per permettere alla sorgente AI di rispondere.
        performance = {
          fetching_timeout = 3000,
        },
      })
    end,
  },
})

-- ============================================================
-- Diagnostica LSP
-- ============================================================

vim.diagnostic.config({
  -- Mostra errori/warning inline.
  virtual_text = true,

  -- Mostra segni nella signcolumn.
  signs = true,

  -- Sottolinea codice problematico.
  underline = true,

  -- Non aggiornare diagnostica mentre scrivi.
  update_in_insert = false,

  -- Ordina diagnostica per gravità.
  severity_sort = true,

  -- Finestra flottante diagnostica con bordo.
  float = {
    border = "rounded",
  },
})

-- Vai alla diagnostica precedente.
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
  desc = "Diagnostica precedente",
})

-- Vai alla diagnostica successiva.
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
  desc = "Diagnostica successiva",
})

-- Mostra diagnostica della riga corrente.
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, {
  desc = "Diagnostica riga",
})

-- Mostra lista diagnostiche.
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, {
  desc = "Lista diagnostiche",
})

-- ============================================================
-- Bash helpers senza plugin extra
-- ============================================================

-- Quando apri un file shell/bash, aggiunge comandi locali.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash" },

  callback = function(event)
    -- Space + sc esegue shellcheck sul file corrente.
    vim.keymap.set("n", "<leader>sc", function()
      vim.cmd("write")
      vim.cmd("!shellcheck %")
    end, {
      buffer = event.buf,
      desc = "ShellCheck file",
    })

    -- Space + sf formatta il file corrente con shfmt.
    vim.keymap.set("n", "<leader>sf", function()
      vim.cmd("write")
      vim.cmd("!shfmt -w %")
      vim.cmd("edit")
    end, {
      buffer = event.buf,
      desc = "Formatta shell con shfmt",
    })
  end,
})
