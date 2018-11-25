library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_counter is


	
	port( 
	
		clock : in std_logic;
		reset : in std_logic;
		
		sel0   : out std_logic;
		sel1   : out std_logic;
		sel2   : out std_logic;
		sel3   : out std_logic

			
	);

end test_counter;

architecture arch_test_counter of test_counter is

	signal count : unsigned(3 downto 0) := (others => '0');	
																							 
begin

	process(clock,reset) is
	begin
		
		if reset = '1' then
				count <= (others => '0');

		elsif rising_edge(clock) then
		
			if count >= to_unsigned(15, 4) then
		
				count <= (others => '0');
			else
			
				count <= count + 1;
			
			end if;
	
		end if;
	
	end process;
	
	
	sel0 <= count(0);
	sel1 <= count(1);
	sel2 <= count(2);
	sel3 <= count(3);

end arch_test_counter;
	
	
