library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity complex_mux is

	generic (
	
		N_bit : integer := 10
	
	);

   port( 
	
		x1_real : in signed(N_bit-1 downto 0);
		x1_imag : in signed(N_bit-1 downto 0);
		
		x2_real : in signed(N_bit-1 downto 0);
		x2_imag : in signed(N_bit-1 downto 0);
		
		y_real : out signed(N_bit-1 downto 0);
		y_imag : out signed(N_bit-1 downto 0);
		
		
		sel     : in std_logic
                  
	);
end complex_mux ;

architecture complex_mux  of complex_mux  is

begin

	process(sel,x1_real,x1_imag,x2_real,x2_imag) is
	
	begin
	
	case sel is 
	
		when '0' => 
		
			y_real <= x2_real;
			y_imag <= x2_imag;
			
		
		when '1' =>
		
			y_real <= x1_real;
			y_imag <= x1_imag;
			
		
	end case;
	
	
	end process;
	
	
end complex_mux;