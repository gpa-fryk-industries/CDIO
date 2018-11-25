library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity delay_line is
	generic (
	
		D : integer := 2;
		N_bit : integer := 10
	
	);

   port( 
	
		x_real : in signed(N_bit-1 downto 0);
		x_imag : in signed(N_bit-1 downto 0);
		
		y_real : out signed(N_bit-1 downto 0);
		y_imag : out signed(N_bit-1 downto 0);
		
		clock   : in std_logic;
		reset   : in std_logic
                  
	);
end delay_line;

architecture arch_delay_line of delay_line is


	type data_array is array (0 to D-1) of signed(N_bit-1 downto 0);
	
	signal data_real : data_array;
	signal data_imag : data_array;
		
begin
	
	process(clock,reset) is
	
	begin
	
		if reset = '1' then
	
			for i in 0 to D-1 loop
		
				data_real(i) <= (others => '0');
				data_imag(i) <= (others => '0');
		
			end loop;
	
		elsif(rising_edge(clock)) then
	
			for i in 0 to D-1 loop
		
				if i = 0 then	
					data_real(i) <= x_real;
					data_imag(i) <= x_imag;
				else
					data_real(i) <= data_real(i-1);
					data_imag(i) <= data_imag(i-1);		
				
				end if;
				
			end loop;
		
		end if;
	
	end process;
	
	y_real <= data_real(D-1);
	y_imag <= data_imag(D-1);
	
end arch_delay_line ;