import g4p_controls.*;
Canvas canvas;

void setup() {
  size(600, 600);
  canvas = new Canvas(600, 600);
  createGUI();
  surface.setTitle("Paint");
}

void draw() {
  if (canvas != null && penSizeSlider != null) {
    canvas.setStrokeSize(penSizeSlider.getValueI());
    canvas.draw();
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    canvas.clear();
  }
}
