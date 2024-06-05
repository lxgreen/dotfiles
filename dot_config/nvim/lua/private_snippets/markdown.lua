-- As defining all of the snippet-constructors (s, c, t, ...) in every file is rather cumbersome,
-- luasnip will bring some globals into scope for executing these files.
-- defined by Snip in setup
require("luasnip.session.snippet_collection").clear_snippets("markdown")
require("luasnip.loaders.from_lua").lazy_load()

local s, f, t, i, c = Snip.snippet, Snip.fmt, Snip.text, Snip.insert, Snip.choise

return {
  s(
    "bkl",
    f(
      [[
---

backlink: {link}
]],
      {
        link = i(1, "link"),
      }
    )
  ),
  s(
    "ts",
    f(
      [[```{method}
{message}
```]],
      {
        method = c(1, { t("ts"), t("sh"), t("haskell"), t("json"), t("lua"), t("vim") }),
        message = i(2, "message"),
      }
    )
  ),
}
