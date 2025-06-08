LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE behavior OF counter_tb IS
    SIGNAL clr : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL stop_number : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
    SIGNAL number : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
    SIGNAL en : STD_LOGIC := '1';
BEGIN
    dut : counter GENERIC MAP(8) PORT MAP(clr, clk, en, stop_number, number);
    stim_proc : PROCESS
    BEGIN
        stop_number <= X"AC";
        WAIT FOR 195 ns;
        clr <= '1';
        WAIT FOR 20 ns;
        clr <= '0';
        WAIT FOR 200 ns;
        en <= '0';
        WAIT FOR 50 ns;
        en <= '1';
        WAIT;
    END PROCESS;
    clk_proc : PROCESS
    BEGIN
        WAIT FOR half_clk_period;
        clk <= NOT clk;
    END PROCESS;
END behavior;