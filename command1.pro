@/home/brad/Gratings/hak_1.4/hak_start

spawn, 'mkdir /data/mta/www/mta_grat/Sep08/10761'
obs_anal, 'hrcf10761_000N001_evt1a.fits', $
        OUTPUT_PREFIX = 'obsid_10761', $
        OUT_DIR='/data/mta/www/mta_grat/Sep08/10761', $
        COORDS_NAME='Sky', /FLIPY, ROLLAXAY=-353.27015078885, $
        /OVERRIDE_ZERO, /ZBUFFER, OVERR_WIDTH=200.0, $
        /CENTER_FIT, $
        CD_WIDTH=0.5, /LINE, $
        GRATING='LETG', DETECTOR='HRC-S', $
        ORDER_SEL_ACCURACY = 0.3, $
        /EXPORT
retall
spawn, 'mkdir /data/mta/www/mta_grat/Sep08/10762'
obs_anal, 'hrcf10762_000N001_evt1a.fits', $
        OUTPUT_PREFIX = 'obsid_10762', $
        OUT_DIR='/data/mta/www/mta_grat/Sep08/10762', $
        COORDS_NAME='Sky', /FLIPY, ROLLAXAY=-353.27013648278, $
        /OVERRIDE_ZERO, /ZBUFFER, OVERR_WIDTH=200.0, $
        /CENTER_FIT, $
        CD_WIDTH=0.5, /LINE, $
        GRATING='LETG', DETECTOR='HRC-S', $
        ORDER_SEL_ACCURACY = 0.3, $
        /EXPORT
retall
exit
