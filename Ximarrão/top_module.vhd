library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module is
    generic (
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 16
    );
    port (
        clock_50 : in std_logic;
        key      : in std_logic_vector(2 downto 0);
        VGA_HS   : out std_logic;
        VGA_VS   : out std_logic;
        VGA_R    : out std_logic_vector(3 downto 0);
        VGA_G    : out std_logic_vector(3 downto 0);
        VGA_B    : out std_logic_vector(3 downto 0)
    );
end top_module;

architecture top_module of top_module is
    signal video_on : std_logic;
    signal reset    : std_logic;
    signal pixel    : std_logic_vector(11 downto 0);
    signal addr     : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal data_o   : std_logic_vector(DATA_WIDTH-1 downto 0) 
begin
    reset <= not key(0);

    addr <= 0;

    vga : entity work.vga
    port map (reset, clock_50, vga_hs, vga_vs, video_on);
 
    ram : entity work.ram
    port map (
        addr   => addr, 
        data_o => data_o
    );

    pixel <= data_o(11 downto 0);

    process (clock_50)
    begin
        if clock_50'event and clock_50 = '1' then
            pixel <= std_logic_vector(unsigned(pixel) + 1);
        end if;
    end process;

    process (video_on, pixel)
    begin
        if video_on = '1' then
            vga_r <= pixel(11 downto 8);
            vga_g <= pixel(7 downto 4);
            vga_b <= pixel(3 downto 0);
        else
            vga_r <= "0000";
            vga_g <= "0000";
            vga_b <= "0000";
        end if;
    end process;
end top_module;
