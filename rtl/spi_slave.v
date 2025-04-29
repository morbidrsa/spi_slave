module spi_slave (
  input wire clk,
  input wire rst_n,
  input wire sclk,
  input wire mosi,
  output reg miso,
  input wire ss_n,
  output reg [7:0] data_out,
  input wire [7:0] data_in
);

  reg [7:0] shift_reg_in;
  reg [7:0] shift_reg_out;
  reg [2:0] bit_cnt;

  // Load output register and prepare MISO when ss_n goes low
  always @(negedge ss_n or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg_out <= 8'd0;
      miso <= 1'b0;
      bit_cnt <= 3'd7;
    end else begin
      shift_reg_out <= data_in;
      miso <= data_in[7]; // Prepare MISO immediately
      bit_cnt <= 3'd6;
    end
  end

  // Shift in data on the rising edge of SCLK
  always @(posedge sclk or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg_in <= 8'd0;
    end else if (!ss_n) begin
      shift_reg_in <= {shift_reg_in[6:0], mosi};
      if (bit_cnt == 0)
        data_out <= {shift_reg_in[6:0], mosi}; // Capture the received byte
    end
  end

  // Shift out data on the falling edge of SCLK
  always @(negedge sclk or negedge rst_n) begin
    if (!rst_n) begin
      miso <= 1'b0;
    end else if (!ss_n) begin
      miso <= shift_reg_out[bit_cnt];
      if (bit_cnt > 0)
        bit_cnt <= bit_cnt - 1;
    end
  end

endmodule
