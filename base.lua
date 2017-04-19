serpent = (loadfile "serpent.lua")()
tdcli = dofile('tdcli.lua')
redis = (loadfile "redis.lua")()
sirads_id = "sirads-ID"

function vardump(value)
  return serpent.block(value,{comment=false})
end

function reload()
  sirads = dofile("sirads.lua")
end

function dl_cb (arg, data)
end

reload()

function tdcli_update_callback(data)
  update(data, sirads_id)
  if data.message_ and data.message_.content_.text_ and data.message_.content_.text_ == "/reload" and data.message_.sender_user_id_ == tonumber(redis:get("sirads:" .. sirads_id ..":fullsudo")) then
    reload()
    tdcli.sendMessage(data.message_.chat_id_, 0, 1, "*Bot Reloaded*", 1, "md")
  elseif data.message_ and data.message_.content_.text_ and data.message_.content_.text_ == "/gitpull" and data.message_.sender_user_id_ == tonumber(redis:get("sirads:" .. sirads_id ..":fullsudo")) then
    io.popen("git fetch --all && git reset --hard origin/master && git pull origin master"):read("*all")
     io.popen("chmod 777 anticrash.sh"):read("*all")
    reload()
    tdcli.sendMessage(data.message_.chat_id_, 0, 1, "*Updates Received And Bot Reloaded*", 1, "md")
  end
end
