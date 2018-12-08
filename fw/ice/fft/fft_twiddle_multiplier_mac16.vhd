library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity twiddle_multiplier_single is
	
	generic(
		N_bit : integer := 8;
		Stage : integer := 2

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

end twiddle_multiplier_single ;

architecture arch_twiddle_multiplier_single  of twiddle_multiplier_single is
	
	component multiplier_MAC16
		
		generic(
		
			N_bit : integer;
			M_bit : integer
	);
	
	port( 
	
		x : in signed(N_bit-1 downto 0);
		y : in signed(M_bit-1 downto 0);
		
		ans   : out signed(N_bit+M_bit-1 downto 0);
		
		clock : in std_logic

	);
	
	end component;

	signal master_count : unsigned(2 downto 0) := (others => '0');
	
	signal u : signed(N_bit+Stage-1 downto 0);
	signal v : signed(N_bit downto 0);
	
	signal mult_out : signed(2*N_bit + Stage downto 0);
	
	signal A : signed(2*N_bit + Stage downto 0);
	signal B : signed(2*N_bit + Stage downto 0);
	signal C : signed(2*N_bit + Stage downto 0);
	signal D : signed(2*N_bit + Stage downto 0);
	
	type data_array is array (0 to 3) of signed(2*N_bit + Stage downto 0);
	signal data : data_array;
	
begin
	
	--Number mux
	process(x_real, x_imag,twiddle_real,twiddle_imag, master_count)
	begin
		
		case master_count(1 downto 0) is
			
			when "00" => 
				u <= x_real;
				v <= twiddle_real;
			when "01" => 
				u <= x_real;
				v <= twiddle_imag;
			when "10" => 
				u <= x_imag;
				v <= twiddle_real;
			when "11" => 
				u <= x_imag;
				v <= twiddle_imag;
		end case;
		
	end process;
	
	--Multiplier
	MAC16 : multiplier_MAC16
	generic map(Stage + N_bit, N_bit+1)
	port map(u,v,mult_out,clock);
	

	-- Shift register, SIPO
	DelayLine: process(clock, mult_out,reset)
	begin
	
		if reset = '1' then
			
			for i in 0 to 3 loop
	
				data(i) <= (others => '0');
		
			end loop;
	
		elsif(rising_edge(clock)) then
		
			for i in 0 to 3 loop
		
				if i = 0 then	
					data(i) <= mult_out;
				else
					data(i) <= data(i-1);

				end if;
				
			end loop;
			
			if master_count = to_unsigned(6,3) then --"110" 
			
				A <= data(3);
				B <= data(2);
				C <= data(1);
				D <= data(0);
				
			end if;
		
		end if;
		
	end process;

	
	-- Sequential part
	process(clock,reset)
	begin
	
		if reset = '1' then
		
			master_count <= (others => '0');
	
		elsif rising_edge(clock) then
		
			if (master_count >= to_unsigned(6,3)) then
			
				master_count <= (others => '0');
				
			else
			
				master_count <= master_count + 1;
				
			end if;
			
		end if;

	end process;
	
	y_real <= shift_right(signed(A-D), N_bit -1)(Stage+N_bit -1 downto 0) ;
	y_imag <= shift_right(signed(B+C), N_bit -1)(Stage+N_bit -1 downto 0) ;
	
	
end arch_twiddle_multiplier_single;
	
	
