------------------------------------------------------------------------------
-- Generic dual clock FIFO 
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_fifo is
	generic (
		FIFO_ADDR_WIDTH : natural := 9;
		FIFO_DATA_WIDTH : natural := 8
	);
	port (
		-- Control & Status
		rst: in std_logic;
		empty, full: out std_logic;

		-- In port
		write_en : in std_logic;
		wclk : in std_logic;
		din : in std_logic_vector (FIFO_DATA_WIDTH - 1 downto 0);

		-- Out port
		rclk : in std_logic;
		dout : out std_logic_vector (FIFO_DATA_WIDTH - 1 downto 0)
	);
end ram_fifo;

architecture ram_fifo_arch of ram_fifo is

	-- Inferred RAM 
	type mem_type is array ((2**FIFO_ADDR_WIDTH) - 1 downto 0) of
	std_logic_vector(FIFO_DATA_WIDTH - 1 downto 0);
	signal mem : mem_type;

	-- FIFO counters
	signal fifo_raddr, fifo_waddr: integer;

	-- FIFO start and stop indices
	constant FIFO_START: integer := 0;
	constant FIFO_END: integer := (2**FIFO_ADDR_WIDTH) - 1;

begin

	-- FIFO write process
	--
	--
	FIFO_WRITE : process (rst, wclk)
		-- Empty
	begin
		if rst = '0' then
			-- Reset write address
			fifo_waddr <= FIFO_START;

		elsif rising_edge(wclk) then

			-- Write if enabled
			if (write_en = '1') then
				mem(fifo_waddr) <= din;
				fifo_waddr <= fifo_waddr + 1;
			end if;

		end if;
	end process FIFO_WRITE;

	-- FIFO read process
	--
	--
	FIFO_READ : process (rst, rclk)
	begin
		if rst = '0' then
			-- Reset write address
			fifo_raddr <= FIFO_START;

		elsif rising_edge(rclk) then

			-- Read
			dout <= mem(fifo_raddr);
			fifo_raddr <= fifo_raddr + 1;

		end if;
	end process FIFO_READ;

	-- FIFO Status
	--
	--

	-- FIFO is empty when the read addr is the same as the write addr
	empty <= '1' when fifo_waddr = fifo_raddr else '0';

	-- FIFO is full when next write will overwrite the read addr
	full <= '1' when (fifo_waddr + 1) = fifo_raddr else '0';
	
end ram_fifo_arch;