return {
	"robitx/gp.nvim",
	config = function()
		local conf = {
			providers = {
				openai = {
					endpoint = "https://api.openai.com/v1/chat/completions",
					secret = os.getenv("OPENAI_API_KEY"),
				},
			}
		}
		require("gp").setup(conf)
		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	end,
}
