import g4p_controls.*;
public static color paintColour;
int strokeSize = 3;
PGraphics canvas;

void setup() {
  size(600, 600);
  canvas = createGraphics(600, 600);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  paintColour = color(0);
  createGUI();
  strokeWeight(strokeSize);
}

void draw() {
  strokeSize = penSizeSlider.getValueI();
  
  canvas.beginDraw();
  if (mousePressed && mouseY > 0) {
    if (isEraserActive) {
      canvas.noStroke();
      canvas.fill(255);
      canvas.ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
    } else {
      canvas.stroke(penColor);
      canvas.strokeWeight(strokeSize);
      canvas.line(pmouseX, pmouseY, mouseX, mouseY);
    }
  }
  canvas.endDraw();
  
  image(canvas, 0, 0);
  
  if (isEraserActive) {
    pushStyle();
    stroke(100);
    strokeWeight(1);
    noFill();
    ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
    popStyle();
  } else {
    pushStyle();
    stroke(0);
    strokeWeight(1);
    fill(penColor);
    ellipse(mouseX, mouseY, strokeSize, strokeSize);
    popStyle();
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }
}
