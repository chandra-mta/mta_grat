; IDL Version 5.3 (sunos sparc)
; Journal File for mta@rhodes
; Working directory: /data/mta/Script/Deriv
; Date: Wed Jul  5 16:43:06 2006
 
sim=mrdfits('simtemp1.fits',1)
;MRDFITS: Binary table.  19 columns by  64123 rows.
print,tag_names(sim)
;TIME X3BTU_BPT_AVG X3FABRAAT_AVG X3FABRCAT_AVG X3FAMYZAT_AVG X3FAPYZAT_AVG
; X3FARALAT_AVG X3FLCABPT_AVG X3RCTUBPT_AVG X3TSMXCET_AVG X3TSMXSPT_AVG
; X3TSMYDPT_AVG X3TSPYFET_AVG X3TSPZDET_AVG X3TSPZSPT_AVG X3TTACS1T_AVG
; X3TTACS2T_AVG X3TTACS3T_AVG X3TTBRGBT_AVG
loadct,39
; % Unsupported X Windows visual (class: DirectColor, depth: 24).
;   Substituting default (class: TrueColor, Depth: 24).
plot,sim.time,sim.X3TTACS2T_AVG,/no_data,ystyle=1
; % Keyword NO_DATA not allowed in call to: PLOT
plot,sim.time,sim.X3TTACS2T_AVG,/nodata,ystyle=1
plot,sim.time,sim.X3TTACS2T_AVG,/nodata,ystyle=1,xstyle=1
oplot,sim.time,sim.X3TTACS2T_AVG,color=50,psym=2
plot,sim.time,sim.X3TTACS2T_AVG,/nodata,ystyle=1,xstyle=1, $
print,min(sim.X3TTACS2T_AVG)
; % PLOT: Incorrect number of arguments.
print,min(sim.X3TTACS2T_AVG)
;       0.0000000
print,max(sim.X3TTACS2T_AVG)
;       292.44476
plot,sim.time,sim.X3TTACS2T_AVG,/nodata,ystyle=1,xstyle=1, $
yrange=[250,300]
oplot,sim.time,sim.X3TTACS2T_AVG,color=50,psym=2
oplot,sim.time,sim.X3TTACS1T_AVG,color=110,psym=2
oplot,sim.time,sim.X3TTACS3T_AVG,color=210,psym=2
write_gif,'sim_attach.gif',tvrd()
