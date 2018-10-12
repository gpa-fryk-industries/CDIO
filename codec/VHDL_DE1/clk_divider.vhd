library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity clock_divider is 
generic (M: integer := 2); 
port (clock_in: in std_logic;
		clock_out: out std_logic);
end entity clock_divider;

architecture arch_clock_divider of clock_divider is

signal n: integer range 0 to 3 := 0;
signal clk: std_logic := '0';

begin 
	process(clock_in)
	begin 
		if rising_edge(clock_in) then n <= n + 1; -- F_clock_out = (F_clock_in)/(M+1)
			if n >= M then 
				clk <= not clk;
				n <= 0;

			end if;
		end if; 
	end process;
	
	clock_out <= clk;
end architecture arch_clock_divider;
				
		