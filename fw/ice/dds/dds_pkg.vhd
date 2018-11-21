library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package dds_pkg is
	
	constant DDS_WAVEFORM_SINE			: std_logic_vector(1 downto 0) := "00";
	constant DDS_WAVEFORM_TRIANGLE		: std_logic_vector(1 downto 0) := "01";
	constant DDS_WAVEFORM_SAWTOOTH_FALL	: std_logic_vector(1 downto 0) := "10";
	constant DDS_WAVEFORM_SAWTOOTH_RISE	: std_logic_vector(1 downto 0) := "11";

end package ; -- dds_pkg 





