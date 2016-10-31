library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity rstsynch is
  port
  (
    arst      : in std_logic; --Asynch. reset
    mclk      : in std_logic; --Master clk
    mclk_div  : in std_logic; --Master clock div. by 128
    rst       : out std_logic; --Synch reset master clock
    rst_div   : out std_logic --Synch reset divided clock
  );
end rstsynch;
--architecture <architectureName> of <Belonging entity> is

architecture rstsynch_ARCH of rstsynch is
  signal rst_s1     : std_logic;
  signal rst_s2     : std_logic;
  signal rst_div_s1 : std_logic;
  signal rst_div_s2 : std_logic;

begin

  P_RST_0 : process(arst, mclk)
  begin
    if arst = '1' then
      rst_s1 <= '1';
      rst_s2 <= '1';
    elsif rising_edge(mclk) then
      rst_s1 <= '0';
      rst_s2 <= rst_s1;
    end if;
  end process;

  R_RST_1 : process(arst, mclk_div)
  begin
    if arst = '1' then
      rst_div_s1 <= '1';
      rst_div_s2 <= '1';
    elsif rising_edge(mclk_div) then
      rst_div_s1 <= '0';
      rst_div_s2 <= rst_div_s1;
    end if;
  end process;

    rst <= rst_s2;
    rst_div <= rst_div_s2;
end rstsynch_ARCH;
