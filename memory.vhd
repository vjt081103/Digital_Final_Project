LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;
USE ieee.numeric_std.ALL;

ENTITY memory IS
    PORT (
        clr : IN STD_LOGIC := '0';
        clk : IN STD_LOGIC := '1';
        address_read : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        address_read_check : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        address_write_init : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        address_write : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        --
        read_en : IN STD_LOGIC := '1';
        read_check_en : IN STD_LOGIC := '1';
        write_init_en : IN STD_LOGIC;
        write_en : IN STD_LOGIC := '0';
        data_read : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        data_write : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

        data_init : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        decide : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavior OF memory IS
    SIGNAL d : mem128;
    SIGNAL q : mem128;
    SIGNAL init_d : mem128;
    SIGNAL en : STD_LOGIC_VECTOR (127 DOWNTO 0);
    SIGNAL sub_out : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sup_read_en : STD_LOGIC;
BEGIN
    generate_regs : FOR i IN 0 TO 127 GENERATE
        reg_i : mem_regn GENERIC MAP(8) PORT MAP(clr, clk, decide, en(i), init_d(i), d(i), q(i));
    END GENERATE;
    reg_out : regn GENERIC MAP(8) PORT MAP(clr, clk, sup_read_en, sub_out, data_read);

    PROCESS (address_read, address_write_init, address_read_check, read_check_en, write_init_en, address_write, read_en, write_en, data_write, data_init, decide)
        VARIABLE num_address_read : INTEGER := 0;
        VARIABLE num_address_write : INTEGER := 0;
        VARIABLE num_address_write_init : INTEGER := 0;
        VARIABLE num_address_read_check : INTEGER := 0;
    BEGIN
        num_address_read := to_integer(unsigned(address_read));
        num_address_write := to_integer(unsigned(address_write));
        num_address_write_init := to_integer(unsigned(address_write_init));
        num_address_read_check := to_integer(unsigned(address_read_check));
        en <= (OTHERS => '0');
        IF (decide = '1') THEN
            en(num_address_write_init) <= '1' AND write_init_en;
            sub_out <= q(num_address_read_check);
            sup_read_en <= read_check_en;
        ELSE
            en(num_address_write) <= '1' AND write_en;
            sub_out <= q(num_address_read);
            sup_read_en <= read_en;
        END IF;
        d(num_address_write) <= data_write;
        init_d(num_address_write_init) <= data_init;
    END PROCESS;
END behavior;