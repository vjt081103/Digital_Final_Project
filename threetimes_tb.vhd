LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY threetimes_tb IS
END threetimes_tb;

ARCHITECTURE behavior OF threetimes_tb IS
    CONSTANT data_width : INTEGER := 32;
    SIGNAL data_in : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
BEGIN
    dut : threetimes
    GENERIC MAP(data_width)
    PORT MAP(data_in, data_out);
    stim_proc : PROCESS
    BEGIN
        data_in <= X"00000002";
        WAIT FOR 20 ns;
        data_in <= X"0E000004";
        WAIT;
    END PROCESS;

END behavior;