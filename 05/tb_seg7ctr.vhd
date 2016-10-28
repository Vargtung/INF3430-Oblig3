library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_seg7model_beh is
  -- empty;
end tb_seg7model_beh;

architecture beh1 of tb_seg7model_beh is

  Component seg7ctrl
    port (clk : in std_logic; --50MHz, positive flank
		  reset : in std_logic; --Asynchronous, active high
		  d0 : in std_logic_vector(3 downto 0);
		  d1 : in std_logic_vector(3 downto 0);
		  d2 : in std_logic_vector(3 downto 0);
		  d3 : in std_logic_vector(3 downto 0);
		  dec : in std_logic_vector(3 downto 0);
		  abcdefgdec_n : out std_logic_vector(7 downto 0);
		  a_n : out std_logic_vector(3 downto 0)	  
		 );
  end Component seg7ctrl;
    
	signal clk			: std_logic := '0';
	signal d0    		: std_logic_vector(3 downto 0);
	signal d1    		: std_logic_vector(3 downto 0);
	signal d2    		: std_logic_vector(3 downto 0);
	signal d3    		: std_logic_vector(3 downto 0);
	signal dec   		: std_logic_vector(3 downto 0);
	signal a_n    		: std_logic_vector(3 downto 0);
	signal abcdefgdec_n : std_logic_vector(7 downto 0);
	signal reset 		: std_logic;
	
		
begin

  UUT : seg7ctrl
    port map( 
			 clk => clk,
			 reset => reset,
             dec => dec,
			 abcdefgdec_n => abcdefgdec_n,
			 a_n => a_n,
			 d3 => d3,	
			 d2 => d2,
			 d1 => d1,
			 d0 => d0
			);
  
  
  d0 <= "0000";
  d1 <= "0001";
  d2 <= "0010";
  d3 <= "0011";
  clk <= not clk after 20 ns;
  dec  <= "0000";
  reset <= '1', '0' after 1 ns;
end beh1;

