redis = (loadfile "redis.lua")()
function getsiradsid()
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls')
	local last = 0
    for filename in pfile:lines() do
        if filename:match('sirads%-(%d+)%.lua') and tonumber(filename:match('sirads%-(%d+)%.lua')) >= last then
			last = tonumber(filename:match('sirads%-(%d+)%.lua')) + 1
			end		
    end
    return last
end
local last = getsiradsid()
io.write("Auto Detected sirads ID : "..last)
io.write("\nEnter Full Sudo ID : ")
local sudo=io.read()
local text,ok = io.open("base.lua",'r'):read('*a'):gsub("sirads%-ID",last)
io.open("sirads-"..last..".lua",'w'):write(text):close()
io.open("sirads-"..last..".sh",'w'):write("while true; do\n$(dirname $0)/telegram-cli-1222 -p sirads-"..last.." -s sirads-"..last..".lua\ndone"):close()
io.popen("chmod 777 sirads-"..last..".sh")
redis:set('sirads:'..last..':fullsudo',sudo)
print("Done!\nNew sirads Created...\nID : "..last.."\nFull Sudo : "..sudo.."\nRun : ./sirads-"..last..".sh")
