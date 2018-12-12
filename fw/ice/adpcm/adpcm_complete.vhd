library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity adpcm_complete is

	generic (
	
		L : integer := 3
	
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

end adpcm_complete;

architecture arch_adpcm_complete of adpcm_complete is


--Quantizer
component adpcm_quantizer
	
	generic (
	
		N : integer -- How many stages of ADPCM do we want? N = 1 -> 2 bit, N = 2 -> 3 bit and N = 3 -> 4 bit compression.
	
	);
	
   port( 

		Diff_in   : in signed(15 downto 0);	-- Difference between Sample and predicted sample.
		Step_in   : in signed(15 downto 0);	-- Step from LUT StepSizeTable. See adpcm_adapt.vhd.
		Code_out	 : out  unsigned(3 downto 0) -- Encoded output.		 	
                  
	);

end component; 


--mux (rx/tx)
component adpcm_mux

   port( 
	
		mode : in std_logic; --rx/tx'
	
		code_in_rx : in unsigned(3 downto 0);
		code_in_tx : in unsigned(3 downto 0);
		
		code_out   : out unsigned(3 downto 0)
		
	);

end component; 

--Inverse quantizer
component adpcm_inv_quantizer

	generic (
	
		N : integer -- How many stages of ADPCM do we want? N = 1 -> 2 bit, N = 2 -> 3 bit and N = 3 -> 4 bit compression.
	
	);
	
   port( 
		
		Code_in   : in unsigned(3 downto 0); -- Encoded signal 
	
		Step_in   : in signed(15 downto 0);	-- Step signal from LUT StepSizeTable. See adpcm_adapt.vhd...
		Diffq_out : out signed(15 downto 0) -- Diffq output to adapt stage.
	
	);
end component; 

--Adapt
component adpcm_adapt
	generic (
		
		N : integer -- How many stages of ADPCM do we want? N = 1 -> 2 bit, N = 2 -> 3 bit and N = 3 -> 4 bit compression.
	
	);
	
   port( 
	
		Pred_sample_load : in signed(15 downto 0);
		Pred_index_load  : in unsigned(7 downto 0);
	
		Code_in     : in unsigned(3 downto 0); -- Encoded signal. 
		Diffq_in    : in signed(15 downto 0); -- Diffq signal from inverted quantizer.
		Sample_in   : in  signed(7 downto 0); -- New sample from microphone / sound source. 
	
		Clock       : in std_logic; -- Clock signal. 8 KHz in the moment of writing this.
		Reset       : in std_logic; -- Reset signal. Reset module on '1'. 
		
		Pred_sample_out : out signed(15 downto 0);
		Pred_index_out  : out unsigned(7 downto 0);
		
		y_signal	: out signed(7 downto 0); -- Decoded output signal in decoder mode.
		
		Diff_out    : out signed(15 downto 0); -- Difference between sample and predicted sample. Send to Quantizer.
		Step_out    : out signed(15 downto 0) -- Step signal to Quantizer and inverted Quantizer.
                  
	);

end component; 

	signal diff_fb : signed(15 downto 0);
	signal step_fb : signed(15 downto 0);
	signal code_link_quantizer_mux_tx : unsigned(3 downto 0);
	signal code_out_mux : unsigned(3 downto 0);
	signal diffq_link : signed(15 downto 0);

begin

	
	QUANTIZER: adpcm_quantizer
	generic map(L)
	port map(diff_fb, step_fb, code_link_quantizer_mux_tx);
	
	MUX: adpcm_mux
	port map(mode, code_in_rx, code_link_quantizer_mux_tx, code_out_mux);
	
	INV_QUANTIZER: adpcm_inv_quantizer
	generic map(L)
	port map(code_out_mux, step_fb, diffq_link);
	
	ADAPT: adpcm_adapt
	generic map(L)
	port map(pred_sample_load, pred_index_load, code_out_mux, diffq_link, y_in, clock, reset, pred_sample_out, pred_index_out, y_out, diff_fb, step_fb);
	
	code_out <= code_out_mux;

end arch_adpcm_complete;