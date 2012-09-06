PRO foc, PLOTX=plotx

; only show values within cut sigma of mean
cut = 3

; how many plots on a page
npanes = 2

; charsize for plots
csize=1.5

label_list = ['acis_letg', 'acis_hetg', 'hrc_letg']

; array for summary stats
stats=fltarr(n_elements(label_list), 2)

break = 0  ; n_elements for html_map

for j = 0, n_elements(label_list) - 1 do begin
  file = 'foc_'+label_list(j)+'.txt'
  print, 'Working '+file
  ; ACIS_HETG
  ; figure num lines input
  xnum = strarr(1)
  command = 'wc -l '+file
  spawn, command, xnum
  xxnum = fltarr(2)
  xxnum = strsplit(xnum(0),' ', /extract)
  numlns = float(xxnum(0))

  get_lun, inunit
  openr, inunit, file
  
  array = strarr(numlns)
  readf, inunit, array
  free_lun, inunit

  times = fltarr(1)
  obsid = intarr(1)
  ax10 = fltarr(1)
  ax50 = fltarr(1)
  axfit = fltarr(1)
  axerr = fltarr(1)
  st10 = fltarr(1)
  st50 = fltarr(1)
  stfit = fltarr(1)
  sterr = fltarr(1)

  streak = 0 ; have not found measurements of streak width yet
  for i = 0, numlns - 1 do begin
    tmp = strarr(11)
    tmp = strsplit(array(i), '_', /extract)
    obsid = [obsid, fix(tmp(1))]
    tmp = strsplit(array(i+1), ' ', /extract)
    times = [times, float(tmp(3))]
    tmp = strsplit(array(i+2), ' ', /extract)
    if (tmp(2) eq "AX") then begin
      ax10 = [ax10, float(tmp(9))]
      tmp = strsplit(array(i+3), ' ', /extract)
      ax50 = [ax50, float(tmp(9))]
    endif
    tmp = strsplit(array(i+4), ' ', /extract)
    if (tmp(2) eq "Streak") then begin
      streak = 1
      st10 = [st10, float(tmp(9))]
      tmp = strsplit(array(i+5), ' ', /extract)
      st50 = [st50, float(tmp(9))]
      tmp = strsplit(array(i+6), ' ', /extract)
      axfit = [axfit, float(tmp(4))]
      tmp = strsplit(array(i+7), ' ', /extract)
      stfit = [stfit, float(tmp(4))]
      tmp = strsplit(array(i+8), ' ', /extract)
      axerr = [axerr, float(tmp(3))]
      tmp = strsplit(array(i+9), ' ', /extract)
      sterr = [sterr, float(tmp(3))]
      i = i + 9
    endif else begin  ; streak analysis is missing (HRC)
      axfit = [axfit, float(tmp(4))]
      tmp = strsplit(array(i+5), ' ', /extract)
      axerr = [axerr, float(tmp(3))]
      st10 = [st10, 0]
      st50 = [st50, 0]
      stfit = [stfit, 0]
      sterr = [sterr, 0]
      i = i + 5
    endelse
  endfor

  ; delete first dummy element, and extended sources
  if (streak eq 0) then begin
    b = where(axfit gt 0 and axfit lt 100)
  endif else begin
    b = where(axfit gt 0 and axfit lt 100 and stfit gt 0 and stfit lt 100)
  endelse
  print, n_elements(axfit), n_elements(b)
  times = times(b)
  obsid = obsid(b)
  ax10 = ax10(b)
  ax50 = ax50(b)
  axfit = axfit(b)
  axerr = axerr(b)
  st10 = st10(b)
  st50 = st50(b)
  stfit = stfit(b)
  sterr = sterr(b)

  ; sort by time
  s = sort(times)
  times = times(s)
  obsid = obsid(s)
  ax10 = ax10(s)
  ax50 = ax50(s)
  axfit = axfit(s)
  axerr = axerr(s)
  st10 = st10(s)
  st50 = st50(s)
  stfit = stfit(s)
  sterr = sterr(s)

  ;print, times  ;debug
  ;print, stfit  ;debug
  ;print, n_elements(stfit)  ;debug
  ;print, n_elements(axfit)  ;debug
  ;print, n_elements(times)  ;debug
  
  xwidth=750
  yheight=npanes*300
  if (keyword_set(plotx)) then begin
    set_plot, 'X'
    window, 0, xsize=xwidth, ysize=yheight
  endif else begin
    set_plot, 'Z'
    device, set_resolution = [xwidth, yheight]
  endelse

  !p.multi = [0,1,npanes,0,0]
  loadct, 39
  white = 255
  bgrd = 0
  color1 = 230
  color2 = 190
  color3 = 100
  ;color1 = 140
  ;color2 = 110
  ;color3 = 80

  xmin = min(sdom(times))
  xmax = max(sdom(times))
  xmin = xmin - 0.1*(xmax-xmin)
  xmax = xmax + 0.1*(xmax-xmin)
  if (streak gt 0) then begin
    m = moment(st10)
    ;old ymax = min([max([st10, st50, stfit]), m(0)+cut*m(1)])
    ;old ymin = max([min([st10, st50, stfit]), m(0)-cut*m(1)])
    ;print, ymin, ymax  ; debug
    ;ymin = 0
    ;old ymin = ymin - 0.1*(ymax-ymin)
    ;old ymax = ymax + 0.1*(ymax-ymin)
    ;print, ymin  ; debug
    ;old plot, sdom(times), st10, psym = 1, xstyle=1, ystyle=1, charsize=csize, $
          ;old xtitle='Time (DOM)', ytitle='Width (microns)', $
          ;old title=strupcase(label_list(j))+' Streak', $
          ;old xrange=[xmin, xmax], yrange=[ymin, ymax], /nodata, $
          ;old xmargin=[10,32] 
    ;old oplot, sdom(times), st10, psym = 1, color=color1
    ;old sfit=myfit(sdom(times), st10, cut)
    ;old oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color1
    ;old xyouts, 1.0, 0.9, 'Streak LRF at 10% of peak', alignment=1, /normal, color=color1
    ;old xyouts, 1.0, 0.88, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color1
    ;old oplot, sdom(times), st50, psym = 1, color=color2
    ;old sfit=myfit(sdom(times), st50, cut)
    ;old oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color2
    ;old xyouts, 1.0, 0.85, 'Streak LRF at 50% of peak', alignment=1, /normal, color=color2
    ;old xyouts, 1.0, 0.83, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color2
    ;old oplot, sdom(times), stfit, psym = 1, color=color3
    ;old color0=!P.COLOR
    ;old !P.COLOR=color3
    ;old errplot, sdom(times), stfit-sterr, stfit+sterr
    ;old !P.COLOR=color0
    ;old sfit=myfit(sdom(times), stfit, cut)
    ;old oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color3
    ;old xyouts, 1.0, 0.8, 'Gaussian fit FWHM', alignment=1, /normal, color=color3
    ;old xyouts, 1.0, 0.78, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color3

    ; same as above, but zoomed in
    ymax=80
    ymin=0
    ;print, ymin  ; debug
    plot, sdom(times), st10, psym = 1, xstyle=1, ystyle=1, charsize=csize, $
          xtitle='Time (DOM)', ytitle='Width (microns)', $
          ;old title=strupcase(label_list(j))+' Streak - Zoomed', $
          title=strupcase(label_list(j))+' Streak', $
          xrange=[xmin, xmax], yrange=[ymin, ymax], /nodata, $
          xmargin=[10,18] 
    ;old oplot, sdom(times), st10, psym = 1, color=color1
    ;old sfit=myfit(sdom(times), st10, cut)
    ;old oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color1
    ;old xyouts, 1.0, 0.6, 'Streak LRF at 10% of peak', alignment=1, /normal, color=color1
    ;old xyouts, 1.0, 0.58, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color1
    oplot, sdom(times), st50, psym = 1, color=color2
    sfit=myfit(sdom(times), st50, cut)
    oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color2
    xyouts, 1.0, 0.75, 'Streak LRF at 50% of peak', alignment=1, /normal, color=color2
    xyouts, 1.0, 0.73, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color2
    oplot, sdom(times), stfit, psym = 1, color=color3
    sfit=myfit(sdom(times), stfit, cut)
    color0=!P.COLOR
    !P.COLOR=color3
    errplot, sdom(times), stfit-sterr, stfit+sterr
    !P.COLOR=color0
    stats(j,0) = sfit(1)*365  ; save value for web page
    oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color3
    xyouts, 1.0, 0.7, 'Gaussian fit FWHM', alignment=1, /normal, color=color3
    xyouts, 1.0, 0.68, strcompress('delta '+string(sfit(1)*365))+' microns/yr', alignment=1, /normal, color=color3
    
    ; get device coords for map later
    
    map1 = flipy4map(convert_coord([sdom(times),sdom(times)],[st10,st50], $
                     /to_device), yheight)
    break = n_elements(map1)/3

  endif

  ; set start place for labels
  label=0.9-(streak*2*0.3)
  m = moment(ax10)
  ymax = min([max([ax10, ax50, axfit]), m(0)+cut*m(1)])
  ymin = max([min([ax10, ax50, axfit]), m(0)-cut*m(1)])
  ;ymin = 0
  ;ymax = max([ax10, ax50, axfit])
  ymin = ymin - 0.1*(ymax-ymin)
  ymax = ymax + 0.1*(ymax-ymin)
  plot, sdom(times), ax10, psym = 1, xstyle=1, ystyle=1, charsize=csize, $
        xtitle='Time (DOM)', ytitle='Width (microns)', $
        title=strupcase(label_list(j))+' Zero Order Image', $
        xrange=[xmin, xmax], yrange=[ymin, ymax], /nodata, $
        xmargin=[10,18] 
  oplot, sdom(times), ax10, psym = 1, color=color1
  sfit=myfit(sdom(times), ax10, cut)
  oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color1
  xyouts, 1.0, label, 'AX LRF at 10% of peak', alignment=1, /normal, color=color1
  xyouts, 1.0, label-0.02, strcompress('delta '+string(sfit(1)*365)+' microns/yr'), alignment=1, /normal, color=color1
  oplot, sdom(times), ax50, psym = 1, color=color2
  sfit=myfit(sdom(times), ax50, cut)
  oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color2
  xyouts, 1.0, label-0.05, 'AX LRF at 50% of peak', alignment=1, /normal, color=color2
  xyouts, 1.0, label-0.07, strcompress('delta '+string(sfit(1)*365)+' microns/yr'), alignment=1, /normal, color=color2
  oplot, sdom(times), axfit, psym = 1, color=color3
  color0=!P.COLOR
  !P.COLOR=color3
  errplot, sdom(times), axfit-axerr, axfit+axerr
  !P.COLOR=color0
  sfit=myfit(sdom(times), axfit, cut)
  stats(j,1) = sfit(1)*365  ; save value for web page
  oplot, sdom(times), sdom(times)*sfit(1)+sfit(0), color=color3
  xyouts, 1.0, label-0.10, 'Gaussian fit FWHM', alignment=1, /normal, color=color3
  xyouts, 1.0, label-0.12, strcompress('delta '+string(sfit(1)*365)+' microns/yr'), alignment=1, /normal, color=color3
  
  xyouts, 1.0, 0.0, systime(), alignment = 1, /normal
  img_name =  'foc_'+label_list(j)+'.gif'
  htm_name =  'foc_'+label_list(j)+'.html'
  write_gif, img_name, tvrd()

  x=where(obsid eq 3381)  ;debug
  if (x(0) ge 0) then begin
    print, sdom(times(x(0)))
    print, ax10(x(0))
  endif
  map2 = intarr(3, 3*n_elements(times))
  map2 = flipy4map(convert_coord([sdom(times),sdom(times),sdom(times)], $
                                 [ax10,ax50,axfit], /to_device),yheight)

  map = intarr(3,break+n_elements(map2)/3)
  if (break gt 0) then begin
    map[0:2,0:break-1] = map1
    map[0:2,break:*] = map2
  endif else begin
    map = map2
  endelse
  link_to = foc_links(obsid, htm_name)
  ;html_map, map, replicate(img_name,n_elements(map)/3), $
  html_map, map, [link_to,link_to,link_to,link_to,link_to], $
            strcompress("OBSID: "+string([obsid,obsid,obsid,obsid,obsid])), $
            htm_name, img_name

  !p.multi = [0,1,npanes,0,0] ; reset, in case there is no streak plot
endfor

; make web page
webfile = 'index.html'
tmpfile = 'temp.html'
get_lun, iunit
; figure num lines input
xnum = strarr(1)
spawn, 'wc -l '+webfile, xnum
xxnum = fltarr(2)
xxnum = strsplit(xnum(0),' ', /extract)
numlns = long(xxnum(0))

openr, iunit, webfile

array = strarr(numlns)
readf, iunit, array

free_lun, iunit

get_lun, ounit
openw, ounit, tmpfile

data_sec = 0 ; have not found data section yet

for i = 0, numlns-1 do begin
  if (strpos(array(i), '<!-- start data table -->') ge 0) then begin
    data_sec = 1
    printf, ounit, '<!-- start data table -->'
    printf, ounit, '<table border=1>'
    printf, ounit, '<tr align=center>'
    for j = 0, n_elements(label_list)-1 do begin
      printf, ounit, '<th colspan=2><a href="'+label_list(j)+'.html">'+strupcase(label_list(j))+'</a></th>'
    endfor
    printf, ounit, '</tr>'
    printf, ounit, '<tr align=center>'
    for j = 0, n_elements(label_list)-1 do begin
      printf, ounit, '<td colspan=1><font color=#00DDFF>'+string(stats(j,0))+'</font></td>'
      printf, ounit, '<td colspan=1><font color=#00DDFF>'+string(stats(j,1))+'</font></td>'
    endfor
    printf, ounit, '</tr>'
    printf, ounit, '<tr align=center>'
    for j = 0, n_elements(label_list)-1 do begin
      printf, ounit, '<td colspan=1>Streak trend</td>'
      printf, ounit, '<td colspan=1>Image trend</td>'
    endfor
    printf, ounit, '</tr>
    printf, ounit, '<tr align=center><td colspan=6>microns/year</td></tr>
    printf, ounit, '</table>
  endif

  if (strpos(array(i), '<!-- end data table -->') ge 0) then begin
    data_sec=0
  endif

  if (strpos(array(i), '<!-- start time stamp -->') ge 0) then begin
    data_sec = 1
    printf, ounit, "<!-- start time stamp -->"
    printf, ounit, "Last updated: "+systime()
  endif

  if (strpos(array(i), '<!-- end time stamp -->') ge 0) then begin
    data_sec = 0
  endif

  if (data_sec eq 0) then begin  ; not in data section, so copy old file
    printf, ounit, array(i)
  endif
endfor

free_lun, ounit

spawn, 'mv '+tmpfile+' '+webfile

end
