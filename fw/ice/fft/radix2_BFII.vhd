library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity r2_BFII is

	generic (
	
		N_bit : integer := 10;
		Stage : integer := 0;
		D     : integer := 2
	
	);

   port( 
	
		x_real : in signed(Stage + N_bit-1 downto 0);
		x_imag : in signed(Stage + N_bit-1 downto 0);
		
		y_real : out signed(Stage + N_bit downto 0);
		y_imag : out signed(Stage + N_bit downto 0);
		
		clock  : in std_logic;
		reset  : in std_logic;
		s      : in std_logic;
		t      : in std_logic
                  
	);
end r2_BFII;

architecture arch_r2_BFII of r2_BFII is

	signal x1_real : signed(Stage + N_bit downto 0);
	signal x1_imag : signed(Stage + N_bit downto 0);
 
	signal x2_real : signed(Stage + N_bit downto 0);
	signal x2_imag : signed(Stage + N_bit downto 0);

	signal y1_real : signed(Stage + N_bit downto 0);
	signal y1_imag : signed(Stage + N_bit downto 0);

	signal y2_real : signed(Stage + N_bit downto 0);
	signal y2_imag : signed(Stage + N_bit downto 0);

	signal z1_real : signed(Stage + N_bit downto 0);
	signal z1_imag : signed(Stage + N_bit downto 0);

	signal z2_real : signed(Stage + N_bit downto 0);
	signal z2_imag : signed(Stage + N_bit downto 0);

	--------------------------------------------------------------------
	
	type data_array is array (0 to D-1) of signed(Stage + N_bit downto 0);
	
	signal data_real : data_array;
	signal data_imag : data_array;

begin
	
	CrossSwitch: process(x_real, x_imag, s, t)
	begin
	
		if ( (not(t) and s) = '1' ) then
	
			x2_real <= to_signed( to_integer(x_imag), Stage + N_bit + 1 );
			x2_imag <= to_signed( to_integer(x_real), Stage + N_bit + 1 );
	
		else
		
			x2_real <= to_signed( to_integer(x_real), Stage + N_bit + 1 );
			x2_imag <= to_signed( to_integer(x_imag), Stage + N_bit + 1 );
		
		end if;
	end process;
	

	Butterfly: process(x1_real, x1_imag, x2_real, x2_imag, s, t)
	begin
		
		if ( (not(t) and s) = '1' ) then
	
			y1_real <= x1_real + x2_real;
			y1_imag <= x1_imag - x2_imag;
	
			y2_real <= x1_real - x2_real;
			y2_imag <= x1_imag + x2_imag;
	
		else
		
			y1_real <= x1_real + x2_real;
			y1_imag <= x1_imag + x2_imag;
	
			y2_real <= x1_real - x2_real;
			y2_imag <= x1_imag - x2_imag;
		
		end if;
	
	end process;
	
	
	ComplexMux: process(x1_real, x1_imag, x2_real, x2_imag, y1_real, y1_imag,y2_real, y2_imag, s)
	begin
		
		if ( s = '1' ) then
		
			z1_real <= y1_real;
			z1_imag <= y1_imag;	
			
			z2_real <= y2_real;
			z2_imag <= y2_imag;	
	
		else
		
			z1_real <= x1_real;
			z1_imag <= x1_imag;	
			
			z2_real <= x2_real;
			z2_imag <= x2_imag;	
		
		end if;

	end process;
		
		
	DelayLine: process(clock, reset, z2_real, z2_imag)
	begin
	
		if reset = '1' then
	
			for i in 0 to D-1 loop
		
				data_real(i) <= (others => '0');
				data_imag(i) <= (others => '0');
		
			end loop;
	
		elsif(rising_edge(clock)) then
	
			for i in 0 to D-1 loop
		
				if i = 0 then	
					data_real(i) <= z2_real;
					data_imag(i) <= z2_imag;
				else
					data_real(i) <= data_real(i-1);
					data_imag(i) <= data_imag(i-1);		
				end if;
				
			end loop;
		
		end if;
			
	end process;

	x1_real <= data_real(D-1);
	x1_imag <= data_imag(D-1);
	
	y_real <= z1_real;
	y_imag <= z1_imag;
	
	
end arch_r2_BFII;