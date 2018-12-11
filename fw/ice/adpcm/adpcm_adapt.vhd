library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adpcm_adapt is
	
	generic (
		
		N : integer := 3 -- How many stages of ADPCM do we want? N = 1 -> 2 bit, N = 2 -> 3 bit and N = 3 -> 4 bit compression.
	
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
end adpcm_adapt;

architecture arch_adpcm_adapt of adpcm_adapt is
	
	signal pred_sample     : signed(16 downto 0) := (others => '0'); -- Predicted sample for next cycle. Initialize as 0.
	signal pred_sample_u16 : signed(15 downto 0); -- Predicted sample for next cycle. Initialize as 0.
	signal pred_index      : integer range 0 to 88 := 0 ; -- Predicted index for next cycle. Initialize as 0.
	
	signal sample_padded : signed(15 downto 0); -- Padded sample, algorithm is working with 16 bit numbers in this implementation. 
																-- Input signal scaled to 16 bit.												
	signal step_out_i16 : integer range 0 to 32767;
	signal index_code : integer range -1 to 8;
	signal index_table_index : integer range 0 to 15;
	
begin   

	ADAPT: process(Clock, Reset, pred_index_load, pred_sample_load, Diffq_in, pred_sample) is 
	
	begin
		
		-- Go back to initial "state".
		if (Reset = '1') then
		
			pred_sample <= to_signed(to_integer(pred_sample_load),17);
			pred_sample_u16 <= pred_sample_load;
			pred_index  <= to_integer(pred_index_load);
		
		-- 
		elsif ( rising_edge(Clock) ) then
			
			-- Is the sign of Code_in negative / is MSB '1'?
			
			if(Code_in(N) = '1') then		
				pred_sample <=   to_signed( to_integer( (pred_sample_u16) - ( Diffq_in) ), 17);	
			else
				pred_sample <=   to_signed( to_integer( (pred_sample_u16) + ( Diffq_in) ), 17);	
			end if;
				
		
			if( (pred_index + index_code ) < 0 ) then
				pred_index <= 0;
			elsif( (pred_index + index_code ) > 88 ) then
				pred_index <= 88;	
			else
				pred_index <= pred_index + index_code ;
			end if;
			
		end if;

		--Prevent overflow/underflow
		
		if ( to_integer(pred_sample) >  ( (2**15) -1 ) ) then
	
			pred_sample_u16 <= to_signed( (2**15) - 1 , 16);
	
		elsif ( to_integer(pred_sample) < ( -(2**15) ) ) then
		
			pred_sample_u16 <= to_signed( -(2**15) , 16);
		
		else
			pred_sample_u16 <= to_signed( to_integer( pred_sample ), 16 );
	
		end if;
--		
	end process;
	
	
	Sample_padded <= Sample_in & "00000000"; -- Scale input signal to 16 bit.
	
	------------------------------------------------------------------------------------
	
	Pred_sample_out <= pred_sample_u16;
	Pred_index_out  <= to_unsigned(pred_index,8);
	
	------------------------------------------------------------------------------------
	
	Diff_out <=  ( Sample_padded - pred_sample_u16); 
	Step_out <= to_signed(step_out_i16 , 16 ); 
	
	y_signal <= pred_sample_u16(15 downto 8); -- Scale back output as an 8 bit number.
	
 	------------------------------------------------------------------------------------
	--Instead of making IndexTable generic, index prediction is adapted to the number N.
	--(-1, -1, -1, -1,  2, 4, 6, -1, -1, -1, -1, 2, 4, 6, 8) if N = 3
	--(-1, -1, 2, 6, -1, -1, 2, 6)                         if N = 2
	--(-1, 2,-1, 2)                                        if N = 1
			
	-- to_integer( Code_in ) * (2**(3-N) might just look a bit cryptic...

	index_table_index <= to_integer( Code_in ) * (2**(3-N));
	
	
	--LUT--
		process(pred_index) 
	begin
		
		case(pred_index) is
			
		when 0 => 
		 step_out_i16 <= 7; 
		when 1 => 
		 step_out_i16 <= 8; 
		when 2 => 
		 step_out_i16 <= 9; 
		when 3 => 
		 step_out_i16 <= 10; 
		when 4 => 
		 step_out_i16 <= 11; 
		when 5 => 
		 step_out_i16 <= 12; 
		when 6 => 
		 step_out_i16 <= 13; 
		when 7 => 
		 step_out_i16 <= 14; 
		when 8 => 
		 step_out_i16 <= 16; 
		when 9 => 
		 step_out_i16 <= 17; 
		when 10 => 
		 step_out_i16 <= 19; 
		when 11 => 
		 step_out_i16 <= 21; 
		when 12 => 
		 step_out_i16 <= 23; 
		when 13 => 
		 step_out_i16 <= 25; 
		when 14 => 
		 step_out_i16 <= 28; 
		when 15 => 
		 step_out_i16 <= 31; 
		when 16 => 
		 step_out_i16 <= 34; 
		when 17 => 
		 step_out_i16 <= 37; 
		when 18 => 
		 step_out_i16 <= 41; 
		when 19 => 
		 step_out_i16 <= 45; 
		when 20 => 
		 step_out_i16 <= 50; 
		when 21 => 
		 step_out_i16 <= 55; 
		when 22 => 
		 step_out_i16 <= 60; 
		when 23 => 
		 step_out_i16 <= 66; 
		when 24 => 
		 step_out_i16 <= 73; 
		when 25 => 
		 step_out_i16 <= 80; 
		when 26 => 
		 step_out_i16 <= 88; 
		when 27 => 
		 step_out_i16 <= 97; 
		when 28 => 
		 step_out_i16 <= 107; 
		when 29 => 
		 step_out_i16 <= 118; 
		when 30 => 
		 step_out_i16 <= 130; 
		when 31 => 
		 step_out_i16 <= 143; 
		when 32 => 
		 step_out_i16 <= 157; 
		when 33 => 
		 step_out_i16 <= 173; 
		when 34 => 
		 step_out_i16 <= 190; 
		when 35 => 
		 step_out_i16 <= 209; 
		when 36 => 
		 step_out_i16 <= 230; 
		when 37 => 
		 step_out_i16 <= 253; 
		when 38 => 
		 step_out_i16 <= 279; 
		when 39 => 
		 step_out_i16 <= 307; 
		when 40 => 
		 step_out_i16 <= 337; 
		when 41 => 
		 step_out_i16 <= 371; 
		when 42 => 
		 step_out_i16 <= 408; 
		when 43 => 
		 step_out_i16 <= 449; 
		when 44 => 
		 step_out_i16 <= 494; 
		when 45 => 
		 step_out_i16 <= 544; 
		when 46 => 
		 step_out_i16 <= 598; 
		when 47 => 
		 step_out_i16 <= 658; 
		when 48 => 
		 step_out_i16 <= 724; 
		when 49 => 
		 step_out_i16 <= 796; 
		when 50 => 
		 step_out_i16 <= 876; 
		when 51 => 
		 step_out_i16 <= 963; 
		when 52 => 
		 step_out_i16 <= 1060; 
		when 53 => 
		 step_out_i16 <= 1166; 
		when 54 => 
		 step_out_i16 <= 1282; 
		when 55 => 
		 step_out_i16 <= 1411; 
		when 56 => 
		 step_out_i16 <= 1552; 
		when 57 => 
		 step_out_i16 <= 1707; 
		when 58 => 
		 step_out_i16 <= 1878; 
		when 59 => 
		 step_out_i16 <= 2066; 
		when 60 => 
		 step_out_i16 <= 2272; 
		when 61 => 
		 step_out_i16 <= 2499; 
		when 62 => 
		 step_out_i16 <= 2749; 
		when 63 => 
		 step_out_i16 <= 3024; 
		when 64 => 
		 step_out_i16 <= 3327; 
		when 65 => 
		 step_out_i16 <= 3660; 
		when 66 => 
		 step_out_i16 <= 4026; 
		when 67 => 
		 step_out_i16 <= 4428; 
		when 68 => 
		 step_out_i16 <= 4871; 
		when 69 => 
		 step_out_i16 <= 5358; 
		when 70 => 
		 step_out_i16 <= 5894; 
		when 71 => 
		 step_out_i16 <= 6484; 
		when 72 => 
		 step_out_i16 <= 7132; 
		when 73 => 
		 step_out_i16 <= 7845; 
		when 74 => 
		 step_out_i16 <= 8630; 
		when 75 => 
		 step_out_i16 <= 9493; 
		when 76 => 
		 step_out_i16 <= 10442; 
		when 77 => 
		 step_out_i16 <= 11487; 
		when 78 => 
		 step_out_i16 <= 12635; 
		when 79 => 
		 step_out_i16 <= 13899; 
		when 80 => 
		 step_out_i16 <= 15289; 
		when 81 => 
		 step_out_i16 <= 16818; 
		when 82 => 
		 step_out_i16 <= 18500; 
		when 83 => 
		 step_out_i16 <= 20350; 
		when 84 => 
		 step_out_i16 <= 22385; 
		when 85 => 
		 step_out_i16 <= 24623; 
		when 86 => 
		 step_out_i16 <= 27086; 
		when 87 => 
		 step_out_i16 <= 29794; 
		when 88 => 
		 step_out_i16 <= 32767; 	
	
		end case;

	end process;
	
	process(index_table_index) 
	begin

		
		case(index_table_index) is
		
		when 0 => 
		 index_code <= -1; 
		when 1 => 
		 index_code <= -1; 
		when 2 => 
		 index_code <= -1; 
		when 3 => 
		 index_code <= -1; 
		when 4 => 
		 index_code <= 2; 
		when 5 => 
		 index_code <= 4; 
		when 6 => 
		 index_code <= 6; 
		when 7 => 
		 index_code <= 8; 
		when 8 => 
		 index_code <= -1; 
		when 9 => 
		 index_code <= -1; 
		when 10 => 
		 index_code <= -1; 
		when 11 => 
		 index_code <= -1; 
		when 12 => 
		 index_code <= 2; 
		when 13 => 
		 index_code <= 4; 
		when 14 => 
		 index_code <= 6; 
		when 15 => 
		 index_code <= 8; 
		
		end case;

	end process;
	
end arch_adpcm_adapt;