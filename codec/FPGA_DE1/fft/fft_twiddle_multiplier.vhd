library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_twiddle_multiplier is

	generic (
	
		N_bit : integer := 8;
		Stage : integer := 2
	);
	
   port( 
		
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit-1 downto 0);
		y_imag : out signed(Stage + N_bit-1 downto 0);
		
		twiddle_real : in signed(N_bit downto 0);
		twiddle_imag : in signed(N_bit downto 0)
				
	);
end fft_twiddle_multiplier;

architecture arch_fft_twiddle_multiplier of fft_twiddle_multiplier is

	signal R : signed( (2*N_bit + Stage) downto 0);
	signal I : signed( (2*N_bit + Stage) downto 0);

begin

	R <= x_real*twiddle_real - x_imag*twiddle_imag;
	I <= x_real*twiddle_imag + x_imag*twiddle_real;

	y_real <= shift_right( signed(R) , N_bit-1 )(Stage+N_bit-1 downto 0);
	y_imag <= shift_right( signed(I) , N_bit-1 )(Stage+N_bit-1 downto 0);
	
	--y_real <= R( (2*N_bit + Stage) downto  N_bit + 1 );
	--y_imag <= I( (2*N_bit + Stage) downto  N_bit + 1 );
	
end arch_fft_twiddle_multiplier;