library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_control_counter is
	
	generic (
	
		L : integer := 4
	
	);
	
	port( 
	
		clock : in std_logic;
		reset : in std_logic;
		
		sel  : out unsigned(L-1 downto 0)


	);

end fft_control_counter;

architecture arch_fft_control_counter of fft_control_counter is

	signal count : unsigned(L-1 downto 0) := (others => '0');	
																							 
begin

	process(clock,reset) is
	begin
		
		if reset = '1' then
		
				count <= (others => '0');

		elsif rising_edge(clock) then
		
			if count >= to_unsigned( (2**L)-1, L) then
		
				count <= (others => '0');
			else
			
				count <= count + 1;
			
			end if;
	
		end if;
	
	end process;
	
	sel <= count;

end arch_fft_control_counter;
	
	
