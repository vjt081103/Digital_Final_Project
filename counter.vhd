LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY counter IS
    GENERIC (data_width : INTEGER := 8);
    PORT (
        clr : IN STD_LOGIC := '0';
        clk : IN STD_LOGIC;
        en : IN STD_LOGIC;
        stop_number : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        number : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavior OF counter IS
    SIGNAL number_proc : INTEGER := 0;
    SIGNAL stop_number_proc : INTEGER := 0;
BEGIN
    stop_number_proc <= to_integer(unsigned(stop_number));
    PROCESS (clr, clk)
    BEGIN
        IF (clr = '1') THEN
            number_proc <= 0;
        ELSIF (clk'event AND clk = '1' AND en = '1') THEN
            IF (number_proc = stop_number_proc) THEN
                number_proc <= 0;
            ELSE
                number_proc <= number_proc + 1;
            END IF;
        END IF;
    END PROCESS;
    number <= STD_LOGIC_VECTOR(to_unsigned(number_proc, data_width));
END behavior;