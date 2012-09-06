@/home/mta/Gratings/hak_1.4/hak_start

spawn, 'mkdir /data/mta/www/mta_grat/Apr09/10677'
obs_anal, 'acisf10677_000N001_evt1a.fits', $
   OUTPUT_PREFIX = 'obsid_10677', $
   OUT_DIR='/data/mta/www/mta_grat/Apr09/10677', $
   COORDS_NAME='Sky', /FLIPY, ROLLAXAY=-77.157971531521, $
   /OVERRIDE_ZERO, /ZBUFFER, OVERR_WIDTH=200.0, $
   /CENTER_FIT, $
   ;CD_WIDTH=0.5, /LINE, $
   CD_WIDTH=0.5, $
   GRATING='HETG', DETECTOR='ACIS-S', $
   ORDER_SEL_ACCURACY = 0.3, $
   /EXPORT
retall
exit
