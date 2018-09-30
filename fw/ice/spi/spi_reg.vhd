library ieee;
use ieee.std_logic_1164.all;

entity spi_reg is
	generic(
		length	: integer := 8;
		CPOL	: boolean := false;
		CPHA	: boolean := false;
		CSAL	: std_logic := '0'
	);

	port (
		-- CTRL signals
		clk, rst: in std_logic;

		-- In/out port
		di	: in  std_logic_vector(length-1 downto 0);
		do	: out std_logic_vector(length-1 downto 0);

		-- SPI signals
		sck	: in  std_logic;
		si	: in  std_logic; 
		so	: out std_logic;
		cs	: in  std_logic  	
	);
end spi_reg;

-- Architecture
architecture arch_spi_reg of spi_reg is
	
	-- Storage and temp register
	signal serial_reg: std_logic_vector (length-1 downto 0);

begin

	-- Process CS and RST, MUST BE ASYNCHRONOUS!
	--
	LOAD_N_STORE: process(cs, rst, serial_reg)
		-- No variables
	begin
		if rst = '0' then	-- Clear DO and serial_reg on reset
			--serial_reg <= (others => '0');
			do <= (others => '0');

		elsif cs'event then -- Store or load serial_reg on falling edge of CS
            if cs = CSAL then
               -- serial_reg <= di;
            else
                do <= serial_reg;
            end if;
		end if;
	end process LOAD_N_STORE;


    -- Process spi shifting, obviusly synchronous
    --
    CPHA_0: if CPHA generate -- CPHA = 0

        SHIFT_IN: process(rst, si, sck)
            -- No variables
        begin
            if rst = '0' then
                serial_reg <= (others => '0');
            elsif rising_edge(sck) then
                serial_reg <= si & serial_reg(length-1 downto 1);
            end if;
        end process SHIFT_IN;

    end generate;

    CPHA_1: if not CPHA generate -- CPHA = 1

        SHIFT_IN: process(si, sck)
            -- No variables
        begin
            if rst = '0' then
                serial_reg <= (others => '0');
            elsif falling_edge(sck) then
                serial_reg <= si & serial_reg(length-1 downto 1);
            end if;
        end process SHIFT_IN;

    end generate;



	so <= serial_reg(0);

end arch_spi_reg;
