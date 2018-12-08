library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity fft_64_point is

	generic (
	
		M_bit : integer := 8
	
	);

	port( 
	
		x_real : in signed(M_bit-1 downto 0);
		x_imag : in signed(M_bit-1 downto 0);
		
		y_real : out signed(M_bit+5 downto 0);
		y_imag : out signed(M_bit+5 downto 0);

		clock   : in std_logic;
		master_clock : in std_logic;
		reset   : in std_logic

	);

end fft_64_point;

architecture arch_fft_64_point of fft_64_point is


--BFI
component r2_BFI

	generic (
		
		N_bit : integer;
		Stage : integer; 
		D     : integer 
	
	);

   port( 
	
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit downto 0);
		y_imag : out signed(Stage + N_bit downto 0);
		
		clock  : in std_logic;
		reset  : in std_logic;
		s      : in std_logic
                  
	);
end component;

--BFII
component r2_BFII

	generic (
	
		N_bit : integer;
		Stage : integer;
		D     : integer
	
	);

   port( 
	
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit downto 0);
		y_imag : out signed(Stage + N_bit downto 0);
		
		clock  : in std_logic;
		reset  : in std_logic;
		s    : in std_logic;
		t    : in std_logic
                  
	);
end component;


--Multiplier
component twiddle_multiplier_single
	
	generic (
	
		N_bit : integer;
		Stage : integer
	);
	
   port( 
	
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit-1 downto 0);
		y_imag : out signed(Stage + N_bit-1 downto 0);
		
		clock  : in std_logic;
		reset : in std_logic;
		
		twiddle_real : in signed(N_bit downto 0);
		twiddle_imag : in signed(N_bit downto 0)
				
	);
end component;


--Controller
component twiddle_controller
	
	generic (
	
		L : integer;
		Stage: integer
	);
	
	port( 
	
		clock    : in std_logic;
		reset    : in std_logic;
		tw_index : out unsigned(L-1 downto 0)

	);

end component;


--LUT
component fft_twiddle_lut
	
	generic (
	
		N_bit : integer;
		L     : integer
	);
	
	port( 
	
		
		tw_index_0 : in unsigned(L-1 downto 0);
		tw_index_1 : in unsigned(L-1 downto 0);
		
		twiddle_real_0 : out signed(N_bit downto 0);
		twiddle_imag_0 : out signed(N_bit downto 0);
		
		twiddle_real_1 : out signed(N_bit downto 0);
		twiddle_imag_1 : out signed(N_bit downto 0)
		
	);

end component;

--Control counter
component fft_control_counter 
	
	generic (
	
		L : integer
	
	);
	
	port( 
	
		clock : in std_logic;
		reset : in std_logic;
		
		sel  : out unsigned(L-1 downto 0)

	);

end component;

	signal counter   : unsigned(5 downto 0);
	
	signal TW0_index : unsigned(5 downto 0);
	signal TW1_index : unsigned(5 downto 0);
	
	signal TW0_real  : signed(M_bit downto 0);
	signal TW0_imag  : signed(M_bit downto 0);
	signal TW1_real  : signed(M_bit downto 0);
	signal TW1_imag  : signed(M_bit downto 0);
	
	signal Z1_real   : signed(M_bit downto 0);
	signal Z1_imag   : signed(M_bit downto 0);
	signal Z2_real   : signed(M_bit+1 downto 0);
	signal Z2_imag   : signed(M_bit+1 downto 0);
	signal Z3_real   : signed(M_bit+1 downto 0);
	signal Z3_imag   : signed(M_bit+1 downto 0);
	signal Z4_real   : signed(M_bit+2 downto 0);
	signal Z4_imag   : signed(M_bit+2 downto 0);
	signal Z5_real   : signed(M_bit+3 downto 0);
	signal Z5_imag   : signed(M_bit+3 downto 0);
	signal Z6_real   : signed(M_bit+3 downto 0);
	signal Z6_imag   : signed(M_bit+3 downto 0);
	signal Z7_real   : signed(M_bit+4 downto 0);
	signal Z7_imag   : signed(M_bit+4 downto 0);

	
begin
	
	C0 : fft_control_counter 
		generic map(6)
		port map(clock, reset, counter);	
	TW0: twiddle_controller_W0
		generic map(6)
		port map(clock, reset, TW0_index);	
	TW1: twiddle_controller_W1
		generic map(6)
		port map(clock, reset, TW1_index);	
	LUT: fft_twiddle_lut
		generic map(M_bit, 6)
		port map(TW0_index, TW1_index, TW0_real, TW0_imag, TW1_real, TW1_imag );	
	S0: r2_BFI 
		generic map(M_bit, 0, 32)
		port map(x_real, x_imag, Z1_real , Z1_imag , clock, reset, counter(5) );
	S1: r2_BFII
		generic map(M_bit, 1, 16)
		port map(Z1_real , Z1_imag, Z2_real , Z2_imag, clock, reset, counter(4),counter(5) );
	W0: twiddle_multiplier_single
		generic map(M_bit, 2)
		port map(Z2_real, Z2_imag, Z3_real, Z3_imag, master_clock, reset, TW0_real, TW0_imag);
	S2: r2_BFI 
		generic map(M_bit, 2, 8)
		port map(Z3_real , Z3_imag, Z4_real , Z4_imag, clock, reset, counter(3) );
--	S2: r2_BFI
--		generic map(M_bit, 2, 8)
--		port map(Z2_real , Z2_imag, Z4_real , Z4_imag, clock, reset ,counter(3) );

	S3: r2_BFII
		generic map(M_bit, 3, 4)
		port map(Z4_real , Z4_imag, Z5_real , Z5_imag, clock, reset, counter(2),counter(3) );
	W1: twiddle_multiplier_single
		generic map(M_bit, 4)
		port map(Z5_real , Z5_imag, Z6_real , Z6_imag,master_clock, reset, TW1_real, TW1_imag);
	S4: r2_BFI 
		generic map(M_bit, 4, 2)
		port map(Z6_real , Z6_imag, Z7_real , Z7_imag, clock, reset, counter(1) );
	
--	S4: r2_BFI
--		generic map(M_bit, 4, 2)
--		port map(Z5_real , Z5_imag, Z7_real , Z7_imag, clock, reset, counter(1) );
	
	S5: r2_BFII 
		generic map(M_bit, 5, 1)
		port map(Z7_real , Z7_imag, y_real , y_imag, clock, reset, counter(0),counter(1) );
											


end arch_fft_64_point;