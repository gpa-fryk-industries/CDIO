library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity r2_butterfly_II is

	generic (
	
		N_bit : integer := 10
	
	);

   port( 
	
		x1_real : in signed(N_bit-1 downto 0);
		x1_imag : in signed(N_bit-1 downto 0);
		
		x2_real : in signed(N_bit-1 downto 0);
		x2_imag : in signed(N_bit-1 downto 0);
		
		y1_real : out signed(N_bit-1 downto 0);
		y1_imag : out signed(N_bit-1 downto 0);
		
		y2_real : out signed(N_bit-1 downto 0);
		y2_imag : out signed(N_bit-1 downto 0);
		
		sel     : in std_logic
                  
	);
end r2_butterfly_II;

architecture arch_r2_butterfly_II of r2_butterfly_II is
		
begin

	process(sel,x1_real,x1_imag,x2_real,x2_imag) is
	
	begin
	
		case sel is
	
		when '0' => 
		
			y1_real <= x1_real + x2_real;
			y1_imag <= x1_imag + x2_imag;
		
			y2_real <= x1_real - x2_real;
			y2_imag <= x1_imag - x2_imag;
			
		when '1' =>
			
			y1_real <= x1_real + x2_real;
			y1_imag <= x1_imag - x2_imag;
		
			y2_real <= x1_real - x2_real;
			y2_imag <= x1_imag + x2_imag;

	end case;
	
	end process;
end arch_r2_butterfly_II;