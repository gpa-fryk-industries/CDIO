library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ten_bit_counter is

   port(
		Clock_enable : in  std_logic;
		Clock		: in 	std_logic; -- Clock signal
		Reset    : in  std_logic;
		Count_out: out std_logic_vector(7 downto 0); -- Data out
		Carry    : out std_logic
		
	);
end ten_bit_counter;

architecture arch_ten_bit_counter of ten_bit_counter is

   signal count: integer := 0; -- Counter that keeps track of each data signal.
	signal count_carry: integer := 0; -- Counter that keeps track of each data signal.
begin   

-- Process for Clock and reset.
process(Clock,Reset)

begin

	-- Reset all internal signals. "Initial state"
	
   if Reset = '1' then
	
         count <= 0;
			count_carry <= 0;
			
	-- Rising edge of clock signal.
	
   elsif(rising_edge(Clock)) then
	
		-- Pause signal set to 0 and we still have memory to read.
		if Clock_enable = '0' then
			
			count <= count + 1; 
			
			if count >= 255 then
				
				count <= 0;
				
				count_carry <= count_carry + 1;
								
			end if;

			if count_carry >= 4 then 
			
				count_carry <= 0;
			
			end if;
		
		end if;
		
	end if;
		
end process;
	
	Carry <= '1' when count_carry >= 4 else '0';
	Count_out <= conv_std_logic_vector(count, 8);
	
	
end arch_ten_bit_counter;