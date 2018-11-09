library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity butterfly_r2_I_complete is

	generic (
	
		M_bit : integer := 10;
		Z     : integer := 1
	
	);

	port( 
	
		x_real : in signed(M_bit-1 downto 0);
		x_imag : in signed(M_bit-1 downto 0);
		
		y_real : out signed(M_bit-1 downto 0);
		y_imag : out signed(M_bit-1 downto 0);
		
		clock   : in std_logic;
		reset   : in std_logic;
		s       : in std_logic

			
	);

end butterfly_r2_I_complete;

architecture arch_butterfly_r2_I_complete of butterfly_r2_I_complete is


-- Delay line	
component delay_line
	generic (
		D        : integer;
		N_bit    : integer
	);	
	port (
		
		x_real : in signed(N_bit-1 downto 0);
		x_imag : in signed(N_bit-1 downto 0);
		
		y_real : out signed(N_bit-1 downto 0);
		y_imag : out signed(N_bit-1 downto 0);
		
		clock   : in std_logic;
		reset   : in std_logic
	);
end component;


-- Butterfly 
component r2_butterfly
	generic (
		N_bit    : integer
	);	
	port (
		
		x1_real : in signed(N_bit-1 downto 0);
		x1_imag : in signed(N_bit-1 downto 0);
		
		x2_real : in signed(N_bit-1 downto 0);
		x2_imag : in signed(N_bit-1 downto 0);
		
		y1_real : out signed(N_bit-1 downto 0);
		y1_imag : out signed(N_bit-1 downto 0);
		
		y2_real : out signed(N_bit-1 downto 0);
		y2_imag : out signed(N_bit-1 downto 0)

	);
end component;


-- Complex mux
component complex_mux 

	generic (
	
		N_bit : integer
	
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
end component;


	type Z_array is array (0 to 3) of signed(M_bit-1 downto 0);
	
	signal Z_real : Z_array;
	signal Z_imag : Z_array;
																				 
begin


	BFI   : r2_butterfly
	generic map( M_bit )  
	port map(Z_real(0) ,Z_imag(0) , x_real, x_imag, Z_real(1), Z_imag(1), Z_real(2), Z_imag(2));
	
	CMUX1 : complex_mux
	generic map( M_bit )  
	port map(Z_real(0), Z_imag(0), Z_real(1), Z_imag(1), y_real, y_imag, s);
	
	CMUX2 : complex_mux
	generic map( M_bit )  
	port map(x_real, x_imag, Z_real(2), Z_imag(2), Z_real(3), Z_imag(3), s);
	
	D1    : delay_line
	generic map( Z, M_bit )  
	port map(Z_real(3), Z_imag(3), Z_real(0), Z_imag(0), clock, reset);
	

end arch_butterfly_r2_I_complete;