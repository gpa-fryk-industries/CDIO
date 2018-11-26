library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		CLK_MCO, RST: in std_logic;
		ATT : out std_logic	
	);
end top;

architecture arch_top of top is
	signal test : std_logic;
begin


	process(CLK_MCO, RST)

	begin
		if rising_edge(CLK_MCO) then
			test <= not test;
		end if;
	
	end process;

	ATT <= test;

end arch_top;
