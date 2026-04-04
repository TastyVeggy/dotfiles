return {
    "nvim-telescope/telescope.nvim",
    version = '0.2.x',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = {
                    theme = "dropdown",
                },
                diagnostics = {
                    theme = "dropdown",
                },
            },
            defaults = {
                file_ignore_patterns = { "node_modules", "venv" },
            },
        })
    end,
}
