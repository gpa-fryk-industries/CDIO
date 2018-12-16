library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vad_energy is

	generic (
	
		N : integer := 64
	
	);
	
   port( 
	
		clock         : in std_logic; -- Clock signal. 8 KHz in the moment of writing this.
		reset         : in std_logic; -- Reset signal. Reset module on '1'. 
		sample        : in signed(7 downto 0);
		
		e_out         : out unsigned(15 downto 0)

                  
	);
end vad_energy;

architecture arch_vad_energy of vad_energy is
	
	signal e_internal    : integer range 0 to 2**16 - 1 := 0;
	signal counter       : integer range 0 to N      := 0;
	
begin

	
	CALC_VAD_ENERGY: process(sample,clock,reset) is 
	begin
		
		if (reset = '1') then
		
			e_internal <= 0;
			counter <= 0;
			e_out <= (others => '0');

		-- 
		elsif ( rising_edge(clock) ) then
		
			if counter = N then
				
				e_out <= to_unsigned( e_internal , 16 );
				
				e_internal <= abs(to_integer(sample));
				counter <= 1;
				
				
			else
				e_internal <= e_internal + abs(to_integer(sample));
				counter <= counter + 1;
				
			end if;
			
		end if;
		
	end process;
	
	

end arch_vad_energy;