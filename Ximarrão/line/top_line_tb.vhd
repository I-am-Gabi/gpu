library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_line_tb is
end top_line_tb; 

architecture top_line_tb of top_line_tb is
	signal Start: std_logic; -- start
	signal Reset: std_logic; -- reset
	signal CLK  : std_logic; -- clock

	-- parametros 
	signal Y0p, X0p : std_logic_vector(31 downto 0); 
	signal X1p, Y1p : std_logic_vector(31 downto 0);

	signal addr 	: std_logic_vector(13 downto 0);
	signal free 	: std_logic;
	signal pixel_i 	: std_logic_vector(11 downto 0);
	signal pixel_o 	: std_logic_vector(11 downto 0);
	signal estado 	: std_logic_vector(3 downto 0);
	
begin 
	top_line : entity work.top_line
	port map(
		Start => Start,
		CLK => CLK,
		Reset => Reset,
		p_param => "000000001111",
		x0_param => "0000010",
		x1_param => "0001101",
		y0_param => "0000010",
		y1_param => "0001101",
		wren => wren,
		addr => addr,
		estado => estado,
		free => free,
		pixel_i => pixel_i,
		pixel_o => pixel_o
	);

	process
	begin
		clock <= '0';
		wait for 1 ns;
		clock <= '1';
		wait for 1 ns;
	end process;
	
	process
	begin
		reset <= '1';
		start <= '0';
		wait until clock'event and clock = '1';
		reset <= '0';
		wait until clock'event and clock = '1';
		
		start <= '1';
		wait until clock'event and clock = '1';
		
		start <= '0';
		wait until clock'event and clock = '1';
		
		wait;
		
	end process;
end Line_alg_tb;