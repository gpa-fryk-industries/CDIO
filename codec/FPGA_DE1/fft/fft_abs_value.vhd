library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_abs_value is

	generic (
	
		N_bit : integer := 8;
		Stage : integer := 2
	);
	
   port( 
		
		x_real : in signed(Stage + N_bit downto 0);
		x_imag : in signed(Stage + N_bit downto 0);
		
		y_abs : out unsigned(2*N_bit -1 downto 0)
				
	);
end fft_abs_value;

architecture arch_fft_abs_value of fft_abs_value is

	signal R : signed(N_bit-1 downto 0);
	signal I : signed(N_bit-1 downto 0);

begin

	R <= x_real(Stage+N_bit downto Stage+1);
	I <= x_imag(Stage+N_bit downto Stage+1);

	y_abs <= to_unsigned(to_integer(R*R + I*I), 16);

	
end arch_fft_abs_value;