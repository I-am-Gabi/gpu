
-- iniando arquivo com código referente ao PO do 
-- algoritmo abs

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity circ_abs is
	port (
		Param_N : in std_logic_vector(31 downto 0);
		Return_N : out std_logic_vector(31 downto 0)
		);
end circ_abs;

architecture circ_abs of circ_abs is
	signal Comp : std_logic;
	signal F0,F1 	: std_logic_vector(31 downto 0);
	signal AUX_MULT : std_logic_vector(63 downto 0);
	begin
		F0 <= "00000000000000000000000000000000"; --  1
		F1 <= "11111111111111111111111111111111"; --  1
		process(Param_N)
		begin
			if signed(Param_N) < signed(F0) then
				AUX_MULT <= std_logic_vector(signed(Param_N) * signed(F1));
				Return_N <= AUX_MULT(31 downto 0);
			else
				Return_N <= Param_N;
			end if;
		end process;
end circ_abs;