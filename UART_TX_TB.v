//  Define Time Scale
`timescale 1ns/1ps


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////     UART_TX Test_Bench     ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
module UART_TX_TB();

// parameters
parameter   CLK_PERIOD      = 5;
parameter   DATA_WIDTH_TB   = 8;
parameter   WITH_PARITY     = 1;
parameter   WITHOUT_PARITY  = 0;
parameter   EVEN_parity     = 0;
parameter   ODD_parity      = 1;
parameter   START_BIT       = 0;
parameter   STOP_BIT        = 1;

//  DUT Signals
reg     [DATA_WIDTH_TB-1:0]     P_DATA_TB;
reg                             DATA_VALID_TB;
reg                             PAR_EN_TB;
reg                             PAR_TYP_TB;
reg                             CLK_TB;
reg                             RST_TB;
wire                            TX_OUT_TB;
wire                            Busy_TB;


///////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////     Initial     ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

// Initial Block
initial 
begin

    // System Functions
        $dumpfile("UART_TX_DUMP.vcd") ;       
        $dumpvars;

    // Initialization
        initialize();
 
    // Reset
        reset();

    // Test Cases
        send_data('b0110_0101,WITH_PARITY,EVEN_parity);
        check_out_with_parity('b0_1010_0110_0_1);
        #(15*CLK_PERIOD)    
        
        send_data('b1010_0101,WITH_PARITY,ODD_parity);
        check_out_with_parity('b0_1010_0101_1_1);
        #(15*CLK_PERIOD)    
        
        send_data('b1010_0011,WITHOUT_PARITY,EVEN_parity);
        check_out_without_parity('b0_1100_0101_1);
        #(15*CLK_PERIOD) 
        
        // send_data('b0101_1001,WITHOUT_PARITY,EVEN_parity);
        // P_DATA_TB   = 'b0110_0101;
        // PAR_EN_TB   = WITH_PARITY;       
        // PAR_TYP_TB  = ODD_parity;
        // check_out_without_parity('b0_1001_1010_1);
        // check_out_without_parity('b0_1010_0110_1_1);
        // #(15*CLK_PERIOD) 
        
    reset();
    #(10*CLK_PERIOD)
    
    $stop;
end

///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////     Tasks     ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

// Initialization
task initialize ;
 begin
    CLK_TB  = 'b0;
    RST_TB  = 'b1;
 end
endtask

// Reset technique
task reset;
begin
    RST_TB =  'b1;
  #(CLK_PERIOD)
    RST_TB  = 'b0;
  #(CLK_PERIOD)
    RST_TB  = 'b1;

end
endtask

// Sending Data
task send_data;
input   [DATA_WIDTH_TB-1:0] P_DATA_send;
input                       PAR_EN_send;
input                       PAR_TYP_send;
begin
    P_DATA_TB       = P_DATA_send;
    PAR_EN_TB       = PAR_EN_send;       
    PAR_TYP_TB      = PAR_TYP_send;  //Even Parity

    DATA_VALID_TB   = 1'b1;
    #(CLK_PERIOD)
    DATA_VALID_TB   = 1'b0;

end
endtask


// Check the output frame with parity bit
task check_out_with_parity;
input  reg     [DATA_WIDTH_TB+2:0]              expected_output;

reg     [DATA_WIDTH_TB+2:0]             generated_output;
integer i;

begin
    generated_output = 'b0;
    if(Busy_TB)
    begin
        for(i=DATA_WIDTH_TB+2; i > -1; i=i-1)
            begin
            generated_output[i] = TX_OUT_TB ;
            #(CLK_PERIOD);
            end

        if(generated_output == expected_output) 
            $display("Test Case is succeeded");
        else
            $display("Test Case is failed");  
    end
end
endtask


// Check the output frame without parity bit
task check_out_without_parity;
input  reg     [DATA_WIDTH_TB+1:0]      expected_output;

reg     [DATA_WIDTH_TB+1:0]             generated_output;
integer i;

begin
    generated_output = 'b0;
    if(Busy_TB)
    begin
        for(i=DATA_WIDTH_TB+1; i > -1; i=i-1)
            begin
            generated_output[i] = TX_OUT_TB ;
            #(CLK_PERIOD);
            end

        if(generated_output == expected_output) 
            $display("Test Case is succeeded");
        else
            $display("Test Case is failed");  
    end
end
endtask
    



///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////     Clock     /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
// CLock generation
always #(CLK_PERIOD/2.0)  CLK_TB = ~CLK_TB ;


///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////     DUT     /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
// DUT instantiation
UART_TX #(.DATA_WIDTH(DATA_WIDTH_TB)) DUT (
    .P_DATA(P_DATA_TB),
    .DATA_VALID(DATA_VALID_TB),
    .PAR_EN(PAR_EN_TB),
    .PAR_TYP(PAR_TYP_TB),
    .CLK(CLK_TB),
    .RST(RST_TB),
    .TX_OUT(TX_OUT_TB),
    .Busy(Busy_TB)
);




endmodule