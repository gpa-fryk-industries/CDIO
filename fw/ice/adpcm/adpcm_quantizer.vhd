library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_quantizer is

	generic (
	
		N : integer := 2
	
	);
	
   port( 

		Diff_in   : in signed(15 downto 0);	-- Difference between Sample and predicted sample.
		Step_in   : in signed(15 downto 0);	-- Step from LUT StepSizeTable. See adpcm_adapt.vhd.
		Code_out	 : out  unsigned(3 downto 0) -- Encoded output.		 	
                  
	);
end adpcm_quantizer;

architecture arch_adpcm_quantizer of adpcm_quantizer is
	
	-- Might just drop one of these array types since they are identical.
	type diff_array is array (0 to N) of signed(15 downto 0);
	type step_array is array (0 to N) of signed(15 downto 0);
	
	signal diff : diff_array; -- internal diff signal.
	signal step : step_array; -- internal step signal.
	signal code : unsigned(3 downto 0) := (others => '0'); -- internal code signal.
	
begin

	-- Initial values in the combinatorial net that is the quantizer.
	diff(0) <= to_signed(abs(to_integer(Diff_in)) , 16); -- diff signal is always a positive number. Make unsigned maybe?
	step(0) <= Step_in; --Initial value set to Step_in;
	code(N) <= '1' when to_integer(Diff_in) < 0 else '0'; -- Set MSB to '1' if Diff_in is negative, i.e. set Sign bit.
	
	
	-- HERE WE GO. GENERIC QUANTIZER. Repeat net depending on N. 
	QUANTIZER: process(Diff_in, Step_in) is 
	begin
	
		ADPCM_QUANTIZER_GEN: for i in 0 to N-1 loop 
		
			if ( diff(i) >= step(i) ) then
			
				code(N-1-i) <= '1'; -- Set (N-1-i)'s bit of code. Try to pronounce that. 
				diff(i+1)   <= diff(i) - step(i);
			
			else
				
				code(N-1-i) <= '0'; 
				diff(i+1)   <= diff(i);
			
			end if;
			
			step(i+1) <= shift_right(step(i),1); --Bit shift step for next stage.
			
		end loop;
		
	end process;
	
		
	Code_out <= to_unsigned(to_integer(code),4); --All bits of code should be set. This is the encoded output also, worth noting. 

end arch_adpcm_quantizer;