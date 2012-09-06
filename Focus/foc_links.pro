FUNCTION FOC_LINKS, obsid, default
; custom find plot to link to
;  use obslist to determine path
;  return array of links

infile = './obslist'
links = strarr(n_elements(obsid))

;  get obsid right, pad with 0's
w = where(obsid lt 1000)
v = where(obsid lt 100)
u = where(obsid lt 10)
obs = strcompress(string(obsid), /remove_all)
if (w(0) ge 0) then obs(w) = '0'+obs(w)
if (v(0) ge 0) then obs(v) = '0'+obs(v)
if (u(0) ge 0) then obs(u) = '0'+obs(u)

readcol, infile, path, format='A', skipline=1

cmp = strarr(n_elements(path))
for i = 0, n_elements(path)-1 do begin
  tmp = strsplit(path(i), "/", /extract)
  cmp(i) = tmp(2)
endfor

for i=0, n_elements(obs)-1 do begin
  links(i) = default
  b = where(cmp eq obs(i))
  if (b(0) ge 0) then links(i) = path(b(0))+"/obsid_"+obs(i)+"_Sky_summary.html"
endfor
return, links
end
