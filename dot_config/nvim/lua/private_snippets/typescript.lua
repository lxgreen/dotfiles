-- As defining all of the snippet-constructors (s, c, t, ...) in every file is rather cumbersome,
-- luasnip will bring some globals into scope for executing these files.
-- defined by Snip in setup
require("luasnip.session.snippet_collection").clear_snippets("typescript")
require("luasnip.loaders.from_lua").lazy_load()

local s, f, t, i, c = Snip.snippet, Snip.fmt, Snip.text, Snip.insert, Snip.choise

return {
  s(
    "cl",
    f([[console.{method}({message}); // eslint-disable-line no-console]], {
      method = c(1, { t("log"), t("warn"), t("error"), t("debug") }),
      message = i(2, "message"),
    })
  ),
  s(
    "//t",
    f([[// {method}: {message}]], {
      method = c(1, { t("TODO"), t("FIXME"), t("NOTE") }),
      message = i(2, "message"),
    })
  ),
}
