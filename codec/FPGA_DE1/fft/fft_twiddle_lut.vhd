
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
	
		N_bit : integer := 10
		
	);
	
	port( 
	
		clock : in std_logic;
		reset : in std_logic;
		
		twiddle_real : out signed(N_bit downto 0);
		twiddle_imag : out signed(N_bit downto 0);
		
		index_debug : out unsigned(3 downto 0) 
	);

end fft_twiddle_lut;

architecture arch_fft_twiddle_lut of fft_twiddle_lut is

	signal	TwiddleTableReal : my_array_t1(integer range 0 to 15) := (512, 473, 362, 195, 0, -196, -363, -474, -512, -474, -363, -196, -1, 195, 362, 473);
												
	signal	TwiddleTableImag : my_array_t1(integer range 0 to 15) := (0, -196, -363, -474, -512, -474, -363, -196, -1, 195, 362, 473, 512, 473, 362, 195);
	
	signal count : unsigned(4 downto 0) := (others => '0');	
	
	signal index : integer := 0;
																							 
begin

	process(clock,reset) is
	begin
		
		if reset = '1' then
		
			count <= (others => '0');
		
		elsif rising_edge(clock) then
		
			if ( count >= to_unsigned(15, 4) ) then
			
				count <= (others => '0');
			
			else
			
				count <= count + 1;
		
			end if;
			
		
		end if;
	
	
	end process;
	
	index <= to_integer( not(count(2)) & ( count(3) xor count(2) ) ) * to_integer( count(1 downto 0) ) ;
	
	twiddle_real <= to_signed( TwiddleTableReal(index) , N_bit+1);
	twiddle_imag <= to_signed( TwiddleTableImag(index) , N_bit+1);
	
	index_debug <= to_unsigned(index, 4);
	
end arch_fft_twiddle_lut;
	
	
