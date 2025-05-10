return {
    'f-person/git-blame.nvim',
    opts = {
        -- message with a margin of 2 spaces
        message_template = "  <author> (<date>) • <summary>",
        date_format = "%r",  -- use relative date
        delay = 250,
    },
}
