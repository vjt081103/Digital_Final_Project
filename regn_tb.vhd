LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;

ENTITY regn_tb IS
END ENTITY;

ARCHITECTURE behavior OF regn_tb IS
    --CONSTANT data_width : INTEGER := 8;
    SIGNAL clr, clk : STD_LOGIC := '0';
    SIGNAL en : STD_LOGIC := '0';
    SIGNAL d : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL q : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
BEGIN
    dut : regn GENERIC MAP(data_width) PORT MAP(clr, clk, en, d, q);
    stim_proc : PROCESS
    BEGIN
        d <= X"34";
        WAIT FOR 15 ns;
        clr <= '1';
        WAIT FOR 10 ns;
        clr <= '0';
        WAIT FOR 10 ns;
        en <= '1';
        WAIT;
    END PROCESS;

    clk_period : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR half_clk_period;
    END PROCESS;
END behavior;