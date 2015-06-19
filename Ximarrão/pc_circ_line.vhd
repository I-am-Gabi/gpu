library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_circ_line is 
	port (
		Start 	 : in std_logic;  -- start
		Start_out: out std_logic; -- start out
		CLK  	 : in std_logic;  -- clock
		Reset    : in std_logic;  -- reset
		Busy     : out std_logic; -- busy 

		-- loads
  		Ly0, Lx0 : out std_logic;
  		Ldx, Ldy : out std_logic;
  		Lsx, Lsy : out std_logic;
  		Lerr, Le2: out std_logic;

  		-- seletores
  		Sy0, Sx0 : out std_logic;
  		Ssx, Ssy : out std_logic;
  		Serr 	 : out std_logic_vector(1 downto 0);
  		Setpixel : out std_logic;

		-- comparadores
		inComp1 : in std_logic; -- x0 == x1 && y0 == y1
		inComp2 : in std_logic; -- x0 < x1
		inComp3 : in std_logic; -- y0 < y1
		inComp4 : in std_logic; -- dx > dy
		inComp5 : in std_logic; -- e2 > -dx 
		inComp6 : in std_logic -- e2 < dy	
	);
end pc_circ_line;

architecture pc_circ_line of pc_circ_line is
	signal Freg, F1, F2: std_logic_vector(3 downto 0); 
	signal Fa, Fb, Fc, Fd: std_logic_vector(3 downto 0);
	signal Fe, Ff, Fh: std_logic_vector(3 downto 0);
	signal Fj, Fk, Fl: std_logic_vector(3 downto 0);
	signal Fm, Fo, Fp: std_logic_vector(3 downto 0);
	signal Fresul: std_logic_vector(15 downto 0);
begin
	with Reset select
		F1 <= F2 when '1',
			"0000" when others;

	with Start select
		Fa <= "0000" when '0',
			  "0001" when others;

	Fb <= "0010";

	with inComp1 select
		Fc <= "0011" when '0',
			  "0100" when others;

	with inComp2 select
		Fd <= "0101" when '0',
			      "0110" when others;

	with inComp3 select
		Ff <= "0111" when '0',
			      "1111" when others;
	
	Fh <= "1001";

	with inComp4 select
		Fj <= "1010" when '0',
			  "0000" when others;

	Fk <= "1011";

	process(inComp5, inComp6)
	begin
		if inComp5 = '0' then
			if inComp6 = '0' then
				Fl <= "1001";
			else 
				Fl <= "1110";
			end if;
		else
			Fl <= "1100";		
		end if;
	end process;

	Fm <= "1101";

	Fo <= "1111";

	Fp <= "1001";



	process(Freg)
	begin
		case Freg is
			when "0000"	=>
				F2 <= Fa;
			when "0001" =>
				F2 <= Fb;
			when "0010" =>
				F2 <= Fc;
			when "0011" =>
				F2 <= Fd;
			when "0100" =>
				F2 <= Fd;
			when "0101" =>
				F2 <= Ff;
			when "0110" =>
				F2 <= Ff;
			when "0111" =>
				F2 <= Fh;
			when "1000" =>
				F2 <= Fh;
			when "1001" =>
				F2 <= Fj;
			when "1010" =>
				F2 <= Fk;
			when "1011" =>
				F2 <= Fl;
			when "1100" =>
				F2 <= Fm;
			when "1101" =>
				F2 <= Fl;
			when "1110" =>
				F2 <= Fo;
			when others =>
				F2 <= Fp;	
		end case;
	end process;

	process(Freg)
	begin
		case Freg is
			when "0000" =>
				Fresul <= "0000000000000000";
			when "0001" =>
				Fresul <= "1100000000000001";
			when "0010" =>
				Fresul <= "0011000000000000";
			when "0011" =>
				Fresul <= "0000100000100000";
			when "0100" =>
				Fresul <= "0000100000000000";
			when "0101" =>
				Fresul <= "0000010000010000";
			when "0110" =>
				Fresul <= "0000010000000000";
			when "0111" =>
				Fresul <= "0000001000000100";
			when "1000" =>
				Fresul <= "0000001000000000";
			when "1001" =>
				Fresul <= "0000000000000010";
			when "1010" =>
				Fresul <= "0000000100000000";
			when "1011" =>
				Fresul <= "0000000000000000";
			when "1100" =>
				Fresul <= "0000001000001000";
			when "1101" =>
				Fresul <= "0100000001000000";
			when "1110" =>
				Fresul <= "0000001000001100";
			when "1111" =>
				Fresul <= "1000000010000000";
		end case;
	end process;

	Ly0 	  <= Fresul(15);
	Lx0 	  <= Fresul(14);
	Ldx 	  <= Fresul(13);
	Ldy 	  <= Fresul(12);
	Lsx 	  <= Fresul(11);
	Lsy 	  <= Fresul(10);
	Lerr	  <= Fresul(9);
	Le2 	  <= Fresul(8);
	Sy0 	  <= Fresul(7);
	Sx0 	  <= Fresul(6);
	Ssx 	  <= Fresul(5);
	Ssy		  <= Fresul(4);
	Serr(1)   <= Fresul(3);
	Serr(0)   <= Fresul(2); 
	Setpixel  <= Fresul(1);
	Start_out <= Fresul(0);


	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			Freg <= F1;
		end if; 
	end process;
end pc_circ_line;
