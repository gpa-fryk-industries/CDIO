library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twiddle_controller_W0 is
	
	generic (
	
		L : integer := 6
	);
	
	port( 
	
		clock    : in std_logic;
		reset    : in std_logic;
		tw_index : out unsigned(L-1 downto 0)

	);

end twiddle_controller_W0;

architecture arch_twiddle_controller_W0 of twiddle_controller_W0 is
	
	signal count : integer range 0 to 63 := 0;
																							 
begin


	process(clock,reset) is
	begin
		
		if reset = '1' then	

			count <= 0;

		elsif rising_edge(clock) then
		
			if(count >= (2**(L)-1)) then
			
				count <= 0;
				
			else	
			
				count <= count + 1;
			
			end if;
		end if;
	
	end process;
	
	process(count) 
	begin
		case(count) is
		
		when 0 => 
		 tw_index <= to_unsigned(0, L);
		when 1 => 
		 tw_index <= to_unsigned(2, L);
		when 2 => 
		 tw_index <= to_unsigned(4, L);
		when 3 => 
		 tw_index <= to_unsigned(6, L);
		when 4 => 
		 tw_index <= to_unsigned(8, L);
		when 5 => 
		 tw_index <= to_unsigned(10, L);
		when 6 => 
		 tw_index <= to_unsigned(12, L);
		when 7 => 
		 tw_index <= to_unsigned(14, L);
		when 8 => 
		 tw_index <= to_unsigned(16, L);
		when 9 => 
		 tw_index <= to_unsigned(18, L);
		when 10 => 
		 tw_index <= to_unsigned(20, L);
		when 11 => 
		 tw_index <= to_unsigned(22, L);
		when 12 => 
		 tw_index <= to_unsigned(24, L);
		when 13 => 
		 tw_index <= to_unsigned(26, L);
		when 14 => 
		 tw_index <= to_unsigned(28, L);
		when 15 => 
		 tw_index <= to_unsigned(30, L);
		when 16 => 
		 tw_index <= to_unsigned(0, L);
		when 17 => 
		 tw_index <= to_unsigned(1, L);
		when 18 => 
		 tw_index <= to_unsigned(2, L);
		when 19 => 
		 tw_index <= to_unsigned(3, L);
		when 20 => 
		 tw_index <= to_unsigned(4, L);
		when 21 => 
		 tw_index <= to_unsigned(5, L);
		when 22 => 
		 tw_index <= to_unsigned(6, L);
		when 23 => 
		 tw_index <= to_unsigned(7, L);
		when 24 => 
		 tw_index <= to_unsigned(8, L);
		when 25 => 
		 tw_index <= to_unsigned(9, L);
		when 26 => 
		 tw_index <= to_unsigned(10, L);
		when 27 => 
		 tw_index <= to_unsigned(11, L);
		when 28 => 
		 tw_index <= to_unsigned(12, L);
		when 29 => 
		 tw_index <= to_unsigned(13, L);
		when 30 => 
		 tw_index <= to_unsigned(14, L);
		when 31 => 
		 tw_index <= to_unsigned(15, L);
		when 32 => 
		 tw_index <= to_unsigned(0, L);
		when 33 => 
		 tw_index <= to_unsigned(3, L);
		when 34 => 
		 tw_index <= to_unsigned(6, L);
		when 35 => 
		 tw_index <= to_unsigned(9, L);
		when 36 => 
		 tw_index <= to_unsigned(12, L);
		when 37 => 
		 tw_index <= to_unsigned(15, L);
		when 38 => 
		 tw_index <= to_unsigned(18, L);
		when 39 => 
		 tw_index <= to_unsigned(21, L);
		when 40 => 
		 tw_index <= to_unsigned(24, L);
		when 41 => 
		 tw_index <= to_unsigned(27, L);
		when 42 => 
		 tw_index <= to_unsigned(30, L);
		when 43 => 
		 tw_index <= to_unsigned(33, L);
		when 44 => 
		 tw_index <= to_unsigned(36, L);
		when 45 => 
		 tw_index <= to_unsigned(39, L);
		when 46 => 
		 tw_index <= to_unsigned(42, L);
		when 47 => 
		 tw_index <= to_unsigned(45, L);
		when 48 => 
		 tw_index <= to_unsigned(0, L);
		when 49 => 
		 tw_index <= to_unsigned(0, L);
		when 50 => 
		 tw_index <= to_unsigned(0, L);
		when 51 => 
		 tw_index <= to_unsigned(0, L);
		when 52 => 
		 tw_index <= to_unsigned(0, L);
		when 53 => 
		 tw_index <= to_unsigned(0, L);
		when 54 => 
		 tw_index <= to_unsigned(0, L);
		when 55 => 
		 tw_index <= to_unsigned(0, L);
		when 56 => 
		 tw_index <= to_unsigned(0, L);
		when 57 => 
		 tw_index <= to_unsigned(0, L);
		when 58 => 
		 tw_index <= to_unsigned(0, L);
		when 59 => 
		 tw_index <= to_unsigned(0, L);
		when 60 => 
		 tw_index <= to_unsigned(0, L);
		when 61 => 
		 tw_index <= to_unsigned(0, L);
		when 62 => 
		 tw_index <= to_unsigned(0, L);
		when 63 => 
		 tw_index <= to_unsigned(0, L);			
		
		end case;
		
	end process;
end arch_twiddle_controller_W0;
	
	
