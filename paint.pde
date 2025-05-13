import g4p_controls.*;
Canvas canvas;

void setup() {
  size(600, 600);
  canvas = new Canvas(600, 600);
  createGUI();
}

void draw() {
  canvas.setStrokeSize(penSizeSlider.getValueI());
  canvas.draw();
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    canvas.clear();
  }
}
