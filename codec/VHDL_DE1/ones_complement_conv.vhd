library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ones_conv is

   port( 

		Data_in  : in std_logic_vector(7 downto 0);
		Data_out  : out std_logic_vector(7 downto 0)
		
	);
end ones_conv;

architecture arch_ones_conv of ones_conv is
	
begin   

	Data_out <= Data_in xor "10000000";
	
end arch_ones_conv;

	