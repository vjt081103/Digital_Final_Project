LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem_regn IS
    GENERIC (
        data_width : INTEGER := 8
    );
    PORT (
        clr : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        decide : IN STD_LOGIC;
        en : IN STD_LOGIC;
        init_d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END mem_regn;

ARCHITECTURE behavior OF mem_regn IS
BEGIN
    PROCESS (clr, clk)
    BEGIN
        IF (clr = '1') THEN
            q <= (OTHERS => '0');
        ELSIF (clk'event AND clk = '1' AND en = '1') THEN
            IF (decide = '1') THEN
                q <= init_d;
            ELSE
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END behavior;