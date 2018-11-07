library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity r2_sdf_switch is

	generic (
	
		N_bit : integer := 10
	
	);

   port( 
	
		x_real : in signed(N_bit-1 downto 0);
		x_imag : in signed(N_bit-1 downto 0);
		
		y_real : out signed(N_bit-1 downto 0);
		y_imag : out signed(N_bit-1 downto 0);
		
		
		sel     : in std_logic
                  
	);
end r2_sdf_switch;

architecture arch_r2_sdf_switch of r2_sdf_switch is

begin

	process(sel,x_real,x_imag) is
	
	begin
	
	case sel is 
	
		when '0' => 
		
			y_real <= x_real;
			y_imag <= x_imag;
			
		
		when '1' =>
		
			y_real <= x_imag;
			y_imag <= x_real;
			
		
	end case;

	end process;
	
	
end arch_r2_sdf_switch;