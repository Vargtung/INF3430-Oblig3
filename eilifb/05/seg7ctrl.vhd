library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg7ctrl is
	port(
		 clk 			: in std_logic; --50MHz, positive flank
		 reset 			: in std_logic; --Asynchronous, active high
		 d0 			: in std_logic_vector(3 downto 0);
		 d1 			: in std_logic_vector(3 downto 0);
		 d2 			: in std_logic_vector(3 downto 0);
		 d3 			: in std_logic_vector(3 downto 0);
		 dec 			: in std_logic_vector(3 downto 0);
		 abcdefgdec_n	: out std_logic_vector(7 downto 0);
		 a_n			: out std_logic_vector(3 downto 0)
		);
end seg7ctrl;

architecture seg7ctrl_arch of seg7ctrl is

	component decoder is
		port
			(
				indata   		: in  std_logic_vector(3 downto 0);
			  outdata  		: out std_logic_vector(6 downto 0)
			);
	end component decoder;
	--signals
	signal disp_to_seg		: std_logic_vector(3 downto 0);
	signal output			: std_logic_vector(6 downto 0);
	signal des				: std_logic;
	signal a_n_itr			: std_logic_vector(3 downto 0);

begin
	decoder_instance : decoder
		port map
		(
			indata => disp_to_seg,
			outdata => output
		);

	counter_process: process(reset,clk)
	variable counter	: unsigned(15 downto 0);
	begin
		if(reset = '1') then
			counter := (others => '0');
			des <= '0';
			a_n_itr <= "1111";
		elsif rising_edge(clk) then
			counter := counter + 1;
			if(counter(15 downto 14) = "00") then
				if (dec(0) = '1') then
					des <= '0';
				else
					des <= '1';
				end if;
				a_n_itr <= "1110";
				disp_to_seg <= d0;
			elsif(counter(15 downto 14) = "01") then
				if (dec = "0010") then
					des <= '0';
				else
					des <= '1';
				end if;
				a_n_itr <= "1101";
				disp_to_seg <= d1;
			elsif(counter(15 downto 14) = "10") then
				if (dec = "0100") then
					des <= '0';
				else
					des <= '1';
				end if;
				a_n_itr <= "1011";
				disp_to_seg <= d2;
			elsif(counter(15 downto 14) = "11") then
				if (dec = "1000") then
					des <= '0';
				else
					des <= '1';
				end if;
				a_n_itr <= "0111";
				disp_to_seg <= d3;
			else
				des <= des;
				a_n_itr <= a_n_itr;
				disp_to_seg <= disp_to_seg;
			end if;
		end if;


	end process counter_process;

	-- select_disp : process(counter)
	-- begin
		-- if(counter = "00") then
			-- if (dec(0) = '1') then
				-- des <= '1';
			-- else
				-- des <= '0';
			-- end if;
			-- a_n_itr <= "1110";
			-- disp_to_seg <= d0;
		-- elsif(counter = "01") then
			-- if (dec = "0010") then
				-- des <= '1';
			-- else
				-- des <= '0';
			-- end if;
			-- a_n_itr <= "1101";
			-- disp_to_seg <= d1;
		-- elsif(counter = "10") then
			-- if (dec = "0100") then
				-- des <= '1';
			-- else
				-- des <= '0';
			-- end if;
			-- a_n_itr <= "1011";
			-- disp_to_seg <= d2;
		-- elsif(counter = "11") then
			-- if (dec = "1000") then
				-- des <= '1';
			-- else
				-- des <= '0';
			-- end if;
			-- a_n_itr <= "0111";
			-- disp_to_seg <= d3;
		-- else
			-- des <= des;
			-- a_n_itr <= a_n_itr;
			-- disp_to_seg <= disp_to_seg;
		-- end if;

	-- end process select_disp;
	abcdefgdec_n <= output & des;
	a_n <= a_n_itr;
end seg7ctrl_arch;
