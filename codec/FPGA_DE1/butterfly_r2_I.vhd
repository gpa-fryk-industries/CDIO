library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity r2_butterfly is

	generic (
	
		N_bit : integer := 10
	
	);

   port( 
	
		x1_real : in signed(N_bit-1 downto 0);
		x1_imag : in signed(N_bit-1 downto 0);
		
		x2_real : in signed(N_bit-1 downto 0);
		x2_imag : in signed(N_bit-1 downto 0);
		
		y1_real : out signed(N_bit-1 downto 0);
		y1_imag : out signed(N_bit-1 downto 0);
		
		y2_real : out signed(N_bit-1 downto 0);
		y2_imag : out signed(N_bit-1 downto 0)
                  
	);
end r2_butterfly;

architecture arch_r2_butterfly of r2_butterfly is
		
begin

	y1_real <= x1_real + x2_real;
	y1_imag <= x1_imag + x2_imag;
	
	y2_real <= x1_real - x2_real;
	y2_imag <= x1_imag - x2_imag;
	
end arch_r2_butterfly;