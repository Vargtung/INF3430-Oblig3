library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity tb_pos_meas is
end tb_pos_meas;
--architecture <architectureName> of <Belonging entity> is

architecture tb_pos_meas_ARCH of tb_pos_meas is
  --Area for declarations internal to the architecture
  --for example internal signals
  Component pos_meas is
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
  Component motor is
    generic (
      phase90 : time := 50 us
      );
    port (
      motor_cw  : in  std_logic;
      motor_ccw : in  std_logic;
      a         : out std_logic;
      b         : out std_logic
      );
  end component;
  signal pos : signed(7 downto 0);
  signal rst : std_logic;
  signal a : std_logic := '1';
  signal b : std_logic;
  signal sync_rst : std_logic;
  signal mclk : std_logic := '0';
  signal motor_cw : std_logic;
  signal motor_ccw : std_logic;
begin
  UUT : pos_meas
    port map(
      rst => rst,
      clk => mclk,
      sync_rst => sync_rst,
      a => a,
      b => b,
      pos => pos
			);

  motor_model : motor
    port map(
      motor_cw => motor_cw,
      motor_ccw => motor_ccw,
      a => a,
      b => b
    );
  mclk <= not mclk after 50 ns;
  rst <= '1', '0' after 75 ns;
  motor_ccw <= '0', '1' after 25 ns, '0' after 1000 us;
  motor_cw <= '0', '1' after 1000 us, '0' after 5000 us;

end tb_pos_meas_ARCH;
