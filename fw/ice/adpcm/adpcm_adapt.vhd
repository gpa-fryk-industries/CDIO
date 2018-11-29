library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This looks stupid but seems like the only way to implement generic arrays, if needed. At the moment these arrays (LUTs) are implemented 
-- as signals. 

package mytypes_pkg_3 is

     type my_array_t1 is array (integer range <>) of integer;
	  
end package mytypes_pkg_3;

library IEEE;
use work.mytypes_pkg_3.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_adapt is
	
	generic (
		
		N : integer := 2 -- How many stages of ADPCM do we want? N = 1 -> 2 bit, N = 2 -> 3 bit and N = 3 -> 4 bit compression.
	
	);
	
   port( 
	
		Code_in     : in unsigned(3 downto 0); -- Encoded signal. 
		Diffq_in    : in signed(15 downto 0); -- Diffq signal from inverted quantizer.
		Sample_in   : in  signed(7 downto 0); -- New sample from microphone / sound source. 
	
		Clock       : in std_logic; -- Clock signal. 8 KHz in the moment of writing this.
		Reset       : in std_logic; -- Reset signal. Reset module on '1'. 
		
		y_signal	: out signed(7 downto 0); -- Decoded output signal in decoder mode.
		
		Diff_out    : out signed(15 downto 0); -- Difference between sample and predicted sample. Send to Quantizer.
		Step_out    : out signed(15 downto 0) -- Step signal to Quantizer and inverted Quantizer.
                  
	);
end adpcm_adapt;

architecture arch_adpcm_adapt of adpcm_adapt is
	
	signal pred_sample     : signed(16 downto 0) := (others => '0'); -- Predicted sample for next cycle. Initialize as 0.
	signal pred_sample_out : signed(15 downto 0) := (others => '0'); -- Predicted sample for next cycle. Initialize as 0.
	signal pred_index      : integer := 0; -- Predicted index for next cycle. Initialize as 0.
	
	signal sample_padded : signed(15 downto 0); -- Padded sample, algorithm is working with 16 bit numbers in this implementation. 
												-- Input signal scaled to 16 bit.
	
	
	-- Look up table for generating step signal to Quantizer and inverted Quantizer.
	signal	StepSizeTable : my_array_t1(integer range 0 to 88) := (7, 8, 9, 10, 11, 12, 13, 14, 16, 17,
												19, 21, 23, 25, 28, 31, 34, 37, 41, 45,
												50, 55, 60, 66, 73, 80, 88, 97, 107, 118,
												130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
												337, 371, 408, 449, 494, 544, 598, 658, 724, 796,
												876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,
												2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
												5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
												15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767);
												
	-- Look up table to generate index in StepSizeTable.											
	signal IndexTable	  : my_array_t1(integer range 0 to 15) := (-1, -1, -1, -1 , 2, 4, 6,8, -1, -1, -1, -1, 2, 4, 6, 8); 
																											
	
begin   

	ADAPT: process(Clock, Reset) is 
	
	begin
		
		-- Go back to initial "state".
		if (Reset = '1') then
		
			pred_sample     <= (others => '0'); 
			pred_sample_out <= (others => '0'); 
			pred_index <= 0;
		
		-- 
		elsif ( rising_edge(Clock) ) then
			
			-- Is the sign of Code_in negative / is MSB '1'?
			if(Code_in(N) = '1') then		
				pred_sample <=   to_signed( to_integer( (pred_sample_out) - ( Diffq_in) ), 17);	
			else
				pred_sample <=   to_signed( to_integer( (pred_sample_out) + ( Diffq_in) ), 17);	
			end if;
			
			
			--Instead of making IndexTable generic, index prediction is adapted to the number N.
			--(-1, -1, -1, -1,  2, 4, 6, -1, -1, -1, -1, 2, 4, 6, 8) if N = 3
			--(-1, -1, 2, 6, -1, -1, 2, 6)                         if N = 2
			--(-1, 2,-1, 2)                                        if N = 1
			
			-- to_integer( Code_in ) * (2**(3-N) might just look a bit cryptic...
			if( pred_index + IndexTable(to_integer( Code_in ) * (2**(3-N)) ) < 0 ) then
				pred_index <= 0;
			elsif( pred_index + IndexTable(to_integer( Code_in ) * (2**(3-N)) ) > 88 ) then
				pred_index <= 88;	
			else
				pred_index <= pred_index + IndexTable( to_integer(Code_in) * (2**(3-N)) ) ;
			end if;
			
		end if;
		
		
		--Prevent overflow/underflow
		
		if ( to_integer(pred_sample) >  ( (2**15) -1 ) ) then
	
			pred_sample_out <= to_signed( (2**15) - 1 , 16);
	
		elsif ( to_integer(pred_sample) < ( -(2**15) ) ) then
		
			pred_sample_out <= to_signed( -(2**15) , 16);
		
		else
			pred_sample_out <= to_signed( to_integer( pred_sample ), 16 );
	
		end if;
--		
	end process;
	
	
	Sample_padded <= Sample_in & "00000000"; -- Scale input signal to 16 bit.
	

	Diff_out <=  ( Sample_padded - pred_sample_out ); 
	Step_out <= to_signed(StepSizeTable(pred_index) , 16 ); 
	
	y_signal <= pred_sample_out(15 downto 8); -- Scale back output as an 8 bit number.
	
	
	-- This part might not be necessary since length of Code_in is generic in its declaration. Keep it if length of encoded should be 4 bits regardless
	-- of how we encode.
	
	-- y_code <= Code_in and to_unsigned(3 ,4); 
	-- y_code <= Code_in and to_unsigned(7 ,4); 
	-- y_code <= Code_in and to_unsigned(15 ,4); 
	
	-- y_code <= Code_in and to_unsigned((2**(N+1) -1 ), 4); 
	
end arch_adpcm_adapt;