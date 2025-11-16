return {
  'A7Lavinraj/fyler.nvim',
  dependencies = { 'nvim-mini/mini.icons' },
  opts = {
    views = {
      finder = {
        close_on_select = false,
        win = {
          kinds = {
            split_left_most = {
              width = '15%',
              win_opts = {
                winfixwidth = true, -- keep the window width fixed when other windows resize
              },
            },
          },
          win_opts = {
            concealcursor = 'nvic',
            conceallevel = 3,
            cursorline = false,
            number = false,
            relativenumber = false,
            winhighlight = 'Normal:FylerNormal,NormalNC:FylerNormalNC',
            wrap = false,
          },
        },
      },
    },
  },
}
