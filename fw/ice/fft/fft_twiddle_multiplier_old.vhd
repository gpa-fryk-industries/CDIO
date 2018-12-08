library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_twiddle_multiplier is
	
	generic(
		N_bit : integer := 8;
		Stage : integer := 2
	);
	
	port( 
	
		x_real : in signed(Stage+N_bit-1 downto 0);
		x_imag : in signed(Stage+N_bit-1 downto 0);
		
		y_real : out signed(Stage+N_bit-1 downto 0);
		y_imag : out signed(Stage+N_bit-1 downto 0);
		
		clock : in std_logic;
		
		twiddle_real : in signed(N_bit downto 0);
		twiddle_imag : in signed(N_bit downto 0)


	);

end fft_twiddle_multiplier ;

architecture arch_fft_twiddle_multiplier  of fft_twiddle_multiplier  is

component multiplier_mac16

	generic(
		N_bit : integer;
		M_bit : integer
	);
	
	port( 
	
		x : in signed(N_bit-1 downto 0);
		y : in signed(M_bit-1 downto 0);
		
		ans   : out signed(M_bit+N_bit-1 downto 0);
		
		clock : in std_logic

	);

end component;

	signal A : signed(2*N_bit+ Stage downto 0);
	signal B : signed(2*N_bit+ Stage downto 0);
	signal C : signed(2*N_bit+ Stage downto 0);
 	signal D : signed(2*N_bit+ Stage downto 0);

		
begin


	M1: multiplier_MAC16
		generic map(Stage+N_bit, N_bit+1)	
		port map(x_real, twiddle_real, A,clock);
	M2: multiplier_MAC16
		generic map(Stage+N_bit, N_bit+1)
		port map(x_imag, twiddle_imag, B,clock);
	M3: multiplier_MAC16
		generic map(Stage+N_bit, N_bit+1)
		port map(x_real, twiddle_imag, C, not(clock));
	M4: multiplier_MAC16
		generic map(Stage+N_bit, N_bit+1)
		port map(x_imag, twiddle_real, D, not(clock));

	y_real <= shift_right(signed(A-B), N_bit-1)(Stage+N_bit-1 downto 0);
	y_imag <= shift_right(signed(C+D), N_bit-1)(Stage+N_bit-1 downto 0);

	
end arch_fft_twiddle_multiplier ;
	
	
