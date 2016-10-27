library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity p_ctrl is
  port
    (    -- System Clock and Reset
    rst       : in  std_logic;           -- Reset
    clk       : in  std_logic;           -- Clock
    sp        : in  signed(7 downto 0);  -- Set Point
    pos       : in  signed(7 downto 0);  -- Measured position
    motor_cw  : out std_logic;           --Motor Clock Wise direction
    motor_ccw : out std_logic            --Motor Counter Clock Wise direction
  );
end p_ctrl;
--architecture <architectureName> of <Belonging entity> is

architecture p_ctrl_ARCH of p_ctrl is
  type state_type is (idle_st, sample_st, motor_st);

  signal PRESENT_STATE, NEXT_STATE  : state_type;
  signal pos_itr                    : signed(7 downto 0);
  signal sp_itr                     : signed(7 downto 0);
  signal err                        : signed(7 downto 0);

begin

  flops : process(pos, sp, clk) is
    if(rising_edge(clk)) then
      pos_itr <= pos;
      sp_itr <= sp;
    end if;
  end process;

  state_reg : process (clk, rst) is
  begin
    if rst = '1' then
      PRESENT_STATE <= idle_st;
    elsif(rising_edge(clk)) then
      PRESENT_STATE <= NEXT_STATE;
    end if;
  end process;

  sate_set : process(PRESENT_STATE) is
    case PRESENT_STATE is
      when idle_st =>
        motor_cw <= '0';
        motor_ccw <= '0';
        NEXT_STATE <= sample_st;
      when sample_st =>
        err <= (sp-pos);
        NEXT_STATE <= motor_st;
      when motor_st =>
        if(err > 0) then
          motor_cw <= '1';
          motor_ccw <= '0';
          NEXT_STATE <= sample_st;
        elsif(err < 0) then
          motor_cw <= '0';
          motor_ccw <= '1';
          NEXT_STATE <= sample_st;
        else
          motor_cw <= '0';
          motor_ccw <= '0';
          NEXT_STATE <= sample_st;
        end if;
  end process;
end p_ctrl_ARCH;
