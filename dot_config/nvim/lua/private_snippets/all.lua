-- As defining all of the snippet-constructors (s, c, t, ...) in every file is rather cumbersome,
-- luasnip will bring some globals into scope for executing these files.
-- defined by Snip in setup
require("luasnip.session.snippet_collection").clear_snippets()
require("luasnip.loaders.from_lua").lazy_load()

local snippet, partial = Snip.snippet, Snip.partial

return {
  snippet("day", partial(os.date, "%b %d, %Y")),
}
