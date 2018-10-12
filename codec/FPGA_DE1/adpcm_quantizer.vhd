library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_quantizer is

	generic (
	
		N : integer := 2
	
	);
	
	
   port( 

		Diff_in   : in signed(15 downto 0);	
		Step_in   : in signed(15 downto 0);	
		Code_out	 : out  unsigned(N downto 0)			
                  
	);
end adpcm_quantizer;

architecture arch_adpcm_quantizer of adpcm_quantizer is
	
	type diff_array is array (0 to N) of signed(15 downto 0);
	type step_array is array (0 to N) of signed(15 downto 0);
	
	signal diff : diff_array;
	signal step : step_array;
	signal code : unsigned(N downto 0) := (others => '0');
	
begin

	diff(0) <= to_signed(abs(to_integer(Diff_in)) , 16);
	step(0) <= Step_in;
	
	code(N) <= '1' when to_integer(Diff_in) < 0 else '0';
	
	
	QUANTIZER: process(Diff_in, Step_in) is 
	
	begin
	
		ADPCM_QUANTIZER_GEN: for i in 0 to N-1 loop 
		
			if ( diff(i) >= step(i) ) then
			
				code(N-1-i) <= '1';
				diff(i+1)   <= diff(i) - step(i);
			
			else
				
				code(N-1-i) <= '0';
				diff(i+1)   <= diff(i);
			
			end if;
			
			step(i+1) <= step(i) / 2;
			
		end loop;
		
	end process;
		
	Code_out <= code;	

end arch_adpcm_quantizer;



