LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE mypackage IS
    TYPE mem256 IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT half_clk_period : TIME := 10 ns;
    CONSTANT clk_period : TIME := 20 ns;
    CONSTANT data_width : INTEGER := 8;
    CONSTANT input_width : INTEGER := 9;
    CONSTANT address_width : INTEGER := 32;

    COMPONENT mem_regn IS
        GENERIC (
            data_width : INTEGER := 8
        );
        PORT (
            clr : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            decide : IN STD_LOGIC;
            en : IN STD_LOGIC;
            init_d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT compare IS
        GENERIC (
            data_width : INTEGER := 8
        );
        PORT (
            a : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            y : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT regn IS
        GENERIC (
            data_width : INTEGER
        );
        PORT (
            clr : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT counter IS
        GENERIC (data_width : INTEGER);
        PORT (
            clr : IN STD_LOGIC := '0';
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            stop_number : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            number : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT adder IS
        GENERIC (data_width : INTEGER);
        PORT (
            a : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
            c : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT threetimes IS
        GENERIC (data_width : INTEGER);
        PORT (
            data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT controller IS
        GENERIC (
            input_width : INTEGER := 9;
            data_width : INTEGER := 8;
            address_width : INTEGER := 32
        );

        PORT (
            clr : IN STD_LOGIC := '0';
            clk : IN STD_LOGIC := '0';
            start : IN STD_LOGIC;
            done : OUT STD_LOGIC;
            --
            m_load : OUT STD_LOGIC := '0';
            n_load : OUT STD_LOGIC := '0';
            --
            address_src_load : OUT STD_LOGIC := '0';
            address_des_load : OUT STD_LOGIC := '0';
            --
            data_out_load : OUT STD_LOGIC;
            mem_num_increase : OUT STD_LOGIC;
            i_increase : OUT STD_LOGIC;
            j_increase : OUT STD_LOGIC;
            i_and_j_neq_0 : IN STD_LOGIC;
            --
            data_out_set_0 : OUT STD_LOGIC;
            i_set_0 : OUT STD_LOGIC;
            i_get_max : IN STD_LOGIC;
            j_set_0 : OUT STD_LOGIC;
            j_get_max : IN STD_LOGIC;
            mem_num_set_0 : OUT STD_LOGIC;
            mem_num_get_max : IN STD_LOGIC;
            sup_data_in_load : OUT STD_LOGIC;
            data_in_load : OUT STD_LOGIC;
            data_in_sel : OUT STD_LOGIC;

            --
            address_read_load : OUT STD_LOGIC;
            address_write_load : OUT STD_LOGIC;
            address_read_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            address_write_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            address_read_step_sel : OUT STD_LOGIC;
            address_write_step_sel : OUT STD_LOGIC;
            -- 
            read_en : OUT STD_LOGIC;
            write_en : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT datapath IS
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
            m_load : IN STD_LOGIC := '0';
            n_load : IN STD_LOGIC := '0';
            --
            address_src_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_des_i : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_src_load : IN STD_LOGIC := '0';
            address_des_load : IN STD_LOGIC := '0';
            --
            data_out_load : IN STD_LOGIC;
            data_read : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            data_write : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
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
            address_read : OUT STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
            address_write : OUT STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
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
    END COMPONENT;
END mypackage;