return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    bufdelete = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = true },
    indent = { enabled = true },
    input = { enabled = false },
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },
    notifier = { enabled = false },
    picker = { enabled = true },
    quickfile = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    zen = { enabled = true },
  },
  keys = {
    --------------
    -- Smooth scroll
    --------------
    {
      '<leader>us',
      function()
        Snacks.scroll.enable()
      end,
      desc = 'Enable Smooth Scroll',
    },
    {
      '<leader>uS',
      function()
        Snacks.scroll.disable()
      end,
      desc = 'Disable Smooth Scroll',
    },
    --------------
    -- Bufdelete
    --------------
    {
      '<leader>bD',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Bufdelete',
    },
    --------------
    -- Zen
    --------------
    {
      '<leader>zz',
      function()
        Snacks.zen()
      end,
      desc = 'Zen',
    },
    --------------
    -- Words
    --------------
    {
      '<leader>uw',
      function()
        Snacks.words.enable()
      end,
      desc = 'Words',
    },
    {
      '<leader>uW',
      function()
        Snacks.words.disable()
      end,
      desc = 'Words Disable',
    },
    --------------
    -- Dim
    --------------
    {
      '<leader>ud',
      function()
        Snacks.dim()
      end,
      desc = 'Dim',
    },
    {
      '<leader>uD',
      function()
        Snacks.dim.disable()
      end,
      desc = 'Dim Disable',
    },
    --------------
    -- LazyGit
    --------------
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'LazyGit',
    },
    --------------
    -- GitBrowse
    --------------
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'GitBrowse',
    },
    {
      '<leader>pa',
      function()
        Snacks.picker()
      end,
      desc = 'All Pickers',
    },
    --------------
    -- Pickers
    --------------
    {
      '<leader>sS',
      function()
        Snacks.picker.files()
      end,
      desc = 'Files (all)',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Files (in Git)',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent Files',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
  },
}
