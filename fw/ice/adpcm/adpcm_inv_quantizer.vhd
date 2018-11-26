library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_inv_quantizer is

	generic (
	
		N : integer := 3
	
	);
	
   port( 
		
		Code_in   : in unsigned(N downto 0); -- Encoded signal 
		Step_in   : in signed(15 downto 0);	-- Step signal from LUT StepSizeTable. See adpcm_adapt.vhd...
		Diffq_out : out signed(15 downto 0) -- Diffq output to adapt stage.
                  
	);
end adpcm_inv_quantizer;

architecture arch_adpcm_inv_quantizer of adpcm_inv_quantizer is
	
	-- Might just drop one of these array types since they are identical.
	type diffq_array is array (0 to N) of signed(15 downto 0);
	type step_array is array (0 to N) of signed(15 downto 0);
	
	signal diffq : diffq_array; --internal diffq signal.
	signal step : step_array; --internal step signal.
	
begin

	diffq(0) <= shift_right(Step_in, N); -- Bitshift 3 times. 
	step(0) <= shift_right(Step_in, 3-N); --Initalize step differently depending on N, i.e. bitshift Step_in differently. 
	
	-- Bring it. 
	INV_QUANTIZER: process(Code_in, Step_in) is 
	begin
	
		ADPCM_INV_QUANTIZER_GEN: for i in 0 to N-1 loop 
		
			if ( Code_in(N-1-i) = '1' ) then
				
				diffq(i+1) <= diffq(i) + step(i);		
			
			else
				
				diffq(i+1) <= diffq(i);
			
			end if;
				
			step(i+1) <= shift_right(step(i),1); --Bit shift to the next stage.
			
		end loop;
		
	end process;
		
	Diffq_out <= diffq(N); -- Set Diffq output to the Nth value in diffq array.

end arch_adpcm_inv_quantizer;



