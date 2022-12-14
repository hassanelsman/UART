module FSM (
input wire              clk ,
input wire              rst,
input wire              par_en, // it differ to the block and it will handle type
input wire              rx_in,
input wire  [3:0]       bit_cnt ,
input wire  [2:0]       edge_cnt,
input wire              par_err,
input wire              strt_glitch,
input wire              stp_err,

output reg              par_chk_en,
output reg              strt_chk_en,
output reg              stp_chk_en,
output reg              data_valid,
output reg              deser_en,
output reg              enable,
output reg              dat_samp_en
);

//internal signals
reg      [2:0]          current_state,
                        next_state ;
wire                    last_cycle ;


localparam  [2:0]   IDLE = 3'b000 ,
                    STRT = 3'b001 ,
                    DATA  = 3'b010 ,
                    PRTY  = 3'b011 ,
                    STOP  = 3'b100 ,
                    VALD  = 3'b101 ;        

// RTL

//state transition
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        current_state <= IDLE ;
    end else begin
        current_state <= next_state ;
    end
end

// next state logic
always @(*) begin
case (current_state)
    IDLE   :begin
        dat_samp_en = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
        if (!rx_in ) begin
            next_state  = STRT ;
            enable      = 1 ;
            strt_chk_en = 1 ;
            dat_samp_en = 1 ;
        end else begin
            next_state  = IDLE ;
            enable      = 0 ;
            strt_chk_en = 0 ;
            dat_samp_en = 0 ;
        end
    end 
    STRT   :begin
        dat_samp_en = 1 ;
        enable      = 1 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;

        if (strt_glitch) begin
            next_state = IDLE ;
            strt_chk_en = 0 ;
            deser_en    = 0 ;
        end else if (last_cycle) begin
            next_state = DATA ;
            strt_chk_en = 0 ;
            deser_en    = 1 ;
        end else begin
            next_state = STRT ;
            strt_chk_en = 1 ;
            deser_en    = 0 ;
        end 
    end 
    DATA   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 1 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
        if ( bit_cnt [3] && last_cycle && par_en) begin//when it's just be 8( 1 000 )leave
            next_state = PRTY ;
        end else if (bit_cnt [3] && last_cycle && !par_en) begin
            next_state = STOP ;
        end else begin
            next_state = DATA ;
        end 
    end 
    PRTY   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 0 ;
        par_chk_en  = 1 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
        if (par_err) begin
            next_state = IDLE ;
        end else if (last_cycle) begin
            next_state = STOP ;
        end else begin
            next_state = PRTY ;
        end 
    end 
    STOP   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 1 ;
        data_valid  = 0 ;
        if (stp_err) begin
            next_state = IDLE ;
        end else if (last_cycle) begin
            next_state = VALD ;
        end else begin
            next_state = STOP ;
        end 
    end
    VALD   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 1 ; 
        next_state = IDLE ;
    end 
    default: begin
        strt_chk_en = 0 ;
        dat_samp_en = 0 ;
        enable      = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ; 
        next_state = IDLE ;
    end
endcase
end

assign last_cycle = (& edge_cnt) ; //instead of make it the mux of each state 

endmodule



/* module FSM (
input wire              clk ,
input wire              rst,
input wire              par_en, // it differ to the block and it will handle type
input wire              rx_in,
input wire  [3:0]       bit_cnt ,
input wire  [2:0]       edge_cnt,
input wire              par_err,
input wire              strt_glitch,
input wire              stp_err,

output reg              par_chk_en,
output reg              strt_chk_en,
output reg              stp_chk_en,
output reg              data_valid,
output reg              deser_en,
output reg              enable,
output reg              dat_samp_en
);

//internal signals
reg      [2:0]          current_state,
                        next_state ;
wire                    last_cycle ;


localparam  [2:0]   IDLE = 3'b000 ,
                    STRT = 3'b001 ,
                    DATA  = 3'b010 ,
                    PRTY  = 3'b011 ,
                    STOP  = 3'b100 ,
                    VALD  = 3'b101 ;        

// RTL

//state transition
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        current_state <= IDLE ;
    end else begin
        current_state <= next_state ;
    end
end

// next state logic
always @(*) begin
case (current_state)
    IDLE   :begin
        if (!rx_in ) begin
            next_state = STRT ;
        end else begin
            next_state = IDLE ;
        end
    end 
    STRT   :begin
        if (strt_glitch) begin
            next_state = IDLE ;
        end else if (last_cycle) begin
            next_state = DATA ;
        end else begin
            next_state = STRT ;
        end 
    end 
    DATA   :begin
        if ( bit_cnt [3] && last_cycle && par_en) begin//when it's just be 8( 1 000 )leave
            next_state = PRTY ;
        end else if (bit_cnt [3] && last_cycle && !par_en) begin
            next_state = STOP ;
        end else begin
            next_state = DATA ;
        end 
    end 
    PRTY   :begin
        if (par_err) begin
            next_state = IDLE ;
        end else if (last_cycle) begin
            next_state = STOP ;
        end else begin
            next_state = PRTY ;
        end 
    end 
    STOP   :begin
        if (stp_err) begin
            next_state = IDLE ;
        end else if (last_cycle) begin
            next_state = VALD ;
        end else begin
            next_state = STOP ;
        end 
    end
    VALD   :begin
        next_state = IDLE ;
    end 
    default:  next_state = IDLE ;
endcase
end

// output control in each state ////// moore as output 
always @(*) begin
case (current_state)
    IDLE   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 0 ;
        enable      = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
    end 
    STRT   :begin
        strt_chk_en = 1 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
    end 
    DATA   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 1 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ;
    end 
    PRTY   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 0 ;
        par_chk_en  = 1 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ; 
    end 
    STOP   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 1 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 1 ;
        data_valid  = 0 ; 
    end 
    VALD   :begin
        strt_chk_en = 0 ;
        dat_samp_en = 1 ;
        enable      = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 1 ; 
    end 
    default:begin
        strt_chk_en = 0 ;
        dat_samp_en = 0 ;
        enable      = 0 ;
        deser_en    = 0 ;
        par_chk_en  = 0 ;
        stp_chk_en  = 0 ;
        data_valid  = 0 ; 
    end
endcase
end

assign last_cycle = (& edge_cnt) ; //instead of make it the mux of each state 

endmodule
*/