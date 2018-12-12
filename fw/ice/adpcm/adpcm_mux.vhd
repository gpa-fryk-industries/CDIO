library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_mux is
	
   port( 
	
		mode : in std_logic; --rx/tx'
	
		code_in_rx : in unsigned(3 downto 0);
		code_in_tx : in unsigned(3 downto 0);
		
		code_out   : out unsigned(3 downto 0)
		
	);
end adpcm_mux;

architecture arch_adpcm_mux of adpcm_mux is
begin
	
	process(mode, code_in_rx, code_in_tx) 
	begin
		
		if(mode = '0') then
			code_out <= code_in_tx;
		else
			code_out <= code_in_rx;
		end if;
		
	end process;


end arch_adpcm_mux;