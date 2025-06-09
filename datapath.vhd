LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;

ENTITY datapath IS
    GENERIC (
        input_width : INTEGER := 8;
        data_read_width : INTEGER := 8;
        data_write_width : INTEGER := 8;
        address_width : INTEGER := 32
    );
    PORT (
        clr : IN STD_LOGIC := '0';
        clk : IN STD_LOGIC := '0';
        --
        m_i : IN STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
        n_i : IN STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
        m_load : IN STD_LOGIC := '0';
        n_load : IN STD_LOGIC := '0';
        --
        address_src_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
        address_des_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
        address_src_load : IN STD_LOGIC := '0';
        address_des_load : IN STD_LOGIC := '0';
        --
        data_out_load : IN STD_LOGIC;
        data_read : IN STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
        data_write : OUT STD_LOGIC_VECTOR (data_write_width - 1 DOWNTO 0);
        mem_num_increase : IN STD_LOGIC;
        i_increase : IN STD_LOGIC;
        j_increase : IN STD_LOGIC;
        i_and_j_neq_0 : OUT STD_LOGIC;

        --
        data_out_set_0 : IN STD_LOGIC;
        i_set_0 : IN STD_LOGIC;
        j_set_0 : IN STD_LOGIC;
        mem_num_set_0 : IN STD_LOGIC;
        sup_data_in_load : IN STD_LOGIC;
        data_in_load : IN STD_LOGIC;
        data_in_sel : IN STD_LOGIC;
        --
        address_read : BUFFER STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
        address_write : BUFFER STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
        address_read_load : IN STD_LOGIC;
        address_write_load : IN STD_LOGIC;
        address_read_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        address_write_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        address_read_step_sel : IN STD_LOGIC;
        address_write_step_sel : IN STD_LOGIC;
        --
        i_get_max : OUT STD_LOGIC;
        j_get_max : OUT STD_LOGIC;
        mem_num_get_max : OUT STD_LOGIC

    );
END datapath;

ARCHITECTURE behavior OF datapath IS
    SIGNAL m : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL n : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL address_des : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_src : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);

    SIGNAL m_add_1 : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL n_add_1 : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL one_cal_input_width : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(data_write_width * 3 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out_sup : STD_LOGIC_VECTOR(data_write_width * 3 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out_reset : STD_LOGIC;
    --
    SIGNAL data_in : STD_LOGIC_VECTOR(data_read_width * 3 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in1 : STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
    SIGNAL data_in2 : STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
    SIGNAL data_in3 : STD_LOGIC_VECTOR(data_read_width - 1 DOWNTO 0);
    SIGNAL extension_data_in : STD_LOGIC_VECTOR(data_read_width * 2 - 1 DOWNTO 0);
    --
    SIGNAL i_reset : STD_LOGIC;
    SIGNAL j_reset : STD_LOGIC;
    SIGNAL mem_num_reset : STD_LOGIC;
    SIGNAL i : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL j : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL i_eq_0 : STD_LOGIC;
    SIGNAL j_eq_0 : STD_LOGIC;
    SIGNAL zero_cal_input_width : STD_LOGIC_VECTOR(input_width - 1 DOWNTO 0);
    SIGNAL mem_num : STD_LOGIC_VECTOR(1 DOWNTO 0);
    --
    SIGNAL data_in1_load : STD_LOGIC;
    SIGNAL data_in2_load : STD_LOGIC;
    SIGNAL data_in3_load : STD_LOGIC;

    --
    SIGNAL data_out1 : STD_LOGIC_VECTOR(data_write_width - 1 DOWNTO 0);
    SIGNAL data_out2 : STD_LOGIC_VECTOR(data_write_width - 1 DOWNTO 0);
    SIGNAL data_out3 : STD_LOGIC_VECTOR(data_write_width - 1 DOWNTO 0);
    --
    SIGNAL j_cal : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL j_3 : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL n_cal : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL n_3 : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL extension : STD_LOGIC_VECTOR(address_width - 1 - input_width DOWNTO 0);
    SIGNAL one_cal_address_width : STD_LOGIC_VECTOR (address_width - 1 DOWNTO 0);
    --
    SIGNAL address_read_step : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_write_step : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_read_increase : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_write_increase : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    --
    SIGNAL sup_data_in : STD_LOGIC_VECTOR(3 * data_read_width - 1 DOWNTO 0);
    SIGNAL sup_address_read : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL sup_address_write : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
    SIGNAL address_des_plus_3j : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
BEGIN
    data_out_reset <= data_out_set_0 OR clr;
    i_reset <= i_set_0 OR clr;
    j_reset <= j_set_0 OR clr;
    mem_num_reset <= mem_num_set_0 OR clr;
    --
    m_regn : regn
    GENERIC MAP(input_width)
    PORT MAP(clr, clk, m_load, m_i, m);
    n_regn : regn
    GENERIC MAP(input_width)
    PORT MAP(clr, clk, n_load, n_i, n);
    address_src_regn : regn
    GENERIC MAP(address_width)
    PORT MAP(clr, clk, address_src_load, address_src_i, address_src);
    address_des_regn : regn
    GENERIC MAP(address_width)
    PORT MAP(clr, clk, address_des_load, address_des_i, address_des);
    data_out_regn : regn
    GENERIC MAP(data_write_width * 3)
    PORT MAP(data_out_reset, clk, data_out_load, data_out_sup, data_out);

    --
    data_out1 <= data_out(data_write_width * 3 - 1 DOWNTO data_write_width * 2);
    data_out2 <= data_out(data_write_width * 2 - 1 DOWNTO data_write_width);
    data_out3 <= data_out(data_write_width - 1 DOWNTO 0);

    --
    data_write <= data_out2 WHEN mem_num = "01" ELSE
        data_out3 WHEN mem_num = "10" ELSE
        data_out1;

    --
    one_cal_input_width <= (input_width - 1 DOWNTO 1 => '0') & '1';
    data_out_adder : adder
    GENERIC MAP(data_write_width * 3)
    PORT MAP(data_in, data_out, data_out_sup);
    m_add_1_adder : adder
    GENERIC MAP(input_width)
    PORT MAP(m, one_cal_input_width, m_add_1);
    n_add_1_adder : adder
    GENERIC MAP(input_width)
    PORT MAP(n, one_cal_input_width, n_add_1);

    --

    i_counter : counter
    GENERIC MAP(input_width)
    PORT MAP(i_reset, clk, i_increase, m_add_1, i);
    j_counter : counter
    GENERIC MAP(input_width)
    PORT MAP(j_reset, clk, j_increase, n_add_1, j);
    mem_num_counter : counter
    GENERIC MAP(2)
    PORT MAP(mem_num_reset, clk, mem_num_increase, "11", mem_num);
    --
    zero_cal_input_width <= (OTHERS => '0');
    i_compare_0 : compare
    GENERIC MAP(input_width)
    PORT MAP(i, zero_cal_input_width, i_eq_0);
    j_compare_0 : compare
    GENERIC MAP(input_width)
    PORT MAP(j, zero_cal_input_width, j_eq_0);
    i_and_j_neq_0 <= (NOT i_eq_0) AND (NOT j_eq_0);
    --
    i_compare_max : compare
    GENERIC MAP(input_width)
    PORT MAP(i, m_add_1, i_get_max);
    j_compare_max : compare
    GENERIC MAP(input_width)
    PORT MAP(j, n_add_1, j_get_max);
    mem_num_compare_max : compare
    GENERIC MAP(2)
    PORT MAP(mem_num, "11", mem_num_get_max);

    --
    data_in1_load <= (NOT mem_num(1)) AND (NOT mem_num(0)) AND sup_data_in_load;
    data_in2_load <= (NOT mem_num(1)) AND (mem_num(0)) AND sup_data_in_load;
    data_in3_load <= (mem_num(1)) AND (NOT mem_num(0)) AND sup_data_in_load;
    data_in1_regn : regn
    GENERIC MAP(data_read_width)
    PORT MAP(clr, clk, data_in1_load, data_read, data_in1);
    data_in2_regn : regn
    GENERIC MAP(data_read_width)
    PORT MAP(clr, clk, data_in2_load, data_read, data_in2);
    data_in3_regn : regn
    GENERIC MAP(data_read_width)
    PORT MAP(clr, clk, data_in3_load, data_read, data_in3);
    --
    one_cal_address_width <= (address_width - 1 DOWNTO 1 => '0') & '1';
    extension <= (OTHERS => '0');
    j_cal <= extension & j;
    n_cal <= extension & n;
    j_three_times : threetimes
    GENERIC MAP(address_width)
    PORT MAP(j_cal, j_3);
    n_three_times : threetimes
    GENERIC MAP(address_width)
    PORT MAP(n_cal, n_3);
    address_des_plus_3j_adder : adder
    GENERIC MAP(address_width)
    PORT MAP(address_des, j_3, address_des_plus_3j);

    --
    address_read_regn : regn
    GENERIC MAP(address_width)
    PORT MAP(clr, clk, address_read_load, sup_address_read, address_read);
    address_write_regn : regn
    GENERIC MAP(address_width)
    PORT MAP(clr, clk, address_write_load, sup_address_write, address_write);

    address_read_adder : adder
    GENERIC MAP(address_width)
    PORT MAP(address_read, address_read_step, address_read_increase);
    address_write_adder : adder
    GENERIC MAP(address_width)
    PORT MAP(address_write, address_write_step, address_write_increase);

    -- 
    sup_address_read <= address_read_increase WHEN address_read_sel = "01" ELSE
        address_des_plus_3j WHEN address_read_sel = "10" ELSE
        address_des WHEN address_read_sel = "11" ELSE
        address_src;
    --

    sup_address_write <= address_write_increase WHEN address_write_sel = "01" ELSE
        address_des_plus_3j WHEN address_write_sel = "10" ELSE
        address_des;

    --
    address_write_step <= n_3 WHEN address_write_step_sel = '1' ELSE
        one_cal_address_width;

    address_read_step <= n_3 WHEN address_read_step_sel = '1' ELSE
        one_cal_address_width;
    --
    extension_data_in <= (OTHERS => '0');
    sup_data_in <= data_in1 & data_in2 & data_in3 WHEN data_in_sel = '1' ELSE
        extension_data_in & data_read;
    data_in_regn : regn
    GENERIC MAP(data_read_width * 3)
    PORT MAP(clr, clk, data_in_load, sup_data_in, data_in);

END behavior;