LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;

ENTITY integral IS
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
END integral;
ARCHITECTURE behavior OF integral IS
    SIGNAL m_load : STD_LOGIC := '0';
    SIGNAL n_load : STD_LOGIC := '0';
    SIGNAL address_src_load : STD_LOGIC := '0';
    SIGNAL address_des_load : STD_LOGIC := '0';
    SIGNAL data_out_load : STD_LOGIC;

    SIGNAL mem_num_increase : STD_LOGIC;
    SIGNAL i_increase : STD_LOGIC;
    SIGNAL j_increase : STD_LOGIC;
    SIGNAL i_and_j_neq_0 : STD_LOGIC;

    SIGNAL data_out_set_0 : STD_LOGIC;
    SIGNAL i_set_0 : STD_LOGIC;
    SIGNAL j_set_0 : STD_LOGIC;
    SIGNAL mem_num_set_0 : STD_LOGIC;
    SIGNAL sup_data_in_load : STD_LOGIC;
    SIGNAL data_in_load : STD_LOGIC;
    SIGNAL data_in_sel : STD_LOGIC;
    --

    SIGNAL address_read_load : STD_LOGIC;
    SIGNAL address_write_load : STD_LOGIC;
    SIGNAL address_read_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL address_write_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL address_read_step_sel : STD_LOGIC;
    SIGNAL address_write_step_sel : STD_LOGIC;
    --
    SIGNAL i_get_max : STD_LOGIC;
    SIGNAL j_get_max : STD_LOGIC;
    SIGNAL mem_num_get_max : STD_LOGIC;
BEGIN

    controller_dut : controller
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
        start,
        done,
        --
        m_load,
        n_load,
        --
        address_src_load,
        address_des_load,
        --
        data_out_load,
        mem_num_increase,
        i_increase,
        j_increase,
        i_and_j_neq_0,
        --
        data_out_set_0,
        i_set_0,
        i_get_max,
        j_set_0,
        j_get_max,
        mem_num_set_0,
        mem_num_get_max,
        sup_data_in_load,
        data_in_load,
        data_in_sel,

        --
        address_read_load,
        address_write_load,
        address_read_sel,
        address_write_sel,
        address_read_step_sel,
        address_write_step_sel,
        -- 
        read_en,
        write_en
    );

    datapath_dut : datapath
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
        --
        m_i,
        n_i,
        m_load,
        n_load,
        --
        address_src_i,
        address_des_i,
        address_src_load,
        address_des_load,
        --
        data_out_load,
        data_read,
        data_write,
        mem_num_increase,
        i_increase,
        j_increase,
        i_and_j_neq_0,

        --
        data_out_set_0,
        i_set_0,
        j_set_0,
        mem_num_set_0,
        sup_data_in_load,
        data_in_load,
        data_in_sel,
        --
        address_read,
        address_write,
        address_read_load,
        address_write_load,
        address_read_sel,
        address_write_sel,
        address_read_step_sel,
        address_write_step_sel,
        --
        i_get_max,
        j_get_max,
        mem_num_get_max

    );
END behavior;