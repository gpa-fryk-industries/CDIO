library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twiddle_controller is
	
	generic (
	
		L : integer := 4;
		Stage: integer := 2
	);
	
	port( 
	
		clock    : in std_logic;
		reset    : in std_logic;
		tw_index : out unsigned(L-1 downto 0)

	);

end twiddle_controller;

architecture arch_twiddle_controller of twiddle_controller is
	
	type stateType is (s0, s1, s2, s3);
   signal present_state, next_state : stateType;
	
	signal slow_count : integer range 0 to 3;
	signal fast_count : integer range 0 to 15;
																							 
begin

    process(present_state) is
    begin 
        
        case present_state is
            when s0 => next_state <= s1;
				
					slow_count <= 2;
					
            when s1 => next_state <= s2;
					
					slow_count <= 1;
				
            when s2 => next_state <= s3;
				
					slow_count <= 3;
				
				when s3 => next_state <= s0;
				
					slow_count <= 0;
				
				when others => next_state <= s0;
					slow_count <= 0;
					
        end case;
		  
    end process; 
	

	process(clock,reset) is
	begin
		
		if reset = '1' then
		
			present_state <= s0;
			fast_count <= 0;

		elsif rising_edge(clock) then
		
			if(fast_count >= (2**(L-Stage)-1)) then
			
				fast_count <= 0;
				present_state <= next_state;
				
			else	
			
				fast_count <= fast_count + 1;
			
			end if;
		end if;
	
	end process;
	
	tw_index <= to_unsigned((slow_count*fast_count*( 2**(Stage-2) )), L);
	

end arch_twiddle_controller;
	
	
