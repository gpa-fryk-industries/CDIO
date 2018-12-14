library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity adpcm_tester is

	port( 
	
		data_in   : in std_logic;
		clock1  : in std_logic;
		clock2  : in std_logic;
		reset  : in std_logic;
		data_out : out std_logic
		
	);

end adpcm_tester;

architecture arch_adpcm_tester of adpcm_tester is


component test_input
   
	port( 
	
		data       : in std_logic;
		clock      : in std_logic;
		reset      : in std_logic;
		data_out   : out signed(7 downto 0);
		clock_out  : out std_logic
		
	);
	
end component;


component send_to_master
	
	generic(
		
		L : integer
		
	);

   port( 
	
		clock : in std_logic;
		reset : in std_logic;
		data_in  : in unsigned(L-1 downto 0);
		data_out : out std_logic
   
	);

end component;

component adpcm_complete

	generic (
	
		L : integer
	
	);

	port( 
		
		y_in  : in signed(7 downto 0);
		
		pred_sample_load : in signed(15 downto 0);
		pred_index_load  : in unsigned(7 downto 0);
		
		code_in_rx : in unsigned(3 downto 0);
		
		mode  : in std_logic; -- rx/tx'
		
		clock : in std_logic;
		reset : in std_logic;
		
		pred_sample_out : out signed(15 downto 0);
		pred_index_out  : out unsigned(7 downto 0);
		
		y_out : out signed(7 downto 0);
		
		code_out : out unsigned(3 downto 0)

	);

end component;
	
	signal co : std_logic;
	signal DATA_SIGNAL : signed(7 downto 0);
	signal CODE_OUT_TEST : unsigned(3 downto 0); 
	
	
begin

	t_signal : test_input
	port map(data_in,clock1,reset,DATA_SIGNAL,co);
	
	ADPCM: adpcm_complete
	generic map(3)
	port map(DATA_SIGNAL,(others => '0'), (others => '0'), (others => '0'), '0', co,reset, open,open,open, CODE_OUT_TEST);
	
	stm : send_to_master
	generic map(4)
	port map(clock2,reset,CODE_OUT_TEST,data_out);
	

end arch_adpcm_tester;