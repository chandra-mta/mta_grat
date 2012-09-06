@/home/brad/Gratings/hak_1.4/hak_start

spawn, 'mkdir /data/mta/www/mta_grat/Mar03/4377'
obs_anal, 'acisf04377_000N001_evt1a.fits', $
        OUTPUT_PREFIX = 'obsid_4377', $
        OUT_DIR='/data/mta/www/mta_grat/Mar03/4377', $
        COORDS_NAME='Sky', /FLIPY, ROLLAXAY=-2.7806348684617E+02, $
        /OVERRIDE_ZERO, /ZBUFFER, OVERR_WIDTH=200.0, $
        /CENTER_FIT, $
        CD_WIDTH=0.5, /LINE, $
        GRATING='HETG', DETECTOR='ACIS-S', $
        ORDER_SEL_ACCURACY = 0.3, $
        /EXPORT
retall
exit
