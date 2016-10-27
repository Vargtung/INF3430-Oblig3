library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity pos_ctrl is
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
end pos_ctrl;
--architecture <architectureName> of <Belonging entity> is

architecture pos_ctrl_ARCH of pos_ctrl is
  --Area for declarations internal to the architecture
  --for example internal signals
  component pos_meas is
    port (
      -- System Clock and Reset
      rst      : in  std_logic;           -- Reset
      clk      : in  std_logic;           -- Clock
      sync_rst : in  std_logic;           -- Sync rst
      a        : in  std_logic;           -- From position sensor
      b        : in  std_logic;           -- From position sensor
      pos      : out signed(7 downto 0)   -- Measured position
      );
  end component;

  component p_ctrl is
    port
      (    -- System Clock and Reset
      rst       : in  std_logic;           -- Reset
      clk       : in  std_logic;           -- Clock
      sp        : in  signed(7 downto 0);  -- Set Point
      pos       : in  signed(7 downto 0);  -- Measured position
      motor_cw  : out std_logic;           --Motor Clock Wise direction
      motor_ccw : out std_logic            --Motor Counter Clock Wise direction
    );
  end component;

  signal pos_itr : signed(7 downto 0);
  signal sp_itr : std_logic_vector(7 downto 0);
  signal cw : std_logic;
  signal ccw : std_logic;
begin
  pos_meas_instance : pos_meas
    port map
    (
      rst => rst,
      clk => mclk,
      sync_rst => sync_rst,
      a => a,
      b => b,
      pos => pos_itr
    );
  p_ctrl_instance : p_ctrl
    port map(
      rst => rst_div,
      clk => mclk_div,
      sp => signed(sp_itr),
      pos => pos_itr,
      motor_cw => cw,
      motor_ccw => ccw
    );

    motor_mux : process(force_cw, force_ccw, cw, ccw) is
    begin
      if(force_cw = '0' and force_ccw = '0') then
        motor_cw <= cw;
        motor_ccw <= ccw;
      elsif(force_cw = '0' and force_ccw = '1') then
        motor_cw <= force_cw;
        motor_ccw <= force_ccw;
      elsif(force_cw = '1' and force_ccw = '0') then
        motor_cw <= force_cw;
        motor_ccw <= force_ccw;
      elsif(force_cw = '1' and force_ccw = '1') then
        motor_cw <= cw;
        motor_ccw <= ccw;
      end if;
    end process;

    sp_itr <= '0' & sp(6 downto 0);
    pos <= std_logic_vector(pos_itr);
end pos_ctrl_ARCH;
