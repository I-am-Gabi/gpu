-- thu jun 18 
-- iniando arquivo com código referente ao PO do 
-- algoritmo de quadrado

library ieee;
use ieee.std_logic_1164.all;

entity circ_square is
	Col, Row, Size : in std_logic_vector(31 downto 0);
	Pixel : in std_logic_vector(11 downto 0);
end circ_square;

architecture circ_square of circ_square is
begin
	line0 : entity work.circ_line
	port map(
		Y0p => Col,
		X0p => Row,
		X1p => std_logic_vector(unsigned(Col) + unsigned(Size)),
		Y1p => Row,
		pixel => Pixel
		);

	line1 : entity work.circ_line
	port map(
		Y0p => std_logic_vector(unsigned(Col) + unsigned(Size)),
		X0p => Row,
		X1p => std_logic_vector(unsigned(Col) + unsigned(Size)),
		Y1p => std_logic_vector(unsigned(Row) + unsigned(Size)),
		pixel => Pixel
		);

	line2 : entity work.circ_line
	port map(
		Y0p => std_logic_vector(unsigned(Col) + unsigned(Size)),
		X0p => std_logic_vector(unsigned(Row) + unsigned(Size)),
		X1p => Col,
		Y1p => std_logic_vector(unsigned(Row) + unsigned(Size)),
		pixel => pixel
		);

	line3 : entity work.circ_line
	port map(
		Y0p => Col,
		X0p => std_logic_vector(unsigned(Row) + unsigned(Size)),
		X1p => Col,
		Y1p => Row,
		pixel => Pixel
		);
end circ_square;