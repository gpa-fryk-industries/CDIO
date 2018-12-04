library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		-- Control
		CLK_MCO, RST, MINH: in std_logic;
		ATT: out std_logic;

		-- SPI
		SPI_SO: out std_logic;
		SPI_SCK: in std_logic;
		SPI_SS: in std_logic;
		SPI_SI: in std_logic;

		-- Microphone
		MIC_DAT: in std_logic;
		MIC_CLK: out std_logic;

		-- Speakers
		SPK_R, SPK_L, SPK_A: out std_logic
	);
end top;

architecture arch_top of top is
	signal div2 : std_logic;

	-- SPI signals
	signal spi_reg: std_logic_vector(7 downto 0);
begin

	-- Test process --
	-- Creates a clock on ATT from CLK_MCO/2
	--
	TEST: process(CLK_MCO, RST)
		-- Nothing
	begin
		if rising_edge(CLK_MCO) then
			div2 <= not div2;
		end if;
	
	end process; --TEST

	-- Output to ATT
	ATT <= div2;

	-- Output MCO to MIC clock
	MIC_CLK <= CLK_MCO;


	-- SPI process --
	-- Handles SPI interface with master MCU
	-- Note: Read on rising edge, MSB first
	--
	SPI_PROC: process(SPI_SS, SPI_SCK, SPI_SI)
		-- Nothing
	begin
		
		if RST = '0' then
			-- In reset
			-- Clear SPI register
			spi_reg <= (others => '0');
			-- Keep SO hiZ
			SPI_SO <= 'Z';
			
		elsif SPI_SS = '0' then
			-- Selected
			if(rising_edge(SPI_SCK)) then
				-- Read data on rising edge
				spi_reg <= spi_reg(6 downto 0) & SPI_SI;
			end if;
			
			-- Output last bit to SO
			SPI_SO <= spi_reg(7);

		else
			-- Not selected
			-- Keep SO hiZ
			SPI_SO <= 'Z';
		end if;
		
	end process; --SPI_PROC

end arch_top;
