module FSM (
    input   wire            FSM_CLK,
    input   wire            FSM_RST,
    input   wire            Data_Valid,
    input   wire            PAR_EN,
    input   wire            ser_done,
    output  reg             ser_en,
    output  reg     [1:0]   mux_sel,
    output  reg             busy
);

// States Defination 
localparam IDLE     =   'b000;
localparam START    =   'b001;
localparam DATA     =   'b010;
localparam PARITY   =   'b011;
localparam STOP     =   'b100;
localparam State_size = 3;

// States Variables
reg [State_size-1:0] Current_State, Next_State;

// Current state logic
always @(posedge FSM_CLK or negedge FSM_RST)
begin
    if(!FSM_RST)
        begin
            Current_State <= IDLE;
        end
    else
        begin
            Current_State <= Next_State ;
        end
end

//  Next state logic
always @(*)
begin
    case (Current_State)
        IDLE: 
            begin
                if(Data_Valid)
                    begin 
                        Next_State = START;
                    end
                else
                    begin   
                        Next_State = Current_State;
                    end
            end 
        START:
            begin
                Next_State = DATA;
            end
        DATA:
            begin
                if(ser_done)
                    begin
                        if(PAR_EN)
                            Next_State = PARITY;
                        else
                            Next_State = STOP;
                    end
                else
                    begin
                        Next_State = DATA;
                    end
            end
        PARITY:
            begin
                Next_State = STOP;
            end
        STOP:
            begin
                if(Data_Valid)
                    Next_State = START;
                else
                    Next_State = IDLE;
            end
        default:
            begin
                Next_State = IDLE;
            end
    endcase
end



// Output logic
always @(*)
begin
    case(Current_State)
    IDLE    : begin
                ser_en = 1'b0;
                mux_sel = 2'b01;
                busy = 1'b0;
                end
    START   : begin
                ser_en = 1'b1;
                mux_sel = 2'b00;
                busy = 1'b1;
                end	
    DATA    : begin
                ser_en = 1'b1;
                mux_sel = 2'b10;
                busy = 1'b1;
                end
    PARITY  : begin
                ser_en = 1'b0;
                mux_sel = 2'b11;
                busy = 1'b1;
                end
    STOP    : begin
                ser_en = 1'b0;
                mux_sel = 2'b01;
                busy = 1'b1;
                end
    default : begin
                ser_en = 1'b0;
                mux_sel = 2'b00;
                busy = 1'b0;
                end			  
    endcase
end	



endmodule