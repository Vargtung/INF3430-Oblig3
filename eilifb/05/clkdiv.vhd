library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity clkdiv is
  port
  (
    rst   : in std_logic; --Reset
    mclk  : in std_logic; --Master clock
    mclk_div  : out std_logic --Master clokc div by 128
  );
end clkdiv;

architecture clkdiv_ARCH of clkdiv is
  signal mclk_cnt : unsigned(6 downto 0);
  
begin
  P_CLKDIV : process(rst, mclk)
  begin
    if(rst = '1') then
      mclk_cnt <= (others => '0');
    elsif(rising_edge(mclk)) then
      mclk_cnt <= mclk_cnt + 1;
    end if;
  end process;
  mclk_div <= std_logic(mclk_cnt(6));
end clkdiv_ARCH;
