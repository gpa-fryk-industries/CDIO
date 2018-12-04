library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vad_energy is

	generic (
	
		N : integer := 128
	
	);
	
   port( 
	
		Clock         : in std_logic; -- Clock signal. 8 KHz in the moment of writing this.
		Reset         : in std_logic; -- Reset signal. Reset module on '1'. 
		Sample        : in signed(7 downto 0);
		
		E_out         : out unsigned(15 downto 0);
		
		counter_debug : out unsigned(15 downto 0)
		

                  
	);
end vad_energy;

architecture arch_vad_energy of vad_energy is
	
	signal e_internal    : integer range 0 to 2**24 - 1 := 0;
	signal counter       : integer range 0 to 2**7      := 0;
	
begin

	
	CALC_VAD_ENERGY: process(Sample) is 
	begin
		
		-- Go back to initial "state".
		if (Reset = '1') then
		
			e_internal <= 0;
			counter <= 0;
			E_out <= (others => '0');

		-- 
		elsif ( rising_edge(Clock) ) then
		
			if counter = N then
				
				E_out <= to_unsigned( ( e_internal / N ) , 16 );
				
				e_internal <= ( to_integer(Sample)*to_integer(Sample) );
				counter <= 1;
				
				
			else
				e_internal <= e_internal + ( to_integer(Sample) * to_integer(Sample));
				counter <= counter + 1;
				
			end if;
			
		end if;
		
	end process;
	
	counter_debug <= to_unsigned(counter, 16);
	

end arch_vad_energy;