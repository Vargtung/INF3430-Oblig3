library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity tb_pos_ctrl is
end tb_pos_ctrl;
--architecture <architectureName> of <Belonging entity> is

architecture tb_pos_ctrl_ARCH of tb_pos_ctrl is
  --Area for declarations internal to the architecture
  --for example internal signals
  Component pos_ctrl is
    port
    (    -- System Clock and Reset
      rst       : in  std_logic;          -- Reset
      rst_div   : in  std_logic;          -- Reset
      mclk      : in  std_logic;          -- Clock
      mclk_div  : in  std_logic;          -- Clock to p_reg
      sync_rst  : in  std_logic;          -- Synchronous reset
      sp        : in  std_logic_vector(7 downto 0);  -- Setpoint (wanted position)
      a         : in  std_logic;          -- From position sensor
      b         : in  std_logic;          -- From position sensor
      pos       : out std_logic_vector(7 downto 0);  -- Measured Position
      force_cw  : in  std_logic;          -- Force motor clock wise motion
      force_ccw : in  std_logic;  -- Force motor counter clock wise motion
      motor_cw  : out std_logic;          -- Motor clock wise motion
      motor_ccw : out std_logic           -- Motor counter clock wise motion
    );
  end component;

  Component motor is
    generic (
      phase90 : time := 50 us
      );
    port
    (
      motor_cw  : in  std_logic;
      motor_ccw : in  std_logic;
      a         : out std_logic;
      b         : out std_logic
    );
  end component;

  signal rst : std_logic;
  signal mclk : std_logic := '0';
  signal mclk_div : std_logic := '0';
  signal sp : std_logic_vector(7 downto 0);
  signal a : std_logic;
  signal b : std_logic;
  signal pos: std_logic_vector(7 downto 0);
  signal force_cw  :  std_logic;
  signal force_ccw :  std_logic;
  signal motor_cw  : std_logic;
  signal motor_ccw : std_logic;
begin
  --Here starts the description
  UUT : pos_ctrl
    port map(
    rst => rst,
    rst_div => rst,
    mclk => mclk,
    mclk_div => mclk_div,
    sync_rst => rst,
    sp => sp,
    a => a,
    b => b,
    pos => pos,
    force_cw  => force_cw,
    force_ccw => force_ccw,
    motor_cw => motor_cw,
    motor_ccw => motor_ccw
    );
  motor_instance : motor
    port map(
      motor_cw => motor_cw,
      motor_ccw => motor_ccw,
      a => a,
      b => b
    );
  mclk <= not mclk after 50 ns;
  mclk_div <= not mclk_div after 100 ns;
  force_cw <= '0', '1' after 6000 us;
  force_ccw <= '0';
  rst <= '1', '0' after 175 ns;
  sp <= "00001000", "00000000" after 5000 us;
end tb_pos_ctrl_ARCH;
