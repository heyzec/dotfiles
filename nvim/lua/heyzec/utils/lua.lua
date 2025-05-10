local M = {}

-- Dump contents of object in a readable form
M.dump = function(o)
    -- Taken from https://stackoverflow.com/a/27028488
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Print and wait
M.debug = function(s)
    print(s)
    vim.fn.getchar()
end

return M
