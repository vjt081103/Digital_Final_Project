LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mypackage.ALL;

ENTITY controller IS
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
END controller;

ARCHITECTURE behavior OF controller IS
    TYPE state_type IS (
        s1, s2, s3, s4, s5, s6, s7, s8,
        s9, s10, s11, s12, s13, s14, s15,
        s16, s17, s18, s19, s20, s21, s22,
        s23, s24, s25, s26, s27, s28, s29,
        s30, s31, s32, s33, s34, s35, s36,
        s37, s38, s39, s40, s41
    );
    SIGNAL state : state_type;
BEGIN
    state_trans : PROCESS (clr, clk)
    BEGIN
        IF (clr = '1') THEN
            state <= s1;
        ELSIF (clk'event AND clk = '1') THEN
            CASE state IS
                WHEN s1 =>
                    state <= s2;
                WHEN s2 =>
                    IF start = '1' THEN
                        state <= s3;
                    ELSE
                        state <= s2;
                    END IF;
                WHEN s3 =>
                    state <= s4;
                WHEN s4 =>
                    state <= s5;
                WHEN s5 =>
                    IF i_get_max = '1' THEN
                        state <= s21;
                    ELSE
                        state <= s6;
                    END IF;
                WHEN s6 =>
                    state <= s7;
                WHEN s7 =>
                    IF j_get_max = '1' THEN
                        state <= s20;
                    ELSE
                        state <= s8;
                    END IF;
                WHEN s8 =>
                    IF i_and_j_neq_0 = '1' THEN
                        state <= s9;
                    ELSE
                        state <= s13;
                    END IF;
                WHEN s9 =>
                    state <= s10;
                WHEN s10 =>
                    state <= s11;
                WHEN s11 =>
                    state <= s18;
                WHEN s12 =>
                    state <= s13;
                WHEN s13 =>
                    state <= s14;
                WHEN s14 =>
                    IF mem_num_get_max = '1' THEN
                        state <= s19;
                    ELSE
                        state <= s15;
                    END IF;
                WHEN s15 =>
                    state <= s16;
                WHEN s16 =>
                    state <= s17;
                WHEN s17 =>
                    state <= s14;
                WHEN s18 =>
                    state <= s12;
                WHEN s19 =>
                    state <= s7;
                WHEN s20 =>
                    state <= s5;
                WHEN s21 =>
                    state <= s22;
                WHEN s22 =>
                    IF j_get_max = '1' THEN
                        state <= s40;
                    ELSE
                        state <= s23;
                    END IF;
                WHEN s23 =>
                    state <= s24;
                WHEN s24 =>
                    state <= s25;
                WHEN s25 =>
                    IF mem_num_get_max = '1' THEN
                        state <= s29;
                    ELSE
                        state <= s26;
                    END IF;
                WHEN s26 =>
                    state <= s27;
                WHEN s27 =>
                    state <= s28;
                WHEN s28 =>
                    state <= s25;
                WHEN s29 =>
                    state <= s30;
                WHEN s30 =>
                    state <= s31;
                WHEN s31 =>
                    state <= s32;
                WHEN s32 =>
                    IF mem_num_get_max = '1' THEN
                        state <= s36;
                    ELSE
                        state <= s33;

                    END IF;
                WHEN s33 =>
                    state <= s34;
                WHEN s34 =>
                    state <= s35;
                WHEN s35 =>
                    state <= s32;
                WHEN s36 =>
                    state <= s37;
                WHEN s37 =>
                    IF i_get_max = '1' THEN
                        state <= s39;
                    ELSE
                        state <= s38;
                    END IF;
                WHEN s38 =>
                    state <= s24;
                WHEN s39 =>
                    state <= s22;
                WHEN s40 =>
                    state <= s41;
                WHEN s41 =>
                    state <= s2;
                WHEN OTHERS =>
                    state <= s1;
            END CASE;
        END IF;
    END PROCESS;
    m_load <= '1' WHEN state = s3 ELSE
        '0';
    n_load <= '1' WHEN state = s3 ELSE
        '0';
    done <= '1' WHEN state = s40 ELSE
        '0';
    --
    address_src_load <= '1' WHEN state = s3 ELSE
        '0';

    address_des_load <= '1' WHEN state = s3 ELSE
        '0';
    --
    data_out_load <= '1' WHEN state = s11 OR state = s30 ELSE
        '0';
    mem_num_increase <= '1' WHEN state = s17 OR state = s28 OR state = s35 ELSE
        '0';
    i_increase <= '1' WHEN state = s20 OR state = s36 ELSE
        '0';
    j_increase <= '1' WHEN state = s19 OR state = s39 ELSE
        '0';
    --
    data_out_set_0 <= '1' WHEN state = s6 OR state = s23 ELSE
        '0';
    i_set_0 <= '1' WHEN state = s4 OR state = s23 ELSE
        '0';
    j_set_0 <= '1' WHEN state = s6 OR state = s21 ELSE
        '0';
    mem_num_set_0 <= '1' WHEN state = s13 OR state = s24 OR state = s31 ELSE
        '0';
    sup_data_in_load <= '1' WHEN state = s27 ELSE
        '0';
    data_in_load <= '1' WHEN state = s10 OR state = s29 ELSE
        '0';
    data_in_sel <= '1' WHEN state = s29 ELSE
        '0';

    --
    address_read_load <= '1' WHEN state = s18 OR state = s4 OR state = s21 OR state = s28 OR state = s23 OR state = s38 ELSE
        '0';
    address_write_load <= '1' WHEN state = s17 OR state = s4 OR state = s21 OR state = s23 OR state = s35 OR state = s38 ELSE
        '0';
    address_read_sel <= "01" WHEN state = s18 OR state = s28 OR state = s38 ELSE
        "11" WHEN state = s21 ELSE
        "10" WHEN state = s23 ELSE
        "00";
    address_write_sel <= "01" WHEN state = s17 OR state = s35 OR state = s38 ELSE
        "10" WHEN state <= s23 ELSE
        "00";
    address_read_step_sel <= '1' WHEN state = s38 ELSE
        '0';
    address_write_step_sel <= '1' WHEN state = s38 ELSE
        '0';
    -- 
    read_en <= '1' WHEN state = s9 OR state = s26 ELSE
        '0';
    write_en <= '1' WHEN state = s16 OR state = s34 ELSE
        '0';
END behavior;