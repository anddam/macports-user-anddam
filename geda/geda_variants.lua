template=[[
variant no_VARIANTNAME description "don't install PHOLD" {
    depends_run-delete port:PHOLD
}
]]

a={}
io.input("lista")
while true do
  local line = io.read()
  if line == nil then break end
  table.insert(a,line)
end

for k,v in ipairs(a) do
    variant=template
    variant=string.gsub(variant,"VARIANTNAME", string.gsub(v,"-","_") or v)
    variant=string.gsub(variant,"PHOLD",v)
    print(variant)
end