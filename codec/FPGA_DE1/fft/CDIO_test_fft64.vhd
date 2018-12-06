library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity fft_64_point_tester is

	generic (
	
		Z_bit : integer := 8
	
	);

	port( 
		
		data_re   : in std_logic;
		data_im   : in std_logic;
		clock1  : in std_logic;
		clock2  : in std_logic;
		--master_clock: in std_logic;
		reset  : in std_logic;
		data_out : out std_logic
		

	);

end fft_64_point_tester;

architecture arch_fft_64_point_tester of fft_64_point_tester is



component test_input
   
	port( 
	
		data       : in std_logic; 
		clock      : in std_logic;
		reset      : in std_logic;
		data_out   : out signed(7 downto 0);
		clock_out  : out std_logic
		
	);
	
end component;



component fft_64_point
	
	generic (
	
		M_bit : integer
	
	);

	port( 
	
		x_real : in signed(M_bit-1 downto 0);
		x_imag : in signed(M_bit-1 downto 0);
		
		y_real : out signed(M_bit+5 downto 0);
		y_imag : out signed(M_bit+5 downto 0);

		clock   : in std_logic;
		--master_clock : in std_logic;
		reset   : in std_logic

	);
	
end component;



component fft_abs_value

	generic (
	
		N_bit : integer := 8;
		Stage : integer := 2
	);
	
   port( 
		
		x_real : in signed(Stage + N_bit downto 0);
		x_imag : in signed(Stage + N_bit downto 0);
		
		y_abs : out unsigned(2*N_bit -1 downto 0)
				
	);

end component;


component send_to_master
	
	generic(
		
		L : integer
		
	);
	

   port( 
	
		clock : in std_logic;
		reset : in std_logic;
		--data_in  : in unsigned(L-1 downto 0);
		data_in  : in signed(13 downto 0);
		data_out : out std_logic
   
	);


end component;

	signal Z1   : signed(Z_bit-1 downto 0);
	signal Z2   : signed(Z_bit-1 downto 0);
	signal co   : std_logic;
	signal Z3   : signed(Z_bit+5 downto 0);
	signal Z4   : signed(Z_bit+5 downto 0);
	signal Z5   : unsigned(15 downto 0);
	
begin

	t_re : test_input
	port map(data_re, clock1, reset, Z1, co);
	
	r_im : test_input
	port map(data_im, clock1, reset, Z2, open);
	
	fft : fft_64_point
	generic map(Z_bit)
	port map(Z1,Z2,Z3,Z4,co,reset);
	
	abs_v : fft_abs_value
	generic map(Z_bit, 5)
	port map(Z3,Z4, Z5);
	
	--stm : send_to_master
	--generic map(16)
	--port map(clock2,reset,Z5, data_out);
	
	stm : send_to_master
	generic map(16)
	port map(clock2,reset,Z3, data_out);
	

end arch_fft_64_point_tester;