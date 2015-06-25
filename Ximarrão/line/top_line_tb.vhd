library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_line_tb is
end top_line_tb; 

architecture top_line_tb of top_line_tb is
	signal Start: std_logic; -- start
	signal Reset: std_logic; -- reset
	signal CLK  : std_logic; -- clock
	signal Wren : std_logic; -- wren
	signal pixel: std_logic_vector(11 downto 0); -- pixel

	-- parametros 
	signal Y0p, X0p : std_logic_vector(31 downto 0); 
	signal X1p, Y1p : std_logic_vector(31 downto 0);

begin 
	top_line : entity work.top_line
	port map(
		Start 	=> Start,
		CLK 	=> CLK,
		Reset 	=> Reset,
		Wren 	=> Wren,
		pixel	=> pixel,
		Y0p 	=> "00000000000000000000000000000000",
		X0p 	=> "00000000000000000000000000000000",
		X1p 	=> "00000000000000000000000001100011",
		Y1p 	=> "00000000000000000000000001100011"
	);

	process
	begin
		CLK <= '0';
		wait for 1 ns;
		CLK <= '1';
		wait for 1 ns;
	end process;
	
	process
	begin
		Reset <= '1';
		Start <= '0';

		wait until CLK'event and CLK = '1';
		
		Reset <= '0';
		Start <= '1';
		wait until CLK'event and CLK = '1';
		
		Start <= '0';

		wait until CLK'event and CLK = '1';		
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait until CLK'event and CLK = '1';
		wait;
	end process;
end top_line_tb;