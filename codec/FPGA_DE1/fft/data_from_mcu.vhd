library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_input is

   port( 
	
		data       : in std_logic;
		clock      : in std_logic;
		reset      : in std_logic;
		data_out   : out signed(7 downto 0);
		clock_out  : out std_logic
		
	);
end test_input;

architecture arch_test_input of test_input is
	signal count : unsigned(3 downto 0) := (others => '0');
	signal data_internal : signed(7 downto 0) := (others => '0');
	
	
begin   

	process(reset, clock) 
	begin
		
		if reset = '1' then
		
			count <= to_unsigned(0,4);
		
		elsif rising_edge(clock) then
			
			if count >= to_unsigned(8,4) then
				
				clock_out <= '1';
				count <= to_unsigned(1,4);
				
			else
				
				clock_out <= '0';
				count <= count + 1;
			
			end if;
			
			data_internal(to_integer(count(2 downto 0))) <= data;
			
		end if;
	
	end process;
	
	data_out <= data_internal;
	
	
	
end arch_test_input;

	
