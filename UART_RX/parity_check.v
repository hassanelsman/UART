// combinantiol clock
//is there a long path delay will violate in the STA so i should break pathes
//and register inputs ???? i think it is according to needed Frequency
module parity_check (
input wire              par_typ,
input wire              par_chk_en,
input wire              sampled_bit,
input wire              smpl_ready,
input wire   [7:0]      p_data,
output wire             par_err
);
//internal signals
reg                     par_err_sig ;
// RTL
always @(*) begin
    if (par_chk_en && smpl_ready) begin
        par_err_sig = sampled_bit ^ (^p_data) ;
    end else begin
        par_err_sig = 1'b0 ;
    end
end

assign par_err = (par_typ) ? !par_err_sig : par_err_sig ;

endmodule

/*
always @(*) begin
    if (par_chk_en && bit_cnt == 4'd9 && &edge_cnt ) begin
       
       par_err = clc_par ;
       /*if ( !clc_par ) begin
            par_err = 1'b0 ;
        end else begin
            par_err = 1;b1 ;
        end ///
    end else begin
        par_err = 1'b0 ;
    end
end
    
always @(posedge clk or par_chk_en) begin
    if (!par_chk_en ) begin
        clc_par <= 1'b0 ;
    end 
    else if (par_chk_en && bit_cnt == 4'd01 && smpl_ready ) begin
        clc_par <= sampled_bit ;
    end
    else if (par_chk_en && smpl_ready) begin
        clc_par <= sampled_bit ^ clc_par ;
    end 
end
*/