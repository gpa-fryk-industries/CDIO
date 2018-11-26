library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pdm_counter is
	
	generic(
		
		N_bit : integer := 8
		
	);
	
   port( 
		
		pdm_in   : in std_logic;
		clock    : in std_logic;
		reset    : in std_logic;
		data_out : out unsigned(N_bit - 1 downto 0)
                  
	);
end pdm_counter;

architecture arch_pdm_counter of pdm_counter is

	signal count : integer := 0;
	signal data  : unsigned(N_bit-1 downto 0);
		
begin

	process(clock, reset)
	begin
	
		if reset = '1' then
			
			count <= 0; 
			data  <= (others => '0');
			
		elsif(rising_edge(clock)) then
			
			if (pdm_in = '1') then
			
				data <= data + 1;	
						end if;
			
			
			if ( count >= (2**(N_bit)-1) ) then
				
				data_out <= data;
				
				count    <= 0;	
				data     <= (others => '0');
			
			else 
			
				count <= count + 1;
				
			end if;

		end if;	
	
	end process;

end arch_pdm_counter ;