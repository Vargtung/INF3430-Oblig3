vcom -work work -2002 -explicit -stats=none tb_pos_seg7_ctrl.vhd
vcom -work work -2002 -explicit -stats=none pos_ctrl.vhd
vcom -work work -2002 -explicit -stats=none p_ctrl.vhd
vcom -work work -2002 -explicit -stats=none pos_meas.vhd
vcom -work work -2002 -explicit -stats=none motor_ent.vhd
vcom -work work -2002 -explicit -stats=none motor_beh.vhd
vcom -work work -2002 -explicit -stats=none CRU.vhd
vcom -work work -2002 -explicit -stats=none rstsynch.vhd
vcom -work work -2002 -explicit -stats=none seg7ctrl.vhd
vcom -work work -2002 -explicit -stats=none clkdiv.vhd
vcom -work work -2002 -explicit -stats=none decoder.vhd
vcom -work work -2002 -explicit -stats=none pos_seg7_ctrl.vhd

vsim work.tb_pos_seg7_ctrl

add wave *

run 20000 us
