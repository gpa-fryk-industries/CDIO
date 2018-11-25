library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_comparator is

   port( 
	
		count      : in signed(7 downto 0);
		data       : in signed(7 downto 0);
		pwm_enable : in std_logic; -- Active low
		q          : out std_logic;
		q_inv      : out std_logic
		
	);
end pwm_comparator;

architecture arch_pwm_comparator of pwm_comparator is
	signal output: std_logic;
	
begin   

	output <= '0' when (count) >= (data) else '1';

	Qinv 	<= not output when pwm_enable = '0' else '1';
	Q 		<= output when pwm_enable = '0' else '1';
	
end arch_pwm_comparator;

	
