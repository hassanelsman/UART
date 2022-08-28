module UART_Rx_Top (
input wire              CLK,
input wire              RST,
input wire              PAR_TYP,
input wire              PAR_EN ,
input wire    [4:0]     Prescale,
input wire              RX_IN,

output wire   [7:0]     P_DATA,
output wire             Data_valid
);

//internal signals
wire                    SAMPLED_BIT;
wire                    SMPL_READY;

wire                    DESER_EN;
wire                    DAT_SAMP_EN;

wire                    STRT_CHK_EN ;
wire                    STRT_GLITCH;

wire                    STP_CHK_EN;
wire                    STP_ERR ;

wire                    PAR_ERR;
wire                    PAR_CHK_EN;


wire                    ENABLE;
wire       [3:0]        BIT_CNT;
wire       [2:0]        EDGE_CNT;



//instantiations
FSM U0_FSM (
.clk(CLK) ,
.rst(RST),
.par_en(PAR_EN), // it differ to the block and it will handle type
.rx_in(RX_IN),
.bit_cnt(BIT_CNT) ,
.edge_cnt(EDGE_CNT),
.par_err(PAR_ERR),
.strt_glitch(STRT_GLITCH),
.stp_err(STP_ERR),

.par_chk_en(PAR_CHK_EN),
.strt_chk_en(STRT_CHK_EN),
.stp_chk_en(STP_CHK_EN),
.data_valid(Data_valid),
.deser_en(DESER_EN),
.enable(ENABLE),
.dat_samp_en(DAT_SAMP_EN)
);


edge_bit_counter U0_edge_bit_counter  (
.clk(CLK),
.enable(ENABLE) ,
.bit_cnt(BIT_CNT), // to count up to 11 
.edge_cnt(EDGE_CNT) 
);


data_sampling U0_data_sampling (
.clk(CLK),
.rx_in(RX_IN),
.dat_samp_en(DAT_SAMP_EN),
.edge_cnt(EDGE_CNT) ,
.smpl_ready(SMPL_READY),
.sampled_bit(SAMPLED_BIT)
);

deserializer U0_deserializer (
.clk(CLK),
.rst(RST),
.sampled_bit(SAMPLED_BIT),
.smpl_ready(SMPL_READY),
.deser_en(DESER_EN),
.bit_cnt(BIT_CNT),
.p_data(P_DATA)
);

strt_check U0_strt_check (
.sampled_bit(SAMPLED_BIT),
.smpl_ready(SMPL_READY),
.strt_chk_en(STRT_CHK_EN),
.strt_glitch(STRT_GLITCH)
);

parity_check U0_parity_check (
.par_typ(PAR_TYP),
.par_chk_en(PAR_CHK_EN),
.sampled_bit(SAMPLED_BIT),
.smpl_ready(SMPL_READY),
.p_data(P_DATA),
.par_err(PAR_ERR)
);

stop_check  U0_stop_check(
.sampled_bit(SAMPLED_BIT),
.smpl_ready(SMPL_READY),
.stp_chk_en(STP_CHK_EN),
.stp_err(STP_ERR)
);
endmodule