library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vad_dominant_frequency is

	generic(
		
		Frame_size : integer := 64
	);
	
   port( 
		
		y_in  : in unsigned(15 downto 0);
		
		clock : in std_logic;
		reset : in std_logic;
		
		F : out unsigned(5 downto 0);
		
		clock_out : out std_logic
		
	);
end vad_dominant_frequency;

architecture arch_vad_dominant_frequency of vad_dominant_frequency is

	signal count : unsigned(5 downto 0)      := (others => '0');
	signal max_val : unsigned(15 downto 0)   := (others => '0');
	signal max_F : unsigned(5 downto 0)      := (others => '0');	
	signal rev_count : unsigned(5 downto 0);
	
begin

	rev_count <= ( count(0) & count(1) & count(2) & count(3) & count(4) & count(5) );
	
	process(clock, reset) 
	begin
		
		if (reset = '1') then
		
			count <= (others => '0');
			max_val <= (others => '0');
			max_F <= (others => '0');
			F     <= (others => '0');
		
		elsif ( rising_edge(clock) ) then
		
			if (  y_in > max_val  and ( rev_count > to_unsigned(0,6) ) and ( rev_count < to_unsigned(32,6) ) ) then
				
				max_val <= y_in;
				max_F <= rev_count;
				
			
			end if;
			
			if ( count >= to_unsigned(Frame_size-1, 6) ) then
			
				count <= (others => '0');
				F     <= max_F;
				max_val <= (others => '0');
				max_F <= (others => '0');
	
			else 
			
				count <= count + 1;
				
			end if;

		end if;

	end process;
	
	clock_out <= '1' when count = 0 else '0';

end arch_vad_dominant_frequency;