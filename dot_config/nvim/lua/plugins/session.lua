return {
  "echasnovski/mini.sessions",
  opts = {
    autoread = true,
  },
  config = function()
    require("mini.sessions").setup({
      autoread = true,
    })
  end,
}
