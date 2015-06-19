library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
    port (
        reset : in std_logic;
        clock : in std_logic;
        hs    : out std_logic;
        vs    : out std_logic;
        video_on : out std_logic
    );
end vga;

architecture vga of vga is
    signal cnt_vs : unsigned(19 downto 0);
    signal cnt_hs : unsigned(10 downto 0);
begin

    hs <= '1' when cnt_hs >= 16#358# and cnt_hs <= 16#3cf# else '0';
    vs <= '1' when cnt_vs >= 16#a1bd0# and cnt_vs <= 16#a342f# else '0';

    video_on <= '1' when (cnt_hs >= 16#15e# and cnt_hs <= 16#1c1#) and
                         (cnt_vs >= 16#46939# and cnt_vs <= 16#62865#) else '0';

    process (clock)
    begin
        if clock'event and clock = '1' then
            if reset = '1' then
                cnt_vs <= (others => '0');
                cnt_hs <= (others => '0');
            else
                if unsigned(cnt_vs) < 16#a919f# then
                    cnt_vs <= unsigned(unsigned(cnt_vs) + 1);
                else
                    cnt_vs <= (others => '0');
                end if;

                if unsigned(cnt_hs) < 16#40f# then
                    cnt_hs <= unsigned(unsigned(cnt_hs) + 1);
                else 
                    cnt_hs <= (others => '0');
                end if;
            end if;
        end if;
    end process;
end vga;
