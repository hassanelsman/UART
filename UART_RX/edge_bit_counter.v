module edge_bit_counter (
input wire               clk    ,
input wire               enable ,
output reg [3:0]         bit_cnt, // to count up to 11 
output reg  [2:0]        edge_cnt 
);

//RTL
always @(posedge clk ) begin
    if (!enable) begin
        edge_cnt <= 3'b0 ;
    end else begin
        edge_cnt <= edge_cnt + 3'b1 ;
    end
end

always @(posedge clk ) begin
    if (!enable) begin
        bit_cnt <= 4'b0 ;
    end
    else if (& edge_cnt) begin
        bit_cnt <=  bit_cnt + 4'b1 ;
    end else  begin
         bit_cnt <=  bit_cnt ;
    end
end
endmodule


/*
always @(*) begin
    if (enable && ~|edge_cnt) begin
        cnt_op_valid = 1'b1 ;
    end else begin
        cnt_op_valid = 1'b0 ;
    end
end

//if edge_cnt[0] and edge_cnt [1] 
//we can save cnt3,4,5 in same flop and update it


//rst in each block or in top only                                    ?! 
// if without anything will translate to flop with enable or 
//should i have make it else if                                       ?!
// why we take majority not neglict all                               ?!
*/