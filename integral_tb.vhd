LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY integral_tb IS
END integral_tb;

ARCHITECTURE behavior OF integral_tb IS
    CONSTANT input_width : INTEGER := 8;
    CONSTANT data_read_width : INTEGER := 8;
    CONSTANT data_write_width : INTEGER := 8;
    CONSTANT address_width : INTEGER := 32;
    COMPONENT integral IS
        GENERIC (
            input_width : INTEGER := 8;
            data_read_width : INTEGER := 8;
            data_write_width : INTEGER := 8;
            address_width : INTEGER := 32
        );
        PORT (
            clr : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            --
            m_i : IN STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
            n_i : IN STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
            --
            address_src_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_des_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            start : IN STD_LOGIC;
            done : OUT STD_LOGIC;
            --
            read_en : OUT STD_LOGIC;
            write_en : OUT STD_LOGIC;
            --
            address_read : OUT STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_write : OUT STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            --
            data_read : IN STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
            data_write : OUT STD_LOGIC_VECTOR (data_write_width - 1 DOWNTO 0)
        );
    END COMPONENT;

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
    SIGNAL clr : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    --
    SIGNAL m_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL n_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    --
    SIGNAL address_src_i : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_des_i : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL start : STD_LOGIC;
    SIGNAL done : STD_LOGIC;
    --
    SIGNAL read_en : STD_LOGIC;
    SIGNAL write_en : STD_LOGIC;
    --
    SIGNAL address_read : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_write : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_write_init : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --
    SIGNAL data_read : STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
    SIGNAL data_write : STD_LOGIC_VECTOR (data_write_width - 1 DOWNTO 0);
    SIGNAL data_init : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL decide : STD_LOGIC;
    SIGNAL address_read_check : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL read_check_en : STD_LOGIC;
    SIGNAL write_init_en : STD_LOGIC;
BEGIN
    integral_dut : integral
    GENERIC MAP
    (
        input_width,
        data_read_width,
        data_write_width,
        address_width
    )
    PORT MAP
    (
        clr,
        clk,
        m_i,
        n_i,
        address_src_i,
        address_des_i,
        start,
        done,
        read_en,
        write_en,
        address_read,
        address_write,
        data_read,
        data_write
    );
    memory_dut : memory
    GENERIC MAP(
        data_read_width,
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
    init_data_proc : PROCESS
        VARIABLE number_init : INTEGER;
    BEGIN
        clr <= '1';
        WAIT FOR 20 ns;
        clr <= '0';
        decide <= '1';
        write_init_en <= '1';
        WAIT FOR 20 ns;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(0, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(145, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(1, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(201, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(2, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(2, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(3, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(218, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(4, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(126, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(5, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(235, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(6, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(147, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(7, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(83, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(8, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(139, 8));
        WAIT FOR clk_period;
        write_init_en <= '0';

        FOR i IN 0 TO 127 LOOP
            address_read_check <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            read_check_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        read_check_en <= '0';
        decide <= '0';
        WAIT UNTIL done = '1';
        WAIT FOR 40 ns;
        decide <= '1';
        FOR i IN 0 TO 127 LOOP
            address_read_check <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            read_check_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        WAIT;
    END PROCESS;
    stim_proc : PROCESS
    BEGIN
        WAIT FOR 3000 ns;
        m_i <= STD_LOGIC_VECTOR(to_unsigned(3, input_width));
        n_i <= STD_LOGIC_VECTOR(to_unsigned(3, input_width));
        address_src_i <= STD_LOGIC_VECTOR(to_unsigned(0, address_width));
        address_des_i <= STD_LOGIC_VECTOR(to_unsigned(20, address_width));
        start <= '1';
        WAIT UNTIL (done = '1');
        start <= '0';
        WAIT;
    END PROCESS;
END behavior;