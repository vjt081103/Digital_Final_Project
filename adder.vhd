LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY adder IS
    GENERIC (data_width : INTEGER);
    PORT (
        a : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        c : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END adder;

ARCHITECTURE behavior OF adder IS
    SIGNAL r : STD_LOGIC_VECTOR(data_width DOWNTO 0);
BEGIN
    r(0) <= '0';
    ripple_gen : FOR i IN 0 TO (data_width - 1) GENERATE
        r(i + 1) <= (a(i) AND b(i)) OR (a(i) AND r(i) AND NOT b(i)) OR (NOT a(i) AND r(i) AND b(i));
        c(i) <= a(i) XOR b(i) XOR r(i);
    END GENERATE;
    --c(3 * n) <= r(3 * n);
END behavior;