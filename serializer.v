module serializer #(parameter DATA_WIDTH = 8)(
    input   wire                        SER_CLK,
    input   wire                        SER_RST,
    input   wire    [DATA_WIDTH-1:0]    P_DATA,
    input   wire                        ser_en,
    output  wire                        ser_done,
    output  reg                         ser_data
);

reg     [DATA_WIDTH-1:0]    P_DATA_reg;
reg     [4:0]               counter;


assign ser_done = (counter == DATA_WIDTH)? 1'b1 : 1'b0; 


always @(posedge SER_CLK or negedge SER_RST)
begin
    if(!SER_RST)
        begin
            P_DATA_reg <= 'b0;
        end
    else
        begin
            //enter the data to P_DATA_reg while the ser_en deactivated and when ser_en activated save the last value of P_Data
            if(!ser_en) 
                P_DATA_reg <= P_DATA;
            //if ser_en activited and serializer doesn't seralize all the data
            else if(ser_en && !ser_done) 
                P_DATA_reg <= P_DATA_reg >> 1;
        end
end 


always @(posedge SER_CLK or negedge SER_RST)
begin
    if(!SER_RST)
        begin   
            ser_data    <= 'b0;
            counter     <= 'b0;
        end
    else if(ser_en && !ser_done)
        begin
            counter <= counter + 1;
            ser_data <= P_DATA_reg[0]; 
        end
    else if(counter == DATA_WIDTH)
        begin
            counter <= 'b0;
        end
end



endmodule