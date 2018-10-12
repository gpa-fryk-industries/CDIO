library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_comparator is

   port( 
	
		PWM_enable : in std_logic; -- Active low
		Count_in : in std_logic_vector(7 downto 0);
		Data_in  : in std_logic_vector(7 downto 0);
		Q    : out std_logic;
		Qinv : out std_logic
		
	);
end pwm_comparator;

architecture arch_pwm_comparator of pwm_comparator is
	signal output: std_logic;
	
begin   

	output <= '0' when (Count_in) >= (Data_in) else '1';

	Qinv 	<= not output when PWM_enable = '0' else '1';
	Q 		<= output when PWM_enable = '0' else '1';
	
end arch_pwm_comparator;

	
