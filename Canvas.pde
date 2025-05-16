class Canvas {
  PGraphics canvas;
  int strokeSize;
  boolean isEraserActive;
  int eraserStrokeSize;
  Colors colors;
  
  Canvas(int width, int height) {
    canvas = createGraphics(width, height);
    strokeSize = 3;
    eraserStrokeSize = 20;
    isEraserActive = false;
    colors = new Colors();
    
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }
  
  void draw() {
    canvas.beginDraw();
    if (mousePressed && mouseY > 0) {
      if (isEraserActive) {
        canvas.noStroke();
        canvas.fill(255);
        canvas.ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
      } else {
        canvas.stroke(colors.getPenColor());
        canvas.strokeWeight(strokeSize);
        canvas.line(pmouseX, pmouseY, mouseX, mouseY);
      }
    }
    canvas.endDraw();
    
    image(canvas, 0, 0);
    
    if (isEraserActive) {
      drawEraserPreview();
    } else {
      drawPenPreview();
    }
  }
  
  void drawEraserPreview() {
    pushStyle();
    stroke(100);
    strokeWeight(1);
    noFill();
    ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
    popStyle();
  }
  
  void drawPenPreview() {
    pushStyle();
    stroke(0);
    strokeWeight(1);
    fill(colors.getPenColor());
    ellipse(mouseX, mouseY, strokeSize, strokeSize);
    popStyle();
  }
  
  void clear() {
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }
  
  void save(String filename) {
    File dir = new File(sketchPath("") + "/screenshots");
    if (!dir.exists()) {
      dir.mkdir();
    }
    
    String timestamp = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "_" + nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
    
    String filepath = "screenshots/" + (filename != null ? filename : "drawing_") + timestamp + ".png";
    canvas.save(filepath);
    println("Canvas saved as: " + filepath);
  }
  
  void setEraserActive(boolean active) {
    isEraserActive = active;
  }
  
  void setStrokeSize(int size) {
    strokeSize = size;
  }
  
  void setEraserSize(int size) {
    eraserStrokeSize = size;
  }
  
  Colors getColors() {
    return colors;
  }
}
