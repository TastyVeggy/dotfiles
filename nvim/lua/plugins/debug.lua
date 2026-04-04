return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")
            local dap_python = require("dap-python")

            require("dapui").setup()
            require("nvim-dap-virtual-text").setup()


            dap_python.setup("python3")

            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>dc", dap.run_to_cursor)

            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<leader>dl", dap.continue)
            vim.keymap.set("n", "<leader>di", dap.step_into)
            vim.keymap.set("n", "<leader>do", dap.step_over)
            vim.keymap.set("n", "<leader>d0", dap.step_out)
            vim.keymap.set("n", "<leader>dh", dap.step_back)
            vim.keymap.set("n", "<leader>dr", dap.restart)


            vim.keymap.set("n", "<leader>dq", function()
                dap.terminate()
            end, {}
            )

            vim.keymap.set("n", "<leader>du", function() ui.toggle() end, {})

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end

            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end

            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end

            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
