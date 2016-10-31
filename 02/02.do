

vcom -work work -2002 -explicit -stats=none tb_pos_meas.vhd
vcom -work work -2002 -explicit -stats=none pos_meas.vhd
vcom -work work -2002 -explicit -stats=none motor_beh.vhd
vcom -work work -2002 -explicit -stats=none motor_ent.vhd


vsim work.tb_pos_meas

add wave *

run 8000 us
