library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dds_nco is
	generic (
		LENGTH: integer := 16
	);
  	port (
  		-- Basic control
		clk, rst: in std_logic;

		-- NCO
		pha: in unsigned(LENGTH-1 downto 0);
		inc: in unsigned(LENGTH-1 downto 0);

		-- Output
		nco: out unsigned(LENGTH-1 downto 0)
  	);
end entity ; -- dds_nco

architecture arch_dds_nco of dds_nco is

	-- Numerically Controlled Oscillator
	-- Phase accumulator
	signal pha_acc: unsigned(LENGTH-1 downto 0);

begin

	-- Numerically Controlled Oscillator Process
	-- Generates the base oscillator
	NCOGEN : process( clk, rst )
	begin
		if rst = '0' then
			-- Reset to start phase
			pha_acc <= to_unsigned(0, pha_acc'length);

		elsif rising_edge(clk) then
			-- Increment phase
			pha_acc <= pha_acc + inc;
			
		end if ;
	end process ; -- NCOGEN

	-- Output with phase shift
	nco <= pha_acc + pha;

end architecture ; -- arch_dds_nco