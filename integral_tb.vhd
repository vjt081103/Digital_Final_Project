LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mypackage.ALL;

ENTITY integral_tb IS
END integral_tb;

ARCHITECTURE behavior OF integral_tb IS
    COMPONENT integral IS
        GENERIC (
            input_width : INTEGER := 9;
            data_width : INTEGER := 8;
            address_width : INTEGER := 32
        );
        PORT (
            clr : IN STD_LOGIC := '0';
            clk : IN STD_LOGIC := '0';
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
            data_read : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            data_write : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
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
    SIGNAL m_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0) := "000000000";
    SIGNAL n_i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0) := "000000000";
    --
    SIGNAL address_src_i : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := X"00000000";
    SIGNAL address_des_i : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := X"00000000";
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
    SIGNAL data_read : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL data_write : STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
    SIGNAL data_init : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL decide : STD_LOGIC := '1';
    SIGNAL address_read_check : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
    SIGNAL read_check_en : STD_LOGIC := '0';
    SIGNAL write_init_en : STD_LOGIC;
    SIGNAL check : STD_LOGIC := '0';
BEGIN
    integral_dut : integral
    GENERIC MAP
    (
        input_width,
        data_width,
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
    init_data_proc : PROCESS
        VARIABLE number_init : INTEGER;
    BEGIN
        clr <= '1';
        WAIT FOR 20 ns;
        clr <= '0';
        write_init_en <= '1';
        WAIT FOR 20 ns;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(0, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(121, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(1, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(226, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(2, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(181, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(3, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(226, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(4, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(149, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(5, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(174, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(6, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(197, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(7, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(62, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(8, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(35, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(9, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(4, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(10, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(245, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(11, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(179, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(12, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(112, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(13, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(41, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(14, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(140, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(15, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(230, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(16, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(163, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(17, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(142, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(18, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(119, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(19, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(234, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(20, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(134, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(21, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(104, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(22, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(206, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(23, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(90, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(24, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(85, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(25, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(214, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(26, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(90, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(27, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(124, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(28, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(88, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(29, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(27, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(30, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(70, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(31, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(190, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(32, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(92, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(33, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(30, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(34, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(195, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(35, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(219, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(36, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(181, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(37, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(255, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(38, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(52, 8));
        WAIT FOR clk_period;
        address_write_init <= STD_LOGIC_VECTOR(to_unsigned(39, 8));
        data_init <= STD_LOGIC_VECTOR(to_unsigned(204, 8));
        WAIT FOR clk_period;

        write_init_en <= '0';
        WAIT;
    END PROCESS;
    check_process : PROCESS
    BEGIN
        WAIT UNTIL done = '1';
        WAIT FOR 40 ns;
        FOR i IN 0 TO 255 LOOP
            address_read_check <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            read_check_en <= '1';
            WAIT FOR clk_period;
        END LOOP;
        check <= '1';
        WAIT FOR 10 ns;
        check <= '0';
        read_check_en <= '0';
        WAIT FOR 10 ns;
    END PROCESS;
    stim_proc : PROCESS
    BEGIN
        WAIT FOR 3000 ns;
        decide <= '0';
        m_i <= STD_LOGIC_VECTOR(to_unsigned(3, input_width));
        n_i <= STD_LOGIC_VECTOR(to_unsigned(3, input_width));
        address_src_i <= STD_LOGIC_VECTOR(to_unsigned(0, address_width));
        address_des_i <= STD_LOGIC_VECTOR(to_unsigned(45, address_width));
        start <= '1';
        WAIT FOR 40 ns;
        start <= '0';
        WAIT UNTIL (done = '1');
        decide <= '1';

        --
        WAIT UNTIL (check = '1');
        decide <= '0';
        m_i <= STD_LOGIC_VECTOR(to_unsigned(5, input_width));
        n_i <= STD_LOGIC_VECTOR(to_unsigned(5, input_width));
        start <= '1';
        WAIT FOR 40 ns;
        start <= '0';
        WAIT UNTIL (done = '1');
        decide <= '1';

        --
        WAIT UNTIL (check = '1');
        decide <= '0';
        m_i <= STD_LOGIC_VECTOR(to_unsigned(5, input_width));
        n_i <= STD_LOGIC_VECTOR(to_unsigned(7, input_width));
        start <= '1';
        WAIT FOR 40 ns;
        start <= '0';
        WAIT UNTIL (done = '1');
        decide <= '1';
        WAIT;
    END PROCESS;
END behavior;