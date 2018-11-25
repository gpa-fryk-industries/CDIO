library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity class_d_counter is
	
	generic(
		
		N_bit : integer := 8
		
		);
	
   port(
	
		clock		    : in  std_logic;
		reset        : in  std_logic;
		count_out        : out signed(N_bit-1 downto 0)
		
	);
end class_d_counter;

architecture arch_class_d_counter of class_d_counter is

   signal count: integer := -(2**(N_bit-1));
	
begin   

-- Process for clock and reset.
process(clock,reset)

begin

	-- Reset all internal signals. "Initial state"
	
   if Reset = '1' then
	
         count <= -(2**(N_bit-1));
			
   elsif(rising_edge(Clock)) then
			
		if count >= (2**(N_bit-1))-1 then
			
			count <= -(2**(N_bit-1));
							
		end if;
			
		count <= count + 1; 
		
	end if;
		
end process;
	
	count_out <= to_signed(count, N_bit);
	
end arch_class_d_counter;