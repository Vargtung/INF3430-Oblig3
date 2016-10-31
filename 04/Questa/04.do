vcom -work work -2002 -explicit -stats=none tb_pos_ctrl.vhd
vcom -work work -2002 -explicit -stats=none pos_ctrl.vhd
vcom -work work -2002 -explicit -stats=none p_ctrl.vhd
vcom -work work -2002 -explicit -stats=none pos_meas.vhd
vcom -work work -2002 -explicit -stats=none motor_beh.vhd
vcom -work work -2002 -explicit -stats=none motor_ent.vhd


vsim work.tb_pos_ctrl

add wave *

run 20000 us
