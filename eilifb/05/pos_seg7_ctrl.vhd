library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The entity defines all the signals in and out (inout) of the circuit
entity pos_seg7_ctrl is
  port
  (
    -- System Clock and Reset
    arst         : in  std_logic;       -- Reset
    sync_rst     : in  std_logic;       -- Synchronous reset
    refclk       : in  std_logic;       -- Clock
    sp           : in  std_logic_vector(7 downto 0);  -- Set Point
    a            : in  std_logic;       -- From position sensor
    b            : in  std_logic;       -- From position sensor
    force_cw     : in  std_logic;       -- Force motor clock wise motion
    force_ccw    : in  std_logic;  -- Force motor counter clock wise motion
    motor_cw     : out std_logic;       -- Motor clock wise motion
    motor_ccw    : out std_logic;       -- Motor counter clock wise motion
    -- Interface to seven segments
    abcdefgdec_n : out std_logic_vector(7 downto 0);
    a_n          : out std_logic_vector(3 downto 0)
  );
end pos_seg7_ctrl;

architecture pos_seg7_ctrl_ARCH of pos_seg7_ctrl is
  --Area for declarations internal to the architecture
  --for example internal signals
  Component seg7ctrl is
  	port(
  		 clk 			: in std_logic; --50MHz, positive flank
  		 reset 			: in std_logic; --Asynchronous, active high
  		 d0 			: in std_logic_vector(3 downto 0);
  		 d1 			: in std_logic_vector(3 downto 0);
  		 d2 			: in std_logic_vector(3 downto 0);
  		 d3 			: in std_logic_vector(3 downto 0);
  		 dec 			: in std_logic_vector(3 downto 0);
  		 abcdefgdec_n	: out std_logic_vector(7 downto 0);
  		 a_n			: out std_logic_vector(3 downto 0)
  		);
  end component;

  Component pos_ctrl is
    port
    (    -- System Clock and Reset
      rst       : in  std_logic;          -- Reset
      rst_div   : in  std_logic;          -- Reset
      mclk      : in  std_logic;          -- Clock
      mclk_div  : in  std_logic;          -- Clock to p_reg
      sync_rst  : in  std_logic;          -- Synchronous reset
      sp        : in  std_logic_vector(7 downto 0);  -- Setpoint (wanted position)
      a         : in  std_logic;          -- From position sensor
      b         : in  std_logic;          -- From position sensor
      pos       : out std_logic_vector(7 downto 0);  -- Measured Position
      force_cw  : in  std_logic;          -- Force motor clock wise motion
      force_ccw : in  std_logic;  -- Force motor counter clock wise motion
      motor_cw  : out std_logic;          -- Motor clock wise motion
      motor_ccw : out std_logic           -- Motor counter clock wise motion
    );
  end component;

	Component CRU is
		port
		(
			arst      : in std_logic; --Asynch. reset
			refclk    : in std_logic; --Reference clk
			rst       : out std_logic; --Synch reset master clock
			rst_div   : out std_logic; --Synch reset divided clock
			mclk      : out std_logic;--Master clock
			mclk_div  : out std_logic --Master clock div. by 128		
		);
	end component;
	
	signal sp_itr			 		: std_logic_vector(7 downto 0);
	signal pos_itr				: std_logic_vector(7 downto 0);
	signal rst_itr				: std_logic;
	signal rst_div_itr		: std_logic;
	signal mclk_itr				: std_logic;
	signal mclk_div_itr		: std_logic;
	signal dec_itr				: std_logic_vector(3 downto 0);
begin
	
	CRU_instance : CRU
		port map
		(
			arst			=> arst,
			refclk		=> refclk,
			rst				=> rst_itr,
			rst_div		=> rst_div_itr,
			mclk			=> mclk_itr,
			mclk_div	=> mclk_div_itr
		);
		
	seg7ctrl_instance : seg7ctrl
		port map
		(
			clk						=> mclk_itr,
			reset					=> rst_itr,			
			d0						=> pos_itr(3 downto 0),
			d1						=> pos_itr(7 downto 4),
			d2						=> sp_itr(3 downto 0),
			d3						=> sp_itr(7 downto 4),			
			dec						=> dec_itr,
			abcdefgdec_n	=> abcdefgdec_n,
			a_n 					=> a_n
		);
	
	pos_ctrl_instance : pos_ctrl
		port map
		(
			rst				=> rst_itr,
			rst_div		=> rst_div_itr,
			mclk			=> mclk_itr,
			mclk_div	=> mclk_div_itr,
			sync_rst	=> sync_rst,
			sp				=> sp_itr,
			a					=> a,
			b					=> b,
			pos				=> pos_itr, --internal signal going to seg7ctrl.
			force_cw	=> force_cw,
			force_ccw	=> force_ccw,
			motor_cw	=> motor_cw,
			motor_ccw	=> motor_ccw
			
		);
	sp_itr <= '0' & sp(6 downto 0);
	dec_itr <= "1011";
end pos_seg7_ctrl_ARCH;
