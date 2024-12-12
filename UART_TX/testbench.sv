`timescale 1ns/1ps


module test;
  // Подключение
  logic clk;
  logic clk_baud;
  logic rst;
  logic tx;
  logic [7:0] data;
  logic valid;
  wire wait_signal;

  parameter BOADRATE_PARAM = 115200;
  uart_tx_writer #
  (.boadrate(BOADRATE_PARAM)) 
  mrx1 
  (.clk(clk), .rst(rst), .tx(tx), .data(data), .valid(valid), .wait_signal(wait_signal));

  initial begin
    $dumpfile("UART_TX.vcd");
    $dumpvars;
  end

  // Генерация clk
  parameter CLK_PERIOD = 20; // 50 МГц
  initial begin
    clk <= 0;
    forever begin
      #(CLK_PERIOD / 2); clk <= ~clk;
    end
  end

  //Генерация rst
  initial begin
    rst <= 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    rst <= 0;
  end

  initial begin
    clk_baud <= 0;
    wait(rst);
    forever begin
      #(1000_000_000 / BOADRATE_PARAM); clk_baud <= ~clk_baud;
    end
  end

  // Генерация входных сигналов
  initial begin
    valid <= 'b0;
    wait(rst);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk);

    data <= 'b0101_0101;
    valid <= 'b1;
    @(posedge clk);
    //valid <= 'b0;

    @(negedge wait_signal);
    data <= 'b0;
    valid <= 'b1;
    @(posedge clk);
    //valid <= 'b0;
    data <= 'd23;

    @(negedge wait_signal);
    data <= 'b11;
    valid <= 'b1;
    @(posedge clk);
    //valid <= 'b0;
    data <= 'd23;

    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);

    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    @(posedge clk_baud);
    $finish;
  end
endmodule