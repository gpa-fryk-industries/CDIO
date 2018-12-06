library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_twiddle_multiplier_v2 is

	generic (
	
		N_bit : integer := 8;
		Stage : integer := 2
	);
	
   port( 
		
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit-1 downto 0);
		y_imag : out signed(Stage + N_bit-1 downto 0);
		
		clock  : in std_logic;
		
		twiddle_real : in signed(N_bit downto 0);
		twiddle_imag : in signed(N_bit downto 0)
				
	);
end fft_twiddle_multiplier_v2;

architecture arch_fft_twiddle_multiplier_v2 of fft_twiddle_multiplier_v2 is

	signal X : signed( Stage + N_bit-1 downto 0) := (others => '0');
	signal Y : signed( Stage + N_bit-1 downto 0) := (others => '0');
	signal C : signed( N_bit downto 0) := (others => '0');
	signal S : signed( N_bit downto 0) := (others => '0');
	
	signal R1 : signed( (2*N_bit + Stage) downto 0);
	signal R2 : signed( (2*N_bit + Stage) downto 0);
	signal I1 : signed( (2*N_bit + Stage) downto 0);
	signal I2 : signed( (2*N_bit + Stage) downto 0);
	
	signal Z1 : signed( (2*N_bit + Stage) downto 0) := (others => '0');
	signal Z2 : signed( (2*N_bit + Stage) downto 0) := (others => '0');
	signal Z3 : signed( (2*N_bit + Stage) downto 0) := (others => '0');
	signal Z4 : signed( (2*N_bit + Stage) downto 0) := (others => '0');
	

begin

	R1 <= X*C;
	R2 <= Y*S;
	I1 <= X*S;
	I2 <= Y*C;

	process(clock)
	begin
		
	if rising_edge(clock) then
			
		X <= x_real;
		Y <= x_imag;
		C <= twiddle_real;
		S <= twiddle_imag;
		
		Z1 <= R1;
		Z2 <= R2;
		Z3 <= I1;
		Z4 <= I2;
		
	end if;
	end process;

	y_real <= shift_right(signed(Z1 - Z2), N_bit -1)(Stage+N_bit -1 downto 0);
	y_imag <= shift_right(signed(Z3 + Z4), N_bit -1)(Stage+N_bit -1 downto 0);
	
end arch_fft_twiddle_multiplier_v2;