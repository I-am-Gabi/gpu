-- thu jun 19
-- iniando arquivo com código referente ao PO do 
-- algoritmo de quadrado

library ieee;
use ieee.std_logic_1164.all;

entity gpu is 
	port (
		Start: in std_logic;  -- start
		CLK  : in std_logic;  -- clock
		Reset: in std_logic;  -- reset
		Busy : out std_logic; -- busy 

		-- parametros 
		Y0p, X0p : in std_logic_vector(31 downto 0); 
		X1p, Y1p : in std_logic_vector(31 downto 0);
		pixel : in std_logic_vector(11 downto 0)
		);
end gpu;

architecture gpu of gpu is
	signal Ly0, Lx0 : std_logic;
    signal Ldx, Ldy : std_logic;
  	signal Lsx, Lsy : std_logic;
    signal Lerr, Le2: std_logic;

    signal Sy0, Sx0 : std_logic;
  	signal Ssx, Ssy : std_logic;
  	signal Serr 	: std_logic_vector(1 downto 0);
  	signal Setpixel : std_logic;

  	signal inComp1 : std_logic; -- x0 == x1 && y0 == y1
	signal inComp2 : std_logic; -- x0 < x1
	signal inComp3 : std_logic; -- y0 < y1
	signal inComp4 : std_logic; -- dx > dy
	signal inComp5 : std_logic; -- e2 > -dx 
	signal inComp6 : std_logic  -- e2 < dy	
begin
	S0: entity work.circ_line
	port map(
		Start => Start,
		CLK   => CLK,

		Y0p   => Y0p,
		X0p   => X0p,
		X1p   => X1p,
		Y1p   => Y1p,
		pixel => pixel,

		Ly0 => Ly0,
		Lx0 => Lx0,
		Ldx => Ldx,
		Ldy => Ldy,

		Sy0 => Sy0,
		Sx0 => Sx0,
		Ssx => Ssx,
		Ssy => Ssy,  
		Serr=> Serr

		outComp1 => outComp1, 
		outComp2 => outComp2, 
		outComp3 => outComp3, 
		outComp4 => outComp4, 
		outComp5 => outComp5, 
		outComp6 => outComp6
		);

	S1: entity work.pc_circ_line
	port map(
		Start => Start,
		CLK   => CLK,
		Reset => Reset,
		Busy => Busy, 

		Ly0 => Ly0,
		Lx0 => Lx0,
		Ldx => Ldx,
		Ldy => Ldy,

		Sy0 => Sy0,
		Sx0 => Sx0,
		Ssx => Ssx,
		Ssy => Ssy,  
		Serr=> Serr

		outComp1 => outComp1, 
		outComp2 => outComp2, 
		outComp3 => outComp3, 
		outComp4 => outComp4, 
		outComp5 => outComp5, 
		outComp6 => outComp6
		);
end gpu;