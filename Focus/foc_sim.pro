PRO foc_sim, PLOTX=plotx

; plot zero order widths vs. sim attach point temperatures

sim=mrdfits('/data/mta/Script/Deriv/simtemp1.fits',1)

; only show values within cut sigma of mean
cut = 10

; how many plots on a page
npanes = 2

; charsize for plots
csize=1.0
lab_size=0.7

; constants
speryr=31536000.0

label_list = ['acis_letg', 'acis_hetg', 'hrc_letg']

; array for summary stats
stats=fltarr(n_elements(label_list), 2)

for j = 0, n_elements(label_list) - 1 do begin
  break = 0  ; n_elements for html_map
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
  ; attach point temps
  att1 = fltarr(1)
  att2 = fltarr(1)
  att3 = fltarr(1)

  streak = 0 ; have not found measurements of streak width yet
  for i = 0, numlns - 1 do begin
    tmp = strarr(11)
    tmp = strsplit(array(i), '_', /extract)
    obsid = [obsid, fix(tmp(1))]
    tmp = strsplit(array(i+1), ' ', /extract)
    time_sec = float(tmp(3))
    times = [times, time_sec]
    ; use time somewhat after start time to look up temperature
    time_comp = time_sec+10000
    time_diff=abs(sim.time-time_comp)
    b=where(time_diff eq min(time_diff))
    att1=[att1,sim(b(0)).X3TTACS1T_AVG]
    att2=[att2,sim(b(0)).X3TTACS2T_AVG]
    att3=[att3,sim(b(0)).X3TTACS3T_AVG]
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
    c=[0,1]
  endif else begin
    b = where(axfit gt 0 and axfit lt 100)
    c = where(stfit gt 0 and stfit lt 100)
  endelse
  print, n_elements(axfit), n_elements(b)
  timesa = times(b)
  obsida = obsid(b)
  ax10 = ax10(b)
  ax50 = ax50(b)
  axfit = axfit(b)
  axerr = axerr(b)
  timest = times(c)
  obsidt = obsid(c)
  st10 = st10(c)
  st50 = st50(c)
  stfit = stfit(c)
  sterr = sterr(c)
  att1 = att1(c)
  att2 = att2(c)
  att3 = att3(c)

  set_plot,'ps'
  !p.multi = [0,1,3,0,0]
  device,filename='foc_sim_'+label_list(j)+'.ps',/port,xsize=8,ysize=10, $
         xoff=0,yoff=0,/inches
  loadct, 39
  white = 255
  bgrd = 0
  color1 = 230
  color2 = 190
  color3 = 100

  b = where(axerr lt 50)
  plot, att1(b), axfit(b), psym = 1,xtitle='3TTACS1T (K)',$
        ytitle='AXFIT FWHM (microns)', $
        title=label_list(j), $
        xrange=[250,280],xstyle=1,chars=1.6
  plot, att2(b), axfit(b), psym = 1,xtitle='3TTACS2T (K)',$
        ytitle='AXFIT FWHM (microns)', $
        xrange=[250,280],xstyle=1,chars=1.6
  plot, att3(b), axfit(b), psym = 1,xtitle='3TTACS3T (K)', $
        ytitle='AXFIT FWHM (microns)', $
        xrange=[250,280],xstyle=1,chars=1.6
  ;write_gif,'foc_sim'+label_list(j)+'.gif',tvrd()
  device,/close


endfor

end
