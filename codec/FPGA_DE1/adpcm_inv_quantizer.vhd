library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_inv_quantizer is

	generic (
	
		N : integer := 2
	
	);
	
   port( 
		
		Code_in   : in unsigned(N downto 0);
		Step_in   : in signed(15 downto 0);		
		Diffq_out : out signed(15 downto 0)
                  
	);
end adpcm_inv_quantizer;

architecture arch_adpcm_inv_quantizer of adpcm_inv_quantizer is
	
	type diffq_array is array (0 to N) of signed(15 downto 0);
	type step_array is array (0 to N) of signed(15 downto 0);
	
	signal diffq : diffq_array;
	signal step : step_array;
	
begin

	diffq(0) <= Step_in / 8;
	step(0) <= Step_in /  (2**(3-N));
	
	QUANTIZER: process(Code_in, Step_in) is 
	
	begin
	
		ADPCM_INV_QUANTIZER_GEN: for i in 0 to N-1 loop 
		
			if ( Code_in(N-1-i) = '1' ) then
				
				diffq(i+1) <= diffq(i) + step(i);		
			
			else
				
				diffq(i+1) <= diffq(i);
			
			end if;
				
			step(i+1) <= step(i) / 2;
			
		end loop;
		
	end process;
		
	Diffq_out <= diffq(N);

end arch_adpcm_inv_quantizer;



