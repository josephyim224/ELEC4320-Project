// https://processing.org/examples/button.html
boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void draw_title(int x, int y, String s) {
  textSize(30);
  text(s, x, y+30);
}

/*
  button size assumed to be 100x30
*/
void draw_button(int x, int y, String s) {
  textSize(30);
  text(s, x, y+30);
  rect(x, y, 100, 30);
}

boolean is_in_button(int x, int y) {
  return (mouseX >= x && mouseX <= x+100 && 
      mouseY >= y && mouseY <= y+30);
}
