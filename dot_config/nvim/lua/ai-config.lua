local config = {
  -- example hook functions (see Extend functionality section in the README)
  hooks = {
    InspectPlugin = function(plugin, params)
      local bufnr = vim.api.nvim_create_buf(false, true)
      local copy = vim.deepcopy(plugin)
      local key = copy.config.openai_api_key
      copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
      local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
      local params_info = string.format("Command params:\n%s", vim.inspect(params))
      local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.api.nvim_win_set_buf(0, bufnr)
    end,

    -- GpImplement rewrites the provided selection/range based on comments in it
    Implement = function(gp, params)
      local template = "Having following from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please rewrite this according to the contained instructions."
        .. "\n\nRespond exclusively with the snippet that should replace the selection above."

      local agent = gp.get_command_agent()
      gp.info("Implementing selection with agent: " .. agent.name)

      gp.Prompt(
        params,
        gp.Target.rewrite,
        nil, -- command will run directly without any prompting for user input
        agent.model,
        template,
        agent.system_prompt
      )
    end,

    -- your own functions can go here, see README for more examples like
    -- :GpExplain, :GpUnitTests.., :GpTranslator etc.

    -- example of making :%GpChatNew a dedicated command which
    -- opens new chat with the entire current buffer as a context
    BufferChatNew = function(gp, _)
      -- call GpChatNew command in range mode on whole buffer
      vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
    end,

    -- example of adding command which opens new chat dedicated for translation
    Translator = function(gp, params)
      local agent = gp.get_command_agent()
      local chat_system_prompt = "You are a Translator, please translate between English and Russian."
      gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
    end,

    -- write jest unit tests for the selected code (TS)
    UnitTests = function(gp, params)
      -- Get the current buffer name (file path)
      local buffer_name = vim.api.nvim_buf_get_name(0)

      if string.match(buffer_name, "%.tsx?$") then
        -- Create the new file name with .spec.tsx suffix
        local new_file_name = buffer_name:gsub("%.tsx?$", ".spec.tsx")

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = { "GpDone" },
          callback = function(event)
            -- [Over]Write the new file
            vim.api.nvim_command("write! " .. vim.fn.fnameescape(new_file_name))
          end,
          once = true,
        })
        local template = "I have the following code from {{filename}}:\n\n"
          .. "```{{filetype}}\n{{selection}}\n```\n\n"
          .. "Please respond by writing jest based unit tests for the code above."
          .. "###Instruction###\n Consider yourself as a jest test bot with deep TS/JS expertise. Your audience is professional developers.\n\n"
          .. "###Task###\n 1. Generate jest unit tests for this code.\n 2.DELETE the code above.\n3. DO NOT repeat the code!!!\n"
        local agent = gp.get_command_agent()
        gp.Prompt(params, gp.Target.eNew, nil, agent.model, template, agent.system_prompt)
      end
    end,

    JsDoc = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "###Instruction###\n Consider yourself as a jsdoc bot with deep TS/JS expertise. Your audience is professional developers.\n\n"
        .. "###Task###\n 1. Generate JSDoc documntation comment using the template:\n\n\t@param {type} name - description\n\t@returns {type} - description\n\n\tExample:\n\n\t\tusage example.\n 2.DELETE the code above.\n3. DO NOT repeat the code!!!\n"
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.prepend, nil, agent.model, template, agent.system_prompt)
    end,

    Log = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "###Instruction###\n Consider yourself as an TS/JS expert. Your audience is professional developers.\n\n"
        .. "###Task###\n 1. Rewrite the code above, appending `console.debug` statements AFTER each variable defined in the code:\n\n"
        .. "If the variable is an object, print its keys and values.\n\n"
        .. "If the variable is an array, print its values. \n\nIf the variable is a primitive, print its value.\n\n"
        .. "2. If there's a return value, print it as well.\n\n"
        .. "3. If there are arguments, print them as well.\n\n"
        .. "4. Every `console.debug` statement should contain variable name, or argument name, or 'return value', followed by TS type name where applicable.\n\n"
        .. "5. append `// eslint-disable-line no-console` to each console.debug statement\n\n"
        .. "Examlpe:\n\n"
        .. "consider the following code: `const x = 5;`\n"
        .. "The output should be: `x: number = 5;\nconsole.debug('x (number)', x); // eslint-disable-line no-console\n`"
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
    end,

    Unlog = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "###Instruction###\n Consider yourself as an TS/JS expert. Your audience is professional developers.\n\n"
        .. "###Task###\n 1. Rewrite the code above, DELETE every `console.debug` statements found in the code\n\n"
        .. "2. If there's a return value saved in variable for logging only, remove it and return value with `return` statement.\n\n"
        .. "3. If there are variables defined for logging only, remove them as well.\n\n"
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
    end,

    GitCommitMessage = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please respond by writing a git commit message for the code above."
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.prepend, nil, agent.model, template, agent.system_prompt)
    end,

    -- example of adding command which explains the selected code
    Explain = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please respond by explaining the code above."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
    end,
  },
}

return config
