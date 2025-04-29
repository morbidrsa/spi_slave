`timescale 1ns / 1ps

module spi_slave_tb;
  reg clk;
  reg rst_n;
  reg sclk;
  reg mosi;
  wire miso;
  reg ss_n;
  wire [7:0] data_out;
  reg [7:0] data_in;
  reg [7:0] received_data;

  spi_slave uut (
    .clk(clk),
    .rst_n(rst_n),
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .ss_n(ss_n),
    .data_out(data_out),
    .data_in(data_in)
  );

  // Generate system clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // SPI Write Task
  task spi_write;
    input [7:0] data;
    integer i;
    begin
      ss_n = 0;
      #10;
      for (i = 7; i >= 0; i = i - 1) begin
        mosi = data[i];
        #5 sclk = 1;
        #5 sclk = 0;
      end
      #10 ss_n = 1;
    end
  endtask

  // SPI Read Task
  task spi_read;
    output reg [7:0] data;
    integer i;
    reg [7:0] temp;
    begin
      ss_n = 0;
      #10;
      temp = 8'd0;
      for (i = 7; i >= 0; i = i - 1) begin
        #5 sclk = 1;
        temp[i] = miso;
        #5 sclk = 0;
      end
      #10 ss_n = 1;
      data = temp;
    end
  endtask

  initial begin
    // VCD Dump
    $dumpfile("spi_slave_tb.vcd");
    $dumpvars;

    // Reset and initial setup
    rst_n = 0;
    ss_n = 1;
    sclk = 0;
    mosi = 0;
    data_in = 8'hA5;
    #20 rst_n = 1;
    #20;

    // Write Test
    spi_write(8'h3C);
    #20;
    if (data_out == 8'h3C)
      $display("[PASS] Data received correctly");
    else
      $display("[FAIL] Data mismatch: %h", data_out);

    spi_write(8'hAA);
    #20;
    if (data_out == 8'hAA)
      $display("[PASS] Data received correctly");
    else
      $display("[FAIL] Data mismatch: %h", data_out);

    spi_write(8'h55);
    #20;
    if (data_out == 8'h55)
      $display("[PASS] Data received correctly");
    else
      $display("[FAIL] Data mismatch: %h", data_out);

    // Prepare for Read Test
    data_in = 8'h5A;
    #20;

    // Read Test
    spi_read(received_data);
    if (received_data == 8'h5A)
      $display("[PASS] Data sent correctly");
    else
      $display("[FAIL] Sent data mismatch: %h", received_data);

    #20;
    $finish;
  end

endmodule
