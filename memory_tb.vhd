LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;
USE ieee.numeric_std.ALL;
ENTITY memory_tb IS
END memory_tb;

ARCHITECTURE behavior OF memory_tb IS
    COMPONENT memory IS
        GENERIC (
            data_width : INTEGER := 8;
            address_width : INTEGER := 32
        );
        PORT (
            clr : IN STD_LOGIC := '0';
            clk : IN STD_LOGIC := '1';
            address_read : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_read_check : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            address_write_init : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            address_write : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            --
            read_en : IN STD_LOGIC := '1';
            read_check_en : IN STD_LOGIC := '1';
            write_init_en : IN STD_LOGIC;
            write_en : IN STD_LOGIC := '0';
            data_read : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
            data_write : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);

            data_init : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            decide : IN STD_LOGIC
        );
    END COMPONENT;
    CONSTANT address_width : INTEGER := 32;
    CONSTANT data_width : INTEGER := 8;
    SIGNAL clr : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL address_read : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_write : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_read_check : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL address_write_init : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL read_en : STD_LOGIC := '1';
    SIGNAL read_check_en : STD_LOGIC;
    SIGNAL write_init_en : STD_LOGIC;
    SIGNAL write_en : STD_LOGIC := '0';
    SIGNAL data_read : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL data_write : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL data_init : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL decide : STD_LOGIC;
    --
    SIGNAL d : mem256;
BEGIN
    dut : memory
    GENERIC MAP(
        data_width,
        address_width
    )
    PORT MAP(
        clr,
        clk,
        address_read,
        address_read_check,
        address_write_init,
        address_write,
        --
        read_en,
        read_check_en,
        write_init_en,
        write_en,
        data_read,
        data_write,
        --
        data_init,
        decide
    );
    clk_proc : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR half_clk_period;
    END PROCESS;

    save_proc : PROCESS
    BEGIN
        clr <= '1';
        WAIT FOR 5 ns;
        clr <= '0';
        --Kiem tra xem bo nho chuyen thanh 0 het chua
        FOR i IN 0 TO 255 LOOP
            address_read <= STD_LOGIC_VECTOR(to_unsigned(i, address_width));
            read_en <= '1';
            WAIT FOR clk_period;
        END LOOP;

        --Khoi tao gia tri cho bo nho
        FOR i IN 0 TO 255 LOOP
            d(i) <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
        END LOOP;
        decide <= '1';
        WAIT FOR 1 ns;
        FOR i IN 0 TO 255 LOOP
            address_read_check <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            read_check_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        FOR i IN 0 TO 255 LOOP
            address_write_init <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            data_init <= d(i);
            write_init_en <= '1' AND d(i)(0);
            WAIT FOR clk_period;
            address_read <= STD_LOGIC_VECTOR(to_unsigned(i, address_width));
            WAIT FOR clk_period;
        END LOOP;
        FOR i IN 0 TO 255 LOOP
            address_read_check <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            read_check_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        read_check_en <= '0';
        decide <= '0';
        WAIT FOR clk_period;
        FOR i IN 0 TO 127 LOOP
            address_read <= STD_LOGIC_VECTOR(to_unsigned(i, address_width));
            read_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        address_write <= STD_LOGIC_VECTOR(to_unsigned(111, address_width));
        data_write <= STD_LOGIC_VECTOR(to_unsigned(200, 8));
        write_en <= '1';
        WAIT FOR clk_period;
        address_read <= STD_LOGIC_VECTOR(to_unsigned(111, address_width));

        WAIT;
    END PROCESS;

END behavior;