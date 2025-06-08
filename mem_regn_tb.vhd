LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem_regn_tb IS
END mem_regn_tb;

ARCHITECTURE behavior OF mem_regn_tb IS
    CONSTANT data_width : INTEGER := 8;
    SIGNAL clr : STD_LOGIC;
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL decide : STD_LOGIC;
    SIGNAL en : STD_LOGIC;
    SIGNAL init_d : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL d : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL q : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
BEGIN
    dut : mem_regn GENERIC MAP(8) PORT MAP(clr, clk, decide, en, init_d, d, q);
    clk_period : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR half_clk_period;
    END PROCESS;
    --
    stim_proc : PROCESS
    BEGIN
        clr <= '1';
        WAIT FOR 20 ns;
        clr <= '0';
        init_d <= X"11";
        d <= X"66";
        WAIT FOR 20 ns;
        en <= '1';
        WAIT FOR 100 ns;
        decide <= '1';
        WAIT FOR 40 ns;
        decide <= '0';
        en <= '0';
        WAIT FOR 60 ns;
        en <= '1';
        WAIT;
    END PROCESS;
END behavior;