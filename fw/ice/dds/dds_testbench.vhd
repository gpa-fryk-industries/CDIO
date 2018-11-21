library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--use work.design.all;

entity dds_testbench is

end entity ; -- dds_testbench

architecture arch_dds_testbench of dds_testbench is

	signal nco_pha_acc: unsigned(15 downto 0) := (others => '0');
    signal dds: signed(15 downto 0) := (others => '0');
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';

begin
	 
  	
     
	-- Clock gen
	-- Generates test clock
	CLKGEN : process
	begin
		clk <= '0';
        wait for 100 us;
        clk <= '1';
        wait for 100 us;
	end process; -- CLKGEN
    
    RSTGEN: process
    begin
        wait for 250 us;
        rst <= '1';
    end process; -- RSTGEN
    
    -- NCO GENERATOR
    NCOGEN: entity dds_nco(arch_dds_nco)
    	port map(
        	clk => clk, rst => rst,
            pha => to_unsigned(0, 16),
            inc => to_unsigned(200, 16),
            nco => nco_pha_acc
            
        );
    
    -- DDS GENERATOR
    DDSGEN: entity dds_wav(arch_dds_wav) 
    	port map (
        	clk => clk,
            rst => rst,
            nco => nco_pha_acc,
            waveform => "00",
            dds => dds
        );



end architecture ; -- arch_dds_testbench









