local jobs = require("packer.jobs")
local a = require("packer.async")
local result = require("packer.result")
local await = a.wait
local async = a.sync
local fmt = string.format
local check_dependencies = require("utils").check_dependencies

check_dependencies({ "curl", "npm", "rg", { "fd", "fdfind" } })

local memo = { status = "" }

local function printerr(title, msg)
	vim.notify_once(msg, "error", { title = fmt("[Config] %s", title) })
end

local function warn(title, msg)
	vim.notify_once(msg, "warn", { title = fmt("[Config] %s", title) })
end

local function async_command(cmd, ignore_error)
	return async(function()
		local r = result.ok()
		local opts = { capture_output = true, cwd = CONFIG_PATH }
		r:and_then(await, jobs.run(cmd, opts))
			:map_err(function(err)
				if not ignore_error then
					printerr("Failed to update config.", fmt("%s:\n%s", cmd, err.output.data.stderr[1]))
				end
				return nil
			end)
			:map_ok(function(ok)
				return ok.output.data.stdout[1]
			end)

		return r.ok
	end)
end

local function remote_version()
	return await(async_command("git rev-parse @{u}"))
end

local function local_version()
	return await(async_command("git rev-parse @"))
end

local function merge_base()
	return await(async_command("git merge-base @ @{u}"))
end

local M = {}

function M.status()
	return memo.status
end

function _G.config_update()
	async(function()
		local has_update = await(update_check())
		if has_update == 0 then
			return
		elseif has_update == -1 then
			printerr("Local changes detected", "Update aborted!")
			return
		end

		vim.defer_fn(function()
			package.loaded["plugins"] = nil
			require("plugins").sync()
		end, 1000)
	end)()
end

return M
