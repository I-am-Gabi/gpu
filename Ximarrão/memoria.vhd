library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is 
	generic (
		DATA_WIDTH : integer := 16;
		ADDR_WIDTH : integer := 16
	);
	port (
		clock : in std_logic;
		wren  : in std_logic; -- habilita a escrita 
		addr  : in std_logic_vector(ADDR_WIDTH-1 downto 0); -- endereco da memoria 
		data_i: in std_logic_vector(DATA_WIDTH-1 downto 0); -- informacao a ser escrita na memoria 
		data_o: out std_logic_vector(DATA_WIDTH-1 downto 0) -- valor a ser lida da memoria
	);
end ram;

architecture ram of ram is
	-- inicializa a memoria
	type ram_t is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

	signal ram_image : ram_t := (
		0 => "0000000000000000",
		others => "0000000000000000"
	);

begin
	process (clock)
	begin
	if clock'event and clock = '1' then
		data_o <= ram_image(to_integer(unsigned(addr)));

		if wren = '1' then
			ram_image(to_integer(unsigned(addr))) <= data_i;
		end if;
	end if;
	end process;
end ram;