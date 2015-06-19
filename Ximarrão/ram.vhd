library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is 
	generic (
		DATA_WIDTH : integer := 16;
		ADDR_WIDTH : integer := 16
	);
	port (
		clock_01 : in std_logic;
		wren_01  : in std_logic; -- habilita a escrita 
		addr_01  : in std_logic_vector(ADDR_WIDTH - 1 downto 0); -- endereco da memoria 
		data_i_01: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- informacao a ser escrita na memoria 
		data_o_01: out std_logic_vector(DATA_WIDTH - 1 downto 0) -- valor a ser lida da memoria

		clock_02 : in std_logic;
		wren_02  : in std_logic; -- habilita a escrita 
		addr_02  : in std_logic_vector(ADDR_WIDTH - 1 downto 0); -- endereco da memoria 
		data_i_02: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- informacao a ser escrita na memoria 
		data_o_02: out std_logic_vector(DATA_WIDTH - 1 downto 0) -- valor a ser lida da memoria
	);
end ram;

architecture ram of ram is
	-- inicializa a memoria
	type ram_t is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

	signal ram_image : ram_t := (
		0 => "0000000000000000",
		others => "0000000000000000"
	);

begin
	process (clock_01)
	begin
	if clock_01'event and clock_01 = '1' then
		data_o_01 <= ram_image(to_integer(unsigned(addr)));

		if wren_01 = '1' then
			ram_image(to_integer(unsigned(addr_01))) <= data_i_01;
		end if;
	end if;
	end process;

	process (clock_02)
	begin
	if clock_02'event and clock_02 = '1' then
		data_o_02 <= ram_image(to_integer(unsigned(addr)));

		if wren_02 = '1' then
			ram_image(to_integer(unsigned(addr_02))) <= data_i_02;
		end if;
	end if;
	end process;
end ram;