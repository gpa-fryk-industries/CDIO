library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		clk, rst: in std_logic;
		led : out std_logic	
	);
end top;

architecture arch_top of top is
begin


	process(clk, rst)

	begin
		if rising_edge(clk) then
			led <= not led;
		end if;
	end process;

end arch_top;
