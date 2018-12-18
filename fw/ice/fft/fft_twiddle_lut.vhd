library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_twiddle_lut2 is
	
	generic (
	
		N_bit : integer := 8;
		L     : integer := 4
	);
	
	port( 
	
		
		tw_index_0 : in unsigned(L-1 downto 0);
		tw_index_1 : in unsigned(L-1 downto 0);
		
		twiddle_real_0 : out signed(N_bit downto 0);
		twiddle_imag_0 : out signed(N_bit downto 0);
		
		twiddle_real_1 : out signed(N_bit downto 0);
		twiddle_imag_1 : out signed(N_bit downto 0)
		
	);

end fft_twiddle_lut2;

architecture arch_fft_twiddle_lut2 of fft_twiddle_lut2 is
	
	signal tw0 : integer range 0 to 63;
	signal tw1 : integer range 0 to 63;			
																				 
begin

	tw0 <= to_integer(tw_index_0);
	tw1 <= to_integer(tw_index_1);

	
	process(tw0)
	begin

	case tw0 is
	
		when 0 => 
		 twiddle_real_0 <= to_signed(128, N_bit+1);
		 twiddle_imag_0 <= to_signed(0, N_bit+1);
		when 1 => 
		 twiddle_real_0 <= to_signed(127, N_bit+1);
		 twiddle_imag_0 <= to_signed(-13, N_bit+1);
		when 2 => 
		 twiddle_real_0 <= to_signed(125, N_bit+1);
		 twiddle_imag_0 <= to_signed(-25, N_bit+1);
		when 3 => 
		 twiddle_real_0 <= to_signed(122, N_bit+1);
		 twiddle_imag_0 <= to_signed(-38, N_bit+1);
		when 4 => 
		 twiddle_real_0 <= to_signed(118, N_bit+1);
		 twiddle_imag_0 <= to_signed(-49, N_bit+1);
		when 5 => 
		 twiddle_real_0 <= to_signed(112, N_bit+1);
		 twiddle_imag_0 <= to_signed(-61, N_bit+1);
		when 6 => 
		 twiddle_real_0 <= to_signed(106, N_bit+1);
		 twiddle_imag_0 <= to_signed(-72, N_bit+1);
		when 7 => 
		 twiddle_real_0 <= to_signed(98, N_bit+1);
		 twiddle_imag_0 <= to_signed(-82, N_bit+1);
		when 8 => 
		 twiddle_real_0 <= to_signed(90, N_bit+1);
		 twiddle_imag_0 <= to_signed(-91, N_bit+1);
		when 9 => 
		 twiddle_real_0 <= to_signed(81, N_bit+1);
		 twiddle_imag_0 <= to_signed(-99, N_bit+1);
		when 10 => 
		 twiddle_real_0 <= to_signed(71, N_bit+1);
		 twiddle_imag_0 <= to_signed(-107, N_bit+1);
		when 11 => 
		 twiddle_real_0 <= to_signed(60, N_bit+1);
		 twiddle_imag_0 <= to_signed(-113, N_bit+1);
		when 12 => 
		 twiddle_real_0 <= to_signed(48, N_bit+1);
		 twiddle_imag_0 <= to_signed(-119, N_bit+1);
		when 13 => 
		 twiddle_real_0 <= to_signed(37, N_bit+1);
		 twiddle_imag_0 <= to_signed(-123, N_bit+1);
		when 14 => 
		 twiddle_real_0 <= to_signed(24, N_bit+1);
		 twiddle_imag_0 <= to_signed(-126, N_bit+1);
		when 15 => 
		 twiddle_real_0 <= to_signed(12, N_bit+1);
		 twiddle_imag_0 <= to_signed(-128, N_bit+1);
		when 16 => 
		 twiddle_real_0 <= to_signed(0, N_bit+1);
		 twiddle_imag_0 <= to_signed(-128, N_bit+1);
		when 17 => 
		 twiddle_real_0 <= to_signed(-13, N_bit+1);
		 twiddle_imag_0 <= to_signed(-128, N_bit+1);
		when 18 => 
		 twiddle_real_0 <= to_signed(-25, N_bit+1);
		 twiddle_imag_0 <= to_signed(-126, N_bit+1);
		when 19 => 
		 twiddle_real_0 <= to_signed(-38, N_bit+1);
		 twiddle_imag_0 <= to_signed(-123, N_bit+1);
		when 20 => 
		 twiddle_real_0 <= to_signed(-49, N_bit+1);
		 twiddle_imag_0 <= to_signed(-119, N_bit+1);
		when 21 => 
		 twiddle_real_0 <= to_signed(-61, N_bit+1);
		 twiddle_imag_0 <= to_signed(-113, N_bit+1);
		when 22 => 
		 twiddle_real_0 <= to_signed(-72, N_bit+1);
		 twiddle_imag_0 <= to_signed(-107, N_bit+1);
		when 23 => 
		 twiddle_real_0 <= to_signed(-82, N_bit+1);
		 twiddle_imag_0 <= to_signed(-99, N_bit+1);
		when 24 => 
		 twiddle_real_0 <= to_signed(-91, N_bit+1);
		 twiddle_imag_0 <= to_signed(-91, N_bit+1);
		when 25 => 
		 twiddle_real_0 <= to_signed(-99, N_bit+1);
		 twiddle_imag_0 <= to_signed(-82, N_bit+1);
		when 26 => 
		 twiddle_real_0 <= to_signed(-107, N_bit+1);
		 twiddle_imag_0 <= to_signed(-72, N_bit+1);
		when 27 => 
		 twiddle_real_0 <= to_signed(-113, N_bit+1);
		 twiddle_imag_0 <= to_signed(-61, N_bit+1);
		when 28 => 
		 twiddle_real_0 <= to_signed(-119, N_bit+1);
		 twiddle_imag_0 <= to_signed(-49, N_bit+1);
		when 29 => 
		 twiddle_real_0 <= to_signed(-123, N_bit+1);
		 twiddle_imag_0 <= to_signed(-38, N_bit+1);
		when 30 => 
		 twiddle_real_0 <= to_signed(-126, N_bit+1);
		 twiddle_imag_0 <= to_signed(-25, N_bit+1);
		when 31 => 
		 twiddle_real_0 <= to_signed(-128, N_bit+1);
		 twiddle_imag_0 <= to_signed(-13, N_bit+1);
		when 32 => 
		 twiddle_real_0 <= to_signed(-128, N_bit+1);
		 twiddle_imag_0 <= to_signed(-1, N_bit+1);
		when 33 => 
		 twiddle_real_0 <= to_signed(-128, N_bit+1);
		 twiddle_imag_0 <= to_signed(12, N_bit+1);
		when 34 => 
		 twiddle_real_0 <= to_signed(-126, N_bit+1);
		 twiddle_imag_0 <= to_signed(24, N_bit+1);
		when 35 => 
		 twiddle_real_0 <= to_signed(-123, N_bit+1);
		 twiddle_imag_0 <= to_signed(37, N_bit+1);
		when 36 => 
		 twiddle_real_0 <= to_signed(-119, N_bit+1);
		 twiddle_imag_0 <= to_signed(48, N_bit+1);
		when 37 => 
		 twiddle_real_0 <= to_signed(-113, N_bit+1);
		 twiddle_imag_0 <= to_signed(60, N_bit+1);
		when 38 => 
		 twiddle_real_0 <= to_signed(-107, N_bit+1);
		 twiddle_imag_0 <= to_signed(71, N_bit+1);
		when 39 => 
		 twiddle_real_0 <= to_signed(-99, N_bit+1);
		 twiddle_imag_0 <= to_signed(81, N_bit+1);
		when 40 => 
		 twiddle_real_0 <= to_signed(-91, N_bit+1);
		 twiddle_imag_0 <= to_signed(90, N_bit+1);
		when 41 => 
		 twiddle_real_0 <= to_signed(-82, N_bit+1);
		 twiddle_imag_0 <= to_signed(98, N_bit+1);
		when 42 => 
		 twiddle_real_0 <= to_signed(-72, N_bit+1);
		 twiddle_imag_0 <= to_signed(106, N_bit+1);
		when 43 => 
		 twiddle_real_0 <= to_signed(-61, N_bit+1);
		 twiddle_imag_0 <= to_signed(112, N_bit+1);
		when 44 => 
		 twiddle_real_0 <= to_signed(-49, N_bit+1);
		 twiddle_imag_0 <= to_signed(118, N_bit+1);
		when 45 => 
		 twiddle_real_0 <= to_signed(-38, N_bit+1);
		 twiddle_imag_0 <= to_signed(122, N_bit+1);
		when 46 => 
		 twiddle_real_0 <= to_signed(-25, N_bit+1);
		 twiddle_imag_0 <= to_signed(125, N_bit+1);
		when 47 => 
		 twiddle_real_0 <= to_signed(-13, N_bit+1);
		 twiddle_imag_0 <= to_signed(127, N_bit+1);
		when 48 => 
		 twiddle_real_0 <= to_signed(-1, N_bit+1);
		 twiddle_imag_0 <= to_signed(128, N_bit+1);
		when 49 => 
		 twiddle_real_0 <= to_signed(12, N_bit+1);
		 twiddle_imag_0 <= to_signed(127, N_bit+1);
		when 50 => 
		 twiddle_real_0 <= to_signed(24, N_bit+1);
		 twiddle_imag_0 <= to_signed(125, N_bit+1);
		when 51 => 
		 twiddle_real_0 <= to_signed(37, N_bit+1);
		 twiddle_imag_0 <= to_signed(122, N_bit+1);
		when 52 => 
		 twiddle_real_0 <= to_signed(48, N_bit+1);
		 twiddle_imag_0 <= to_signed(118, N_bit+1);
		when 53 => 
		 twiddle_real_0 <= to_signed(60, N_bit+1);
		 twiddle_imag_0 <= to_signed(112, N_bit+1);
		when 54 => 
		 twiddle_real_0 <= to_signed(71, N_bit+1);
		 twiddle_imag_0 <= to_signed(106, N_bit+1);
		when 55 => 
		 twiddle_real_0 <= to_signed(81, N_bit+1);
		 twiddle_imag_0 <= to_signed(98, N_bit+1);
		when 56 => 
		 twiddle_real_0 <= to_signed(90, N_bit+1);
		 twiddle_imag_0 <= to_signed(90, N_bit+1);
		when 57 => 
		 twiddle_real_0 <= to_signed(98, N_bit+1);
		 twiddle_imag_0 <= to_signed(81, N_bit+1);
		when 58 => 
		 twiddle_real_0 <= to_signed(106, N_bit+1);
		 twiddle_imag_0 <= to_signed(71, N_bit+1);
		when 59 => 
		 twiddle_real_0 <= to_signed(112, N_bit+1);
		 twiddle_imag_0 <= to_signed(60, N_bit+1);
		when 60 => 
		 twiddle_real_0 <= to_signed(118, N_bit+1);
		 twiddle_imag_0 <= to_signed(48, N_bit+1);
		when 61 => 
		 twiddle_real_0 <= to_signed(122, N_bit+1);
		 twiddle_imag_0 <= to_signed(37, N_bit+1);
		when 62 => 
		 twiddle_real_0 <= to_signed(125, N_bit+1);
		 twiddle_imag_0 <= to_signed(24, N_bit+1);
		when 63 => 
		 twiddle_real_0 <= to_signed(127, N_bit+1);
		 twiddle_imag_0 <= to_signed(12, N_bit+1);

	end case;

	end process;
	

	process(tw1)
	begin

	case tw1 is
	
		when 0 => 
		 twiddle_real_1 <= to_signed(128, N_bit+1);
		 twiddle_imag_1 <= to_signed(0, N_bit+1);
		when 1 => 
		 twiddle_real_1 <= to_signed(127, N_bit+1);
		 twiddle_imag_1 <= to_signed(-13, N_bit+1);
		when 2 => 
		 twiddle_real_1 <= to_signed(125, N_bit+1);
		 twiddle_imag_1 <= to_signed(-25, N_bit+1);
		when 3 => 
		 twiddle_real_1 <= to_signed(122, N_bit+1);
		 twiddle_imag_1 <= to_signed(-38, N_bit+1);
		when 4 => 
		 twiddle_real_1 <= to_signed(118, N_bit+1);
		 twiddle_imag_1 <= to_signed(-49, N_bit+1);
		when 5 => 
		 twiddle_real_1 <= to_signed(112, N_bit+1);
		 twiddle_imag_1 <= to_signed(-61, N_bit+1);
		when 6 => 
		 twiddle_real_1 <= to_signed(106, N_bit+1);
		 twiddle_imag_1 <= to_signed(-72, N_bit+1);
		when 7 => 
		 twiddle_real_1 <= to_signed(98, N_bit+1);
		 twiddle_imag_1 <= to_signed(-82, N_bit+1);
		when 8 => 
		 twiddle_real_1 <= to_signed(90, N_bit+1);
		 twiddle_imag_1 <= to_signed(-91, N_bit+1);
		when 9 => 
		 twiddle_real_1 <= to_signed(81, N_bit+1);
		 twiddle_imag_1 <= to_signed(-99, N_bit+1);
		when 10 => 
		 twiddle_real_1 <= to_signed(71, N_bit+1);
		 twiddle_imag_1 <= to_signed(-107, N_bit+1);
		when 11 => 
		 twiddle_real_1 <= to_signed(60, N_bit+1);
		 twiddle_imag_1 <= to_signed(-113, N_bit+1);
		when 12 => 
		 twiddle_real_1 <= to_signed(48, N_bit+1);
		 twiddle_imag_1 <= to_signed(-119, N_bit+1);
		when 13 => 
		 twiddle_real_1 <= to_signed(37, N_bit+1);
		 twiddle_imag_1 <= to_signed(-123, N_bit+1);
		when 14 => 
		 twiddle_real_1 <= to_signed(24, N_bit+1);
		 twiddle_imag_1 <= to_signed(-126, N_bit+1);
		when 15 => 
		 twiddle_real_1 <= to_signed(12, N_bit+1);
		 twiddle_imag_1 <= to_signed(-128, N_bit+1);
		when 16 => 
		 twiddle_real_1 <= to_signed(0, N_bit+1);
		 twiddle_imag_1 <= to_signed(-128, N_bit+1);
		when 17 => 
		 twiddle_real_1 <= to_signed(-13, N_bit+1);
		 twiddle_imag_1 <= to_signed(-128, N_bit+1);
		when 18 => 
		 twiddle_real_1 <= to_signed(-25, N_bit+1);
		 twiddle_imag_1 <= to_signed(-126, N_bit+1);
		when 19 => 
		 twiddle_real_1 <= to_signed(-38, N_bit+1);
		 twiddle_imag_1 <= to_signed(-123, N_bit+1);
		when 20 => 
		 twiddle_real_1 <= to_signed(-49, N_bit+1);
		 twiddle_imag_1 <= to_signed(-119, N_bit+1);
		when 21 => 
		 twiddle_real_1 <= to_signed(-61, N_bit+1);
		 twiddle_imag_1 <= to_signed(-113, N_bit+1);
		when 22 => 
		 twiddle_real_1 <= to_signed(-72, N_bit+1);
		 twiddle_imag_1 <= to_signed(-107, N_bit+1);
		when 23 => 
		 twiddle_real_1 <= to_signed(-82, N_bit+1);
		 twiddle_imag_1 <= to_signed(-99, N_bit+1);
		when 24 => 
		 twiddle_real_1 <= to_signed(-91, N_bit+1);
		 twiddle_imag_1 <= to_signed(-91, N_bit+1);
		when 25 => 
		 twiddle_real_1 <= to_signed(-99, N_bit+1);
		 twiddle_imag_1 <= to_signed(-82, N_bit+1);
		when 26 => 
		 twiddle_real_1 <= to_signed(-107, N_bit+1);
		 twiddle_imag_1 <= to_signed(-72, N_bit+1);
		when 27 => 
		 twiddle_real_1 <= to_signed(-113, N_bit+1);
		 twiddle_imag_1 <= to_signed(-61, N_bit+1);
		when 28 => 
		 twiddle_real_1 <= to_signed(-119, N_bit+1);
		 twiddle_imag_1 <= to_signed(-49, N_bit+1);
		when 29 => 
		 twiddle_real_1 <= to_signed(-123, N_bit+1);
		 twiddle_imag_1 <= to_signed(-38, N_bit+1);
		when 30 => 
		 twiddle_real_1 <= to_signed(-126, N_bit+1);
		 twiddle_imag_1 <= to_signed(-25, N_bit+1);
		when 31 => 
		 twiddle_real_1 <= to_signed(-128, N_bit+1);
		 twiddle_imag_1 <= to_signed(-13, N_bit+1);
		when 32 => 
		 twiddle_real_1 <= to_signed(-128, N_bit+1);
		 twiddle_imag_1 <= to_signed(-1, N_bit+1);
		when 33 => 
		 twiddle_real_1 <= to_signed(-128, N_bit+1);
		 twiddle_imag_1 <= to_signed(12, N_bit+1);
		when 34 => 
		 twiddle_real_1 <= to_signed(-126, N_bit+1);
		 twiddle_imag_1 <= to_signed(24, N_bit+1);
		when 35 => 
		 twiddle_real_1 <= to_signed(-123, N_bit+1);
		 twiddle_imag_1 <= to_signed(37, N_bit+1);
		when 36 => 
		 twiddle_real_1 <= to_signed(-119, N_bit+1);
		 twiddle_imag_1 <= to_signed(48, N_bit+1);
		when 37 => 
		 twiddle_real_1 <= to_signed(-113, N_bit+1);
		 twiddle_imag_1 <= to_signed(60, N_bit+1);
		when 38 => 
		 twiddle_real_1 <= to_signed(-107, N_bit+1);
		 twiddle_imag_1 <= to_signed(71, N_bit+1);
		when 39 => 
		 twiddle_real_1 <= to_signed(-99, N_bit+1);
		 twiddle_imag_1 <= to_signed(81, N_bit+1);
		when 40 => 
		 twiddle_real_1 <= to_signed(-91, N_bit+1);
		 twiddle_imag_1 <= to_signed(90, N_bit+1);
		when 41 => 
		 twiddle_real_1 <= to_signed(-82, N_bit+1);
		 twiddle_imag_1 <= to_signed(98, N_bit+1);
		when 42 => 
		 twiddle_real_1 <= to_signed(-72, N_bit+1);
		 twiddle_imag_1 <= to_signed(106, N_bit+1);
		when 43 => 
		 twiddle_real_1 <= to_signed(-61, N_bit+1);
		 twiddle_imag_1 <= to_signed(112, N_bit+1);
		when 44 => 
		 twiddle_real_1 <= to_signed(-49, N_bit+1);
		 twiddle_imag_1 <= to_signed(118, N_bit+1);
		when 45 => 
		 twiddle_real_1 <= to_signed(-38, N_bit+1);
		 twiddle_imag_1 <= to_signed(122, N_bit+1);
		when 46 => 
		 twiddle_real_1 <= to_signed(-25, N_bit+1);
		 twiddle_imag_1 <= to_signed(125, N_bit+1);
		when 47 => 
		 twiddle_real_1 <= to_signed(-13, N_bit+1);
		 twiddle_imag_1 <= to_signed(127, N_bit+1);
		when 48 => 
		 twiddle_real_1 <= to_signed(-1, N_bit+1);
		 twiddle_imag_1 <= to_signed(128, N_bit+1);
		when 49 => 
		 twiddle_real_1 <= to_signed(12, N_bit+1);
		 twiddle_imag_1 <= to_signed(127, N_bit+1);
		when 50 => 
		 twiddle_real_1 <= to_signed(24, N_bit+1);
		 twiddle_imag_1 <= to_signed(125, N_bit+1);
		when 51 => 
		 twiddle_real_1 <= to_signed(37, N_bit+1);
		 twiddle_imag_1 <= to_signed(122, N_bit+1);
		when 52 => 
		 twiddle_real_1 <= to_signed(48, N_bit+1);
		 twiddle_imag_1 <= to_signed(118, N_bit+1);
		when 53 => 
		 twiddle_real_1 <= to_signed(60, N_bit+1);
		 twiddle_imag_1 <= to_signed(112, N_bit+1);
		when 54 => 
		 twiddle_real_1 <= to_signed(71, N_bit+1);
		 twiddle_imag_1 <= to_signed(106, N_bit+1);
		when 55 => 
		 twiddle_real_1 <= to_signed(81, N_bit+1);
		 twiddle_imag_1 <= to_signed(98, N_bit+1);
		when 56 => 
		 twiddle_real_1 <= to_signed(90, N_bit+1);
		 twiddle_imag_1 <= to_signed(90, N_bit+1);
		when 57 => 
		 twiddle_real_1 <= to_signed(98, N_bit+1);
		 twiddle_imag_1 <= to_signed(81, N_bit+1);
		when 58 => 
		 twiddle_real_1 <= to_signed(106, N_bit+1);
		 twiddle_imag_1 <= to_signed(71, N_bit+1);
		when 59 => 
		 twiddle_real_1 <= to_signed(112, N_bit+1);
		 twiddle_imag_1 <= to_signed(60, N_bit+1);
		when 60 => 
		 twiddle_real_1 <= to_signed(118, N_bit+1);
		 twiddle_imag_1 <= to_signed(48, N_bit+1);
		when 61 => 
		 twiddle_real_1 <= to_signed(122, N_bit+1);
		 twiddle_imag_1 <= to_signed(37, N_bit+1);
		when 62 => 
		 twiddle_real_1 <= to_signed(125, N_bit+1);
		 twiddle_imag_1 <= to_signed(24, N_bit+1);
		when 63 => 
		 twiddle_real_1 <= to_signed(127, N_bit+1);
		 twiddle_imag_1 <= to_signed(12, N_bit+1);

	end case;

	end process;
	
	
end arch_fft_twiddle_lut2;
	
	
