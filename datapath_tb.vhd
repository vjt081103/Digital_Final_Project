LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY datapath_tb IS
END datapath_tb;

ARCHITECTURE behavior OF datapath_tb IS

    SIGNAL clr : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL m_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL m_load : STD_LOGIC := '0';
    SIGNAL n_load : STD_LOGIC := '0';
    SIGNAL i_load : STD_LOGIC := '0';
    SIGNAL j_load : STD_LOGIC := '0';
    SIGNAL k_load : STD_LOGIC := '0';
    SIGNAL p_load : STD_LOGIC := '0';
    SIGNAL sum_load : STD_LOGIC := '0';
    SIGNAL image_value : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR (sum_width - 1 DOWNTO 0);
    --SIGNAL image_value_int : INTEGER := 0;
BEGIN

    dut : datapath GENERIC MAP(sum_width, input_width, loop_width)
    PORT MAP(clr, clk, m_i, n_i, m_load, n_load, i_load, j_load, k_load, p_load, sum_load, image_value, data_out);

    clk_proc : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR half_clk_period;
    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        clr <= '1';
        WAIT FOR 5 ns;
        clr <= '0';
        image_value <= X"00";
        sum_load <= '1';
        WAIT FOR clk_period;
        image_value <= X"02";
        sum_load <= '1';
        WAIT FOR clk_period;
        image_value <= X"05";
        sum_load <= '1';
        WAIT FOR clk_period;
        sum_load <= '0';
        image_value <= X"10";
        WAIT;
    END PROCESS;

END behavior;