---@diagnostic disable: undefined-global

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " " -- leader key

--> neogit <--
map("n", "ng", ":Neogit<CR>", {})

map("n", "<leader>pv", ":Explore<CR>", {})

--> scripts <--
map("n", "<leader>c", ":w! | !mdcomp %; echo '---press enter---'; read<CR>", {}) -- only if required, cuz then need to install pandoc
map("n", "<leader>o", ":!opout %<CR><CR>", {})

-->templates<--
map("n", "cheat", ":r $HOME/.config/nvim/templates/tex/cheat.tex<CR>", {})
map("n", "tut", ":r $HOME/.config/nvim/templates/tex/hw.tex<CR>", {})
map("n", "gfg", ":r $HOME/.config/nvim/templates/cpp/cp.cpp<CR>", {})

map("n", "cp", ":CompetiTest receive testcases<CR>", {})
map("n", "cprun", ":CompetiTest run<CR>", {})

map("n", "<leader>tm", ":term<CR>i", {})
map("t", "<leader>q", "<C-\\><C-n>", {})

--> diffview <--
map("n", "<leader>do", ":DiffviewOpen<CR>", {})
map("n", "<leader>dc", ":DiffviewClose<CR>", {})
map("n", "<leader>dt", ":DiffviewToggleFiles<CR>", {})

--> telescope mappings <--
--> map("n", "<leader>oc", ":Telescope lsp_outgoing_calls<cr>", opts)
map("n", "<leader>pd", ":Telescope diagnostics<cr>", opts)
map("n", "<leader>pg", ":Telescope live_grep<cr>", opts)
map("n", "<leader>pb", ":Telescope buffers<cr>", opts)
map("n", "<leader>pf", ":Telescope find_files<cr>", opts)
map("n", "<leader>ps", ":Telescope git_files<cr>", opts)
map("n", "gr", ":Telescope lsp_references<cr>", opts)

map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
-- map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
map("x", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
map("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
