library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_meas is
  port (
    -- System Clock and Reset
    rst      : in  std_logic;           -- Reset
    clk      : in  std_logic;           -- Clock
    sync_rst : in  std_logic;           -- Sync rst
    a        : in  std_logic;           -- From position sensor
    b        : in  std_logic;           -- From position sensor
    pos      : out signed(7 downto 0)   -- Measured position
    );
end pos_meas;
--architecture <architectureName> of <Belonging entity> is

architecture pos_meas_ARCH of pos_meas is
  --Area for declarations internal to the architecture
  --for example internal signals
  type state_type is (start_up_st, wait_a1_st, wait_a0_st, up_down_st, count_up_st, count_down_st);
  signal PRESENT_STATE, NEXT_STATE : state_type;
  signal a_int : std_logic;
  signal b_int : std_logic;
  -- signal count_up_en : std_logic;
  -- signal count_down_en : std_logic;
  signal pos_itr : signed(7 downto 0);
begin
  --Here starts the description
  state_reg : process (clk, rst) is
  begin
    if rst = '1' then
      PRESENT_STATE <= start_up_st;
    elsif(rising_edge(clk)) then
      if(sync_rst = '1') then
        PRESENT_STATE <= start_up_st;
      else
        PRESENT_STATE <= NEXT_STATE;
      end if;
    end if;
  end process;

  ab_flopping : process(a, b, clk)
  begin
    if(rising_edge(clk)) then
      a_int <= a;
      b_int <= b;
    end if;
  end process;

  state_set : process(a_int, b_int, PRESENT_STATE)
  begin
    case PRESENT_STATE is
      when start_up_st =>
        if(a_int = '0') then
          NEXT_STATE <= wait_a1_st;
        elsif(a_int = '1') then
          NEXT_STATE <= wait_a0_st;
        end if;
      when wait_a1_st =>
        if(a_int = '0') then
          NEXT_STATE <= wait_a1_st;
        elsif(a_int = '1') then
          NEXT_STATE <= wait_a0_st;
        end if;
      when wait_a0_st =>
        if(a_int = '0') then
          NEXT_STATE <= up_down_st;
        elsif(a_int = '1') then
          NEXT_STATE <= wait_a0_st;
        end if;
      when up_down_st =>
        if(b_int = '0') then
          NEXT_STATE <= count_up_st;
        elsif(b_int = '1') then
          NEXT_STATE <= count_down_st;
        end if;
      when count_up_st =>
        NEXT_STATE <= wait_a1_st;
      when count_down_st =>
        NEXT_STATE <= wait_a1_st;
    end case;
  end process;

  count : process(clk, rst) is
    variable count_up_en : std_logic := '0';
    variable count_down_en :std_logic := '0';
  begin
    count_up_en := '0';
    count_down_en := '0';
    if rst = '1' then
      pos_itr <= (others => '0');
    elsif(rising_edge(clk)) then
      if(PRESENT_STATE = count_up_st) then
        count_up_en := '1';
      elsif(PRESENT_STATE = count_down_st) then
        count_down_en := '1';
      end if;
    end if;

    if(count_up_en = '1') then
      if(pos_itr(6 downto 0) = "1111111") then
        pos_itr(6 downto 0) <= (others => '0');
      else
        pos_itr <= pos_itr + 1;
      end if;
    elsif(count_down_en = '1') then
      if(pos_itr(6 downto 0)) = "0000000" then
        pos_itr(6 downto 0) <= (others => '1');
      else
        pos_itr <= pos_itr - 1;
      end if;
    end if;
  end process;

  pos <= pos_itr;
end pos_meas_ARCH;
