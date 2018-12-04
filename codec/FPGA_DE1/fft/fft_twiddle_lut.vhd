
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This looks stupid but seems like the only way to implement generic arrays, if needed. At the moment these arrays (LUTs) are implemented 
-- as signals. 

package mytypes_pkg_4 is

     type my_array_t1 is array (integer range <>) of integer;
	  
end package mytypes_pkg_4;

library IEEE;
use work.mytypes_pkg_4.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_twiddle_lut is
	
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

end fft_twiddle_lut;

architecture arch_fft_twiddle_lut of fft_twiddle_lut is

	signal	TwiddleTableReal : my_array_t1(integer range 0 to 63) := (128,	127,	125,	122,	118,	112,	106,	98,	90,	81,	71,	60,	48,	37,	24,
																							12,	0,	-13,	-25,	-38,	-49,	-61,	-72,	-82,	-91,	-99,	-107,	-113,	-119,	-123,
																							-126,	-128,	-128,	-128,	-126,	-123,	-119,	-113,	-107,	-99,	-91,	-82,	-72,	-61,	-49,
																							-38,	-25,	-13,	-1,	12,	24,	37,	48,	60,	71,	81,	90,	98,	106,	112,	
																							118,	122,	125,	127);		
																							
	signal	TwiddleTableImag : my_array_t1(integer range 0 to 63) := (0, -13, -25, -38, -49, -61, -72, -82, -91, -99, -107, -113, -119, -123, -126, -128, -128, 
																							-128, -126, -123, -119, -113, -107, -99, -91, -82, -72, -61, -49, -38, -25, -13, -1, 12,
																							24, 37, 48, 60, 71, 81, 90, 98, 106, 112, 118, 122, 125, 127, 128, 127, 125, 122, 118, 
																							112, 106, 98,90, 81, 71, 60,48, 37, 24, 12);
	
																							 
begin

	
	twiddle_real_0 <= to_signed( TwiddleTableReal( to_integer( tw_index_0) ) , N_bit+1);
	twiddle_imag_0 <= to_signed( TwiddleTableImag( to_integer( tw_index_0) ) , N_bit+1);
	
	twiddle_real_1 <= to_signed( TwiddleTableReal( to_integer( tw_index_1) ) , N_bit+1);
	twiddle_imag_1 <= to_signed( TwiddleTableImag( to_integer( tw_index_1) ) , N_bit+1); 
	
end arch_fft_twiddle_lut;
	
	
