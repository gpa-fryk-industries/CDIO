------------------------------------------------------------------------------
-- Generic dual clock RAM
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
	generic(
		MEM_ADDR_WIDTH : natural := 9;
		MEM_DATA_WIDTH : natural := 8
	);
	port(
		-- Write port
		write_en, wclk : in std_logic;
		waddr : in std_logic_vector (MEM_ADDR_WIDTH - 1 downto 0);
		din : in std_logic_vector (MEM_DATA_WIDTH - 1 downto 0);

		-- Read port
		rclk : in std_logic;
		raddr : in std_logic_vector (MEM_ADDR_WIDTH - 1 downto 0);
		dout : out std_logic_vector (MEM_DATA_WIDTH - 1 downto 0)
	);
end ram;

architecture ram_arch of ram is

	-- Inferred RAM 
	type mem_type is array ((2**MEM_ADDR_WIDTH) - 1 downto 0) of
	std_logic_vector(MEM_DATA_WIDTH - 1 downto 0);
	signal mem : mem_type;

begin

	-- Write process
	-- Write data into memory if enabled.
	--
	process (wclk)
		-- Write memory.
	begin
		if (wclk'event and wclk = '1') then
			if (write_en = '1') then
				mem(to_integer(unsigned(waddr))) <= din;
				-- Using write address bus.
			end if;
		end if;
	end process;

 	-- Read process
	-- Read data.
	--
	process (rclk) 
		-- Empty
	begin
		if (rclk'event and rclk = '1') then
			dout <= mem(to_integer(unsigned(raddr)));
			-- Using read address bus.
		end if;
	end process;
end ram_arch;
