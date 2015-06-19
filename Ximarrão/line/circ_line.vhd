-- thu jun 18
-- gabriela
-- iniando arquivo com código referente ao PO do 
-- algoritmo de linha

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circ_line is
	port (
		Start : in std_logic;
		CLK   : in std_logic;

		-- loads
		Ly0, Lx0, Ldx, Ldy  : in std_logic;
		Lsx, Lsy, Lerr, Le2 : in std_logic;

		-- seletores
		Sy0, Sx0, Ssx, Ssy : in std_logic;
		Serr : in std_logic_vector(1 downto 0); 

		-- comparadores
		outComp1 : out std_logic; -- x0 == x1 && y0 == y1
		outComp2 : out std_logic; -- x0 < x1
		outComp3 : out std_logic; -- y0 < y1
		outComp4 : out std_logic; -- dx > dy
		outComp5 : out std_logic; -- e2 > -dx 
		outComp6 : out std_logic; -- e2 < dy

		-- params
		Y0p, X0p : in std_logic_vector(31 downto 0); 
		X1p, Y1p : in std_logic_vector(31 downto 0);
		pixel : in std_logic_vector(11 downto 0)	
		);
end circ_line;

architecture circ_line of circ_line is
	-- constantes
	signal F0, F1, F2: std_logic_vector(31 downto 0);
	-- comparações
	signal Fcomp1, Fcomp2, Fcomp3: std_logic;
	signal Fcomp4, Fcomp5, Fcomp6: std_logic;
	-- fios dos registradores
	signal FRx0, FRx1, FRy0: std_logic_vector(31 downto 0);
	signal FRy1, FRdx, FRdy: std_logic_vector(31 downto 0);
	signal FRe2, FRsx, FRsy: std_logic_vector(31 downto 0); 
	signal FRerr: std_logic_vector(31 downto 0);
	signal FRerr_GAMBIARRA: std_logic_vector(63 downto 0);
	-- fio abs
	signal Fabs_in : std_logic_vector(31 downto 0);
	signal Fabs_out : std_logic_vector(31 downto 0);
begin
	pixel <= "111100000000";

	-- port map abs
	s0 : entity work.circ_abs
	port map (
		Param_N  => Fabs_in,
		Return_N => Fabs_out
	);

	F0 <= "00000000000000000000000000000001"; --  1
	F1 <= "11111111111111111111111111111111"; -- -1
	F2 <= "00000000000000000000000000000010"; --  2

	-- x0 == x1 && y0 == y1
	Fcomp1 <= '1' when ((signed(FRx0) = signed(FRx1)) 
					and (signed(FRy0) = signed(FRy1))) 
					else '0';

	-- x0 < x1				
	Fcomp2 <= '1' when (signed(FRx0) < signed(FRx1))
					else '0';

	-- y0 < y1
	Fcomp3 <= '1' when (signed(FRy0) < signed(FRy1))
					else '0';

	-- dx > dy
	Fcomp4 <= '1' when (signed(FRdx) > signed(FRdy))
					else '0';

	-- e2 > -dx colocar negativo
	Fcomp5 <= '1' when (signed(FRe2) > signed(FRdx))
					else '0';

	-- e2 < dx
	Fcomp6 <= '1' when (signed(FRe2) < signed(FRdx))
					else '0';

	process (CLK)
	begin
		if CLK'event and CLK = '1' then
			if Ly0 = '1' or Start = '1' then
				case Sy0 is 
					when '0' =>
						FRy0 <= Y0p;
					when others =>
						FRy0 <= std_logic_vector(signed(FRy0) + signed(FRsy)); 
				end case;
			end if;

			if Lx0 = '1' or Start = '1' then
				case Sx0 is
					when '0' =>
						FRx0 <= X0p;
					when others =>
						FRx0 <= std_logic_vector(signed(FRx0) + signed(FRsx));
				end case;
			end if;

			if Ldx = '1' then
				Fabs_in <= std_logic_vector(signed(X1p) - signed(FRx0));
				FRdx <= Fabs_out;
			end if;
			
			if Ldy = '1' then
				Fabs_in <= std_logic_vector(signed(Y1p) - signed(FRy0));
				FRdy    <= Fabs_out;
			end if;
			
			if Lsx = '1' then
				case Ssx is
					when '0' =>
						FRsx <= F0;
					when others =>
						FRsx <= F1;
				end case;
			end if;

			if Lsy = '1' then
				case Ssy is
					when '0' =>
						FRsy <= F0;
					when others =>
						FRsy <= F1;
				end case;
			end if;
				
			if Lerr = '1' then
				case Serr is
					when "00" =>
						FRerr <= std_logic_vector(signed(FRdx) / signed(F2));
					when "01" =>
						FRerr_GAMBIARRA <= std_logic_vector(signed(F1) * signed(FRdy));
						FRerr <= std_logic_vector(signed(FRerr_GAMBIARRA(31 downto 0)) / signed(F2));
					when "10" =>
						FRerr <= std_logic_vector(signed(FRerr) - signed(FRdy));
					when others =>
						FRerr <= std_logic_vector(signed(FRerr) + signed(FRdx));
				end case;
			end if;

			if Le2 = '1' then 
				FRe2 <= FRerr;
			end if;
		end if;
	end process; 				
end circ_line; 