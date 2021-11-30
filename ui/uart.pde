void uart_write(byte b) {
  print(b);
  if (serial != null) serial.write(b);
}
