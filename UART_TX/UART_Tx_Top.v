module UART_Tx_Top (
input wire         CLK,
input wire         RST,
input wire         PAR_EN,
input wire         PAR_TYP,
input wire         DATA_VALID,
input wire [7:0]   P_DATA,
output wire         TX_OUT,
output wire        BUSY
);

//internal signals
wire                Done;
wire                S_data;
wire                Par_bit;
wire                Ser_en;

//////////////////////////////// instantiation ////////////////////////////////////////
serializer SER (
.clk(CLK),
.ser_en(Ser_en),
.data_valid(DATA_VALID),
.p_data(P_DATA),
.s_data(S_data),
.ser_done(Done)
);

parity_clc PAR (
.clk(CLK),
.par_typ(PAR_TYP),
.p_data(P_DATA),
.parity_bit(Par_bit),
.data_valid(DATA_VALID)
);

FSM U0_FSM(
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.DATA_VALID(DATA_VALID),
.Done(Done),
.S_data(S_data),
.Par_bit(Par_bit),

.Ser_en(Ser_en),
.TX_OUT(TX_OUT),
.BUSY(BUSY)
);
endmodule