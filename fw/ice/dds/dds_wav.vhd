library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.dds_pkg.all;

entity dds_wav is
	generic (
		NCO_LENGTH: integer := 16;
		DDS_LENGTH: integer := 16
	);
  	port (
  		-- Basic control
		clk, rst: in std_logic;

		-- NCO
		nco: in unsigned(NCO_LENGTH-1 downto 0);

		-- Control
		waveform: in std_logic_vector(1 downto 0);

		-- Output
		dds: out signed(DDS_LENGTH-1 downto 0)
  	);
end entity ; -- dds_wav

architecture arch_dds_wav of dds_wav is

	type int_array is array(integer range 255 downto 0) of integer;

	-- Direct Digital Synthesis
	-- Sine lookup table
	constant sine_table: int_array := (
			0, 807, 1614, 2420, 3224, 4027, 4827, 5624, 6417, 7207, 7993, 8773, 9548, 10318, 11081, 11837, 
			12586, 13328, 14061, 14786, 15502, 16209, 16906, 17592, 18268, 18932, 19586, 20227, 20856, 21472, 22076, 22666, 
			23242, 23804, 24351, 24884, 25402, 25904, 26391, 26861, 27315, 27753, 28174, 28578, 28964, 29333, 29684, 30017, 
			30331, 30628, 30905, 31164, 31404, 31625, 31827, 32009, 32172, 32316, 32440, 32544, 32628, 32693, 32738, 32762, 
			32767, 32752, 32718, 32663, 32588, 32494, 32380, 32247, 32093, 31921, 31728, 31517, 31287, 31037, 30769, 30482, 
			30176, 29852, 29510, 29151, 28773, 28378, 27966, 27536, 27090, 26628, 26149, 25655, 25145, 24620, 24079, 23525, 
			22955, 22372, 21776, 21166, 20543, 19908, 19261, 18602, 17931, 17250, 16558, 15857, 15145, 14425, 13696, 12958, 
			12213, 11460, 10700, 9934, 9161, 8383, 7600, 6813, 6021, 5226, 4427, 3626, 2822, 2017, 1211, 404, 
			-404, -1211, -2017, -2822, -3626, -4427, -5226, -6021, -6813, -7600, -8383, -9161, -9934, -10700, -11460, -12213, 
			-12958, -13696, -14425, -15145, -15857, -16558, -17250, -17931, -18602, -19261, -19908, -20543, -21166, -21776, -22372, -22955, 
			-23525, -24079, -24620, -25145, -25655, -26149, -26628, -27090, -27536, -27966, -28378, -28773, -29151, -29510, -29852, -30176, 
			-30482, -30769, -31037, -31287, -31517, -31728, -31921, -32093, -32247, -32380, -32494, -32588, -32663, -32718, -32752, -32767, 
			-32762, -32738, -32693, -32628, -32544, -32440, -32316, -32172, -32009, -31827, -31625, -31404, -31164, -30905, -30628, -30331, 
			-30017, -29684, -29333, -28964, -28578, -28174, -27753, -27315, -26861, -26391, -25904, -25402, -24884, -24351, -23804, -23242, 
			-22666, -22076, -21472, -20856, -20227, -19586, -18932, -18268, -17592, -16906, -16209, -15502, -14786, -14061, -13328, -12586, 
			-11837, -11081, -10318, -9548, -8773, -7993, -7207, -6417, -5624, -4827, -4027, -3224, -2420, -1614, -807, 0
		); 
	signal sine: signed(DDS_LENGTH-1 downto 0);

begin
	 
	-- Direct Digital Synthesis
	-- Generates relevant output
	WAVGEN : process( rst, nco )
		variable sine, sawtooth, triangle: integer;
	begin
		-- Generate Sinewave
		sine := sine_table( to_integer(nco(NCO_LENGTH-1 downto NCO_LENGTH-8)) );

		-- Generate Sawtooth
		sawtooth := to_integer(nco) - (2**15);

		-- Generate Triangle
		triangle := abs(sawtooth);


		if rst = '0' then
			dds <= to_signed(0, DDS_LENGTH);
		else
			case waveform is
				when DDS_WAVEFORM_SINE 			=> dds <= to_signed(sine, 		DDS_LENGTH);
	        	when DDS_WAVEFORM_TRIANGLE 		=> dds <= to_signed(triangle, 	DDS_LENGTH);
	        	when DDS_WAVEFORM_SAWTOOTH_RISE => dds <= to_signed(sawtooth, 	DDS_LENGTH);
	        	when DDS_WAVEFORM_SAWTOOTH_FALL => dds <= to_signed(-sawtooth,	DDS_LENGTH);
                when others 					=> dds <= to_signed(sine, 		DDS_LENGTH);
			end case;
		end if ;
		-- Output
		


	end process ; -- WAVEGEN


end architecture ; -- arch_dds_wav









