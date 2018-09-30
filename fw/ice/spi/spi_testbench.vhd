library ieee;
use ieee.std_logic_1164.all;

entity spi_testbench is
end spi_testbench;

architecture arch_spi_testbench of spi_testbench is
    signal input  : std_logic_vector(7 downto 0);
    signal output : std_logic_vector(7 downto 0);
    signal si, so, rst, sck, cs : std_logic;
begin

    reg: entity work.spi_reg port map (
        rst => rst,
        clk => '0',

        sck => sck,
        si => si,
        so => so,
        cs => cs,

        di => input,
        do => output
    );

    stim_proc: process
    begin
        input <= "10101010";
        rst <= '0';
        cs <= '1';
        si <= '0';
        sck <= '0';

        wait for 10 ns;
        rst <= '1';

        wait for 10 ns;
        cs <= '0'; wait for 10 ns;
            assert output = "0" report "#0 failed";
            sck <= '1'; wait for 10 ns; si <= '0'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#1 failed";
            sck <= '1'; wait for 10 ns; si <= '0'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#2 failed";
            sck <= '1'; wait for 10 ns; si <= '0'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#3 failed";
            sck <= '1'; wait for 10 ns; si <= '0'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#4 failed";
            sck <= '1'; wait for 10 ns; si <= '1'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#5 failed";
            sck <= '1'; wait for 10 ns; si <= '1'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#6 failed";
            sck <= '1'; wait for 10 ns; si <= '1'; wait for 10 ns; sck <= '0'; wait for 20 ns;
            assert output = "0" report "#7 failed";
            sck <= '1'; wait for 10 ns; si <= '1'; wait for 10 ns; sck <= '0'; wait for 20 ns;
        cs <= '1'; wait for 10 ns;
        assert output = "00001111" report "DO failed";
        report "Full adder testbench finished";
        wait;
    end process;
end;