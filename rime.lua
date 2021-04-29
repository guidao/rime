
require "bihua_map"
function date_translator(input, seg)
   if (input == "orq") then
      --- Candidate(type, start, end, text, comment)
      yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " "))
   end
end

function time_translator(input, seg)
   if (input == "ouj") then
      local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M"), " ")
      cand.quality = 1
      yield(cand)
   end
end


function single_char_first_filter(input)
   local l = {}
   local s = {}
   for cand in input:iter() do
      if (utf8.len(cand.text) == 1) then
	 table.insert(s, cand)
      else
         table.insert(l, cand)
      end
   end
   if #s > 0 then
      table.sort(s, function(a, b)
        local a_num = get_stroke_num(a.text)
	local b_num = get_stroke_num(b.text)
	return a_num < b_num
      end)
   end
   
   for i, cand in ipairs(s) do
      yield(cand)
   end

   for i, cand in ipairs(l) do
      yield(cand)
   end
end



function get_stroke_num(c)
   local num = bihua[c]
   if num == nil then
      return 100
   end
   return num
end

