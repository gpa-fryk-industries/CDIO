library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity send_to_master is

	generic(
		
		L : integer := 16
		
	);
	

   port( 
	
		clock : in std_logic;
		reset : in std_logic;
		data_in  : in unsigned(L-1 downto 0);
		data_out : out std_logic
   
	);
end send_to_master;

architecture arch_send_to_master of send_to_master is

	signal count : integer := 0;
		
begin
--
	process(clock, reset)
	begin
	
		if reset = '1' then
			
			count <= 0;
					
		elsif(rising_edge(clock)) then
			
			if count >= 16 then
			
				data_out <= data_in(0);
				count <= 1;
			
			else
				
				data_out <= data_in(count);
				count <= count + 1;
			
			end if;

		end if;	
	
	end process;
	

end arch_send_to_master ;