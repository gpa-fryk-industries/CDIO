library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package mytypes_pkg_3 is

     type my_array_t1 is array (integer range <>) of integer;
	  
end package mytypes_pkg_3;

library IEEE;
use work.mytypes_pkg_3.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_adapt is
	
	generic (
		
		N : integer := 2
	
	);
	
   port( 
	
		Code_in     : in unsigned(N downto 0);
		Diffq_in    : in signed(15 downto 0);
		Sample_in   : in  signed(7 downto 0);
	
		Clock : in std_logic;
		Reset : in std_logic;
		
		y_code      : out unsigned(N downto 0);
		y_signal		: out signed(7 downto 0);
		
		Diff_out    : out signed(15 downto 0);
		Step_out    : out signed(15 downto 0)
                  
	);
end adpcm_adapt;

architecture arch_adpcm_adapt of adpcm_adapt is
	
	signal pred_sample     : signed(15 downto 0) := (others => '0');
	signal pred_sample_out : signed(15 downto 0) := (others => '0');
	signal pred_index      : integer := 0;
	
	signal sample_padded : signed(15 downto 0);
	
	signal	StepSizeTable : my_array_t1(integer range 0 to 88) := (7, 8, 9, 10, 11, 12, 13, 14, 16, 17,
												19, 21, 23, 25, 28, 31, 34, 37, 41, 45,
												50, 55, 60, 66, 73, 80, 88, 97, 107, 118,
												130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
												337, 371, 408, 449, 494, 544, 598, 658, 724, 796,
												876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,
												2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
												5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
												15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767);
												
	signal IndexTable	  : my_array_t1(integer range 0 to 7) := (-1, -1,  2, 6,  -1, -1,  2, 6); 
																									-- Make generic later!				
	
begin   

	ADAPT: process(Clock, Reset) is 
	
	begin
		
		if (Reset = '1') then
		
			pred_sample <= (others => '0');
			pred_index <= 0;
			
		elsif ( rising_edge(Clock) ) then
			
			if(Code_in(N) = '1') then
			
				pred_sample <= pred_sample - Diffq_in;	
			else
				pred_sample <= pred_sample +  Diffq_in;
			end if;
			
			
			if( pred_index + IndexTable(to_integer( Code_in)) < 0 ) then
				pred_index <= 0;
			elsif( pred_index + IndexTable(to_integer( Code_in )) > 88 ) then
				pred_index <= 88;	
			else
				pred_index <= pred_index + IndexTable( to_integer(Code_in) );
			end if;
			
		end if;

		
	end process;
	
	
--	process(pred_sample) begin
--	
--	if to_integer(pred_sample) >  ( (2**15) -1 )  then
--	
--		pred_sample_out <= to_signed( (2**15) - 1 , 16);
--	
--	elsif to_integer(pred_sample) < ( -(2**15) ) then
--		
--		pred_sample_out <= to_signed( -(2**15) , 16);
--		
--	else
--		pred_sample_out <= to_signed( to_integer( pred_sample ), 16 );
--	
--	end if;
--	
--	end process;
	
	Sample_padded <= Sample_in & "00000000";
	

	Diff_out <=  ( Sample_padded - pred_sample );
	Step_out <= to_signed(StepSizeTable(pred_index) , 16 );
	
	y_signal <= pred_sample(15 downto 8);
	
	y_code <= Code_in and to_unsigned((2**(N+1) -1 ) ,N+1);
	
end arch_adpcm_adapt;







