vcom -work work -2002 -explicit -stats=none p_ctrl.vhd
vcom -work work -2002 -explicit -stats=none tb_p_ctrl.vhd


vsim work.tb_p_ctrl

add wave *

run 1000 us
