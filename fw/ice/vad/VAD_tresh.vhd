library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vad_tresh is

	generic(

		N : integer := 128
		
	);
	
   port( 
		
		clock : in std_logic;
		reset : in std_logic;
		
		F : in unsigned(5 downto 0);
		E : in unsigned(15 downto 0);
		
		E_tresh : in unsigned(15 downto 0);
	
		voice : out std_logic
		
	);
end vad_tresh;

architecture arch_vad_tresh of vad_tresh is

	signal E_mod_tresh : unsigned(15 downto 0);
	
	signal count       : integer := 0;
	signal f_voice     : std_logic := '0';
	signal e_voice     : std_logic := '0';
	
begin
	
	process(clock, reset, F, E, E_tresh, E_mod_tresh) 
	begin
		
		if ( reset = '1' ) then 
		
			E_mod_tresh <= E_tresh;
			count <= 0;
		
		elsif( rising_edge(clock) ) then
		
			-- Energy
			if ( E >= E_mod_tresh ) then
			
				E_mod_tresh <= E_tresh;
				e_voice <= '1';
				
			else
				
				E_mod_tresh <= E_mod_tresh - 2;
				e_voice <= '0';

			end if;
			
			
			-- Frequency 
			if ( F > to_unsigned(0,6) and F < to_unsigned(5,6) ) then
				
				f_voice <= '1';
								
			else
				
				f_voice <= '0';
		
			end if;
			
			
			-- VAD		
			if ( f_voice = '1' and e_voice = '1' ) then
				
				voice <= '1';
				
				count <= 0;
			else
				
				
				count <= count + 1;
				
				if count > 5 then
					
					voice <= '0';
					
				else
				
					voice <= '1';
					
				end if;
				
			end if;
			
		end if;


	end process;

end arch_vad_tresh;