return {
	"nvim-neotest/neotest",
	dependencies = { "haydenmeade/neotest-jest" },

	opts = function(_, opts)
		table.insert(
			opts.adapters,
			require("neotest-jest")({
				ignore_file_types = { "markdown" },
				jestCommand = "yarn test:unit",
				-- TODO: this ENV should be set by per project, currently allows to run yoshi tests locally (no sled)
				env = {
					CI = true,
					ARTIFACT_VERSION = "1.0.0",
					BUILD_ID = 123456789,
					agentType = "ci",
					GIT_REMOTE_URL = "git@github.com:some-org/some-repo.git",
					BUILD_VCS_NUMBER = "0123456789abcdef0123456789abcdef",
				},
				cwd = function()
					return vim.fn.getcwd()
				end,
			})
		)
	end,
}
