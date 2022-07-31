module data_sampling (
input wire              clk      ,
input wire              rx_in    ,
input wire   [2:0]      edge_cnt ,
//input wire            bit_cnt,  
output reg              sampled_bit
);

//internal 
reg          [2:0]      temp;

//RTL
always @(posedge clk ) begin
    if (edge_cnt == 3'b011 /*| edge_cnt == 3'b100 | edge_cnt == 3'b101*/)
    begin
       temp[0] <= rx_in ;
    end

    if (edge_cnt == 3'b100 )
    begin
       temp[1] <= rx_in ;
    end

    if (edge_cnt == 3'b101 )
    begin
       temp[2] <= rx_in ;
    end

sampled_bit <= (temp[0] && temp[1]) || (temp[1] && temp[2]) || (temp[0] && temp[2]) ;


end

endmodule


/*(edge_cnt==3'b011)|(edge_cnt==3'b100)|(edge_cnt==3'b101))&(rx_in==1'b0)
&!((count==3'b011)|(count==3'b100)|(count==3'b101))&(rx_in==1'b1)
*/
//edge_cnt[0] && edge_cnt[1] && !edge_cnt[2]
