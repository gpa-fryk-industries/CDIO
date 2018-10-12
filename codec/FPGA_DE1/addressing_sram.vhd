library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity addressing_unit is

	generic(
	
		N_samples : integer := 10000
	);
	
   port( 
	
		Reset: in std_logic; -- Reset signal
		Clock_enable: in std_logic; -- Pause signal, Active low
		Clock: in std_logic; -- Clock signal
		PWM_enable: out std_logic; 

		Address_out : out std_logic_vector(13 downto 0)); -- Address to memory

		
end addressing_unit;

architecture arch_addressing_unit of addressing_unit is
	
	signal address_counter : integer range 0 to N_samples := 0; -- Address counter. Increment after we have read each data signal 4 times. See temp, temp2.
	
begin   

-- Process for Clock and reset.
process(Clock,Reset)

begin

	-- Reset all internal signals. "Initial state"
	
   if Reset = '1' then
	
			address_counter <= 0;
			
	-- Rising edge of clock signal.
	
   elsif(rising_edge(Clock)) then
	
		-- Pause signal set to 0 and we still have memory to read.
		if Clock_enable = '0' and address_counter < N_samples then
		
			address_counter <= address_counter + 1;	
		
		end if;
		
	end if;
		
end process;

	Address_out <= conv_std_logic_vector(address_counter,14);
	PWM_enable <= '1' when address_counter >= N_samples or Clock_enable = '1' or Reset = '1' else '0';
	
end arch_addressing_unit;