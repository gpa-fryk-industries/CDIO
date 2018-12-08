library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier_MAC16 is
	
	generic(
		N_bit : integer := 2;
		M_bit : integer := 2
	);
	
	port( 
	
		x : in signed(N_bit-1 downto 0);
		y : in signed(M_bit-1 downto 0);
		
		ans   : out signed(N_bit+M_bit-1 downto 0);
		
		clock : in std_logic

	);

end multiplier_MAC16 ;

architecture arch_multiplier_MAC16  of multiplier_MAC16  is
	
	signal a : signed(N_bit-1 downto 0) := (others => '0');
	signal b : signed(M_bit-1 downto 0) := (others => '0');
	
	signal mult_out : signed(M_bit+N_bit-1 downto 0) ;
						
begin
	
	mult_out <= a*b;
	
	process(clock) 
	begin
		if(rising_edge(clock)) then
	
			a <= x;
			b <= y;
			
			ans <= mult_out;
			
		end if;
	end process;
	
end arch_multiplier_MAC16 ;
	
	
