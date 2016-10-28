library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity DECODER is
  port
  (
    indata              : in  std_logic_vector(3 downto 0);
    outdata        		: out std_logic_vector(6 downto 0)
  );
end DECODER;

architecture DECODER_ARCH of DECODER is

begin


  DECODER_PROC : process (indata)
  begin
    case indata is
		when "0000" => outdata <="0000001";--0
		when "0001" => outdata <="1001111";--1
		when "0010" => outdata <="0010010";--2
		when "0011" => outdata <="0000110";--3
		when "0100" => outdata <="1001100";--4
		when "0101" => outdata <="0100100";--5
		when "0110" => outdata <="0100000";--6
		when "0111" => outdata <="0001111";--7
		when "1000" => outdata <="0000000";--8
		when "1001" => outdata <="0001100";--9
		when "1010" => outdata <="0001000";--A
		when "1011" => outdata <="1100000";--B
		when "1100" => outdata <="0110001";--C
		when "1101" => outdata <="1000010";--D
		when "1110" => outdata <="0110000";--E
		when others => outdata <="0111000";--F
    end case;

  end process DECODER_PROC;

end DECODER_ARCH;
