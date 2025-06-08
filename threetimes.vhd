LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY threetimes IS
    GENERIC (data_width : INTEGER);
    PORT (
        data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END threetimes;

ARCHITECTURE behavior OF threetimes IS
    SIGNAL data_in_shift : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL data_out_sup : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);

BEGIN
    data_in_shift <= data_in(6 DOWNTO 0) & '0';
    dut : adder
    GENERIC MAP(data_width)
    PORT MAP(data_in_shift, data_in, data_out_sup);
    data_out <= data_out_sup;
END behavior;