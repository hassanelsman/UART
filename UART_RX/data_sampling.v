module data_sampling (
input wire              clk      ,
input wire              rx_in    ,
input wire              dat_samp_en,
input wire   [2:0]      edge_cnt ,
output wire             smpl_ready ,
output reg              sampled_bit
);
//internal 
reg          [2:0]      temp;

//RTL
always @(posedge clk ) begin 
    if (!dat_samp_en) begin
      temp <= 3'b0 ;
    end else begin   
//    temp <= temp ; //ckeck if it work correctly     not important as it is seq.
   case (edge_cnt)
      3'b011 : temp[0] <= rx_in ;
      3'b100 : temp[1] <= rx_in ;
      3'b101 : temp[2] <= rx_in ;
      default: temp <= temp ;
   endcase
end
sampled_bit <= (temp[0] && temp[1]) || (temp[1] && temp[2]) || (temp[0] && temp[2]) ;
end

assign smpl_ready = (edge_cnt[2] && edge_cnt[1] && !edge_cnt[0] && dat_samp_en) ; //flag at edge_cnt = 6

endmodule


/*(edge_cnt==3'b011)|(edge_cnt==3'b100)|(edge_cnt==3'b101))&(rx_in==1'b0)
&!((count==3'b011)|(count==3'b100)|(count==3'b101))&(rx_in==1'b1)
*/
//edge_cnt[0] && edge_cnt[1] && !edge_cnt[2]


/*
    if (edge_cnt == 3'b011  )
    begin
       temp[0] <= rx_in ;
    end

    if (edge_cnt == 3'b100 )           //////////////////////////////////////////////
    begin                              // it prefered to replaced by case statment //
       temp[1] <= rx_in ;              //////////////////////////////////////////////
    end

    if (edge_cnt == 3'b101 )
    begin
       temp[2] <= rx_in ;
    end
*/