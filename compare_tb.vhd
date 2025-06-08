LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;
ENTITY compare_tb IS
END ENTITY;

ARCHITECTURE behavior OF compare_tb IS

    SIGNAL a : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL b : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y : STD_LOGIC := '0';
BEGIN
    dut : compare GENERIC MAP(8) PORT MAP(a, b, y);
    stim_pros : PROCESS
    BEGIN
        a <= X"12";
        b <= X"13";
        WAIT FOR 100 ns;
        b <= X"12";
        WAIT;
    END PROCESS;

END behavior;