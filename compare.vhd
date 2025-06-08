LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY compare IS
    GENERIC (data_width : INTEGER := 9);
    PORT (
        a : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        y : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavior OF compare IS
BEGIN
    y <= '1' WHEN (a = b) ELSE
        '0';
END behavior;