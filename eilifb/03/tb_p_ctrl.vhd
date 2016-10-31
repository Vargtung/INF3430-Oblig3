library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity tb_p_ctrl is
end tb_p_ctrl;
--architecture <architectureName> of <Belonging entity> is

architecture tb_p_ctrl_ARCH of tb_p_ctrl is
  --Area for declarations internal to the architecture
  --for example internal signals
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

  signal rst        : std_logic;
  signal clk        : std_logic := '0';
  signal sp         : signed(7 downto 0);
  signal pos        : signed(7 downto 0);
  signal motor_cw   : std_logic;
  signal motor_ccw  : std_logic;
begin
  UUT : p_ctrl
    port map(
      rst => rst,
      clk => clk,
      sp => sp,
      pos => pos,
      motor_cw => motor_cw,
      motor_ccw => motor_ccw
    );

  clk <= not clk after 50 ns;
  pos <= "00000000";
  sp <= "00000010";
  rst <= '1', '0' after 75 ns;
end tb_p_ctrl_ARCH;
