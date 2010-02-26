--load the data
io.input('packages.html')
s = io.read("*all")
io.close()
io.input('Portfile-proto')
proto = io.read("*all")
io.close()

-- build indexes
t={}
local i=1 while s:find("<div", i) do
_, i = s:find("<div", i)
table.insert(t, {starts=_, ends = i} )
end

-- build description fields
oct={}
local raw, j, k, _ for i=1, #t do
 --declare n-th item as table to host our fields
 oct[i]= {}
 
 --raw description for every item, it involves i-th and (i+1)-th element so we have to check that i<#t
 if i~=#t then oct[i].raw = string.sub(s, t[i].starts, t[i+1].starts-1)
 else oct[i].raw = string.sub(s, t[i].starts, string.len(s) ) end
 raw = oct[i].raw
  
 --name of portfile, we will add "octave-" later
 _,j = string.find(raw, "/>")
 k = string.find(raw, "</a><")
 oct[i].name = string.lower(string.sub(raw, j+2,k-1))
 
 --index ports with name too
 oct[oct[i].name] = oct[i]
 
 --here we go
 oct[i].dirname = "octave-" .. oct[i].name
 
 --deps will be read from external file
 oct[i].deps = {}
 
 --download url
 _,j = string.find(raw, 'link" href="')
 k = string.find(raw, '"', j+1)
 oct[i].down = string.sub(raw, j+1, k-1)
 
 --description
 _,j = string.find(raw, 'none;">')
 k = string.find(raw,"</p>")
 oct[i].desc = string.gsub(string.sub(raw, j+1, k-1),"[\r\n]",'')

 --match version number from download url
 oct[i].vers = oct[i].down:match('sourceforge%.net/.*%-(.*%d)%.') 

 --filename from download url
 oct[i].filename =  oct[i].down:match('sourceforge%.net/.*/(.*)%?')
end

--read dependecies
dofile('dependencies.lua')

for i=1, #oct do
 --check if package is disabled
 if not oct[i].disabled then
 --checksum
 local file = io.open(oct[i].filename, "r")
  if (not file) then os.execute('wget "' .. oct[i].down .. '"') 
 else io.close(file) end
  oct[i].check = io.popen("checksum " .. oct[i].filename):read("*all") 


 --finally let's assemble the portfile
 oct[i].port = proto
 oct[i].port = oct[i].port:gsub('NAME', oct[i].dirname, 1)
 oct[i].port = oct[i].port:gsub('VERS', oct[i].vers, 1)
 oct[i].port = oct[i].port:gsub('DESC', oct[i].desc, 1)
 oct[i].port = oct[i].port:gsub('DSTN', oct[i].name .. '-' .. oct[i].vers, 1)
 oct[i].port = oct[i].port:gsub('CHKS', oct[i].check, 1)
 oct[i].port = oct[i].port:gsub('LVCK', oct[i].name, 1)
 
 deps=nil
 if #oct[i].deps > 0 then deps = ''
  for k,v in pairs(oct[i].deps) do
   deps = deps .. " \\\n\t\t\t\tport:" .. v end
 end
 oct[i].port = oct[i].port:gsub('DEPS', deps or '', 1) .. "\n"
 oct[i].portfile = oct[i].port 
 end
end


for i in ipairs(oct) do
 --give simple names to fields
 disabled = oct[i].disabled
 if not disabled then
  name = oct[i].name
  vers = oct[i].vers
  desc = oct[i].desc
  down = oct[i].down
  check = oct[i].check
  dirname = oct[i].dirname
  portfile = oct[i].portfile
 
  --let's build the tree on filesystem
  os.execute("mkdir " .. dirname)
  f = io.output(dirname .. "/Portfile")
  io.write(portfile)
  io.close(f)
 end
end
