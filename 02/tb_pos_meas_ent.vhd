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
  Component pos_meas_ent is
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
  signal pos : signed(7 downto 0);
  signal rst : std_logic;
  signal a : std_logic;
  signal b : std_logic;
  signal sync_rst : std_logic;
  signal mclk : std_logic := '0';
begin
  UUT : pos_meas_ent
    port map(
      rst => rst,
      clk => mclk,
      sync_rst => sync_rst,
      a => a,
      b => b,
      pos => pos
			);
  mclk <= not mclk after 10 us;
end tb_pos_meas_ARCH;
