GWindow controlsWindow;
GSlider redSlider, greenSlider, blueSlider, penSizeSlider;
GButton setColorButton;
GButton eraserButton;
GButton saveButton;
GSlider eraserSizeSlider;

public void createGUI() {
  controlsWindow = GWindow.getWindow(this, "Paint Controls", 0, 0, 360, 400, JAVA2D);
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "drawControlsWindow");

  GLabel penSizeLabel = new GLabel(controlsWindow, 10, 215, 100, 20);
  penSizeLabel.setText("Pen Size:");
  penSizeLabel.setOpaque(false);

  penSizeSlider = new GSlider(controlsWindow, 110, 215, 100, 20, 10);
  penSizeSlider.setLimits(3, 1, 50);
  penSizeSlider.setShowValue(true);
  penSizeSlider.setNumberFormat(G4P.INTEGER, 0);
  penSizeSlider.setShowTicks(true);
  penSizeSlider.setNbrTicks(5);
  penSizeSlider.setEasing(6.5);
  penSizeSlider.setOpaque(true);
  penSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);

  GLabel redLabel = new GLabel(controlsWindow, 10, 240, 20, 20);
  redLabel.setText("R:");
  redLabel.setOpaque(false);

  GLabel greenLabel = new GLabel(controlsWindow, 10, 265, 20, 20);
  greenLabel.setText("G:");
  greenLabel.setOpaque(false);

  GLabel blueLabel = new GLabel(controlsWindow, 10, 290, 20, 20);
  blueLabel.setText("B:");
  blueLabel.setOpaque(false);

  redSlider = new GSlider(controlsWindow, 30, 240, 180, 20, 10);
  redSlider.setLimits(128, 0, 255);
  redSlider.setShowValue(true);
  redSlider.setNumberFormat(G4P.INTEGER, 0);
  redSlider.setShowTicks(true);
  redSlider.setNbrTicks(5);
  redSlider.setEasing(6.5);
  redSlider.setOpaque(true);
  redSlider.setTextOrientation(G4P.ORIENT_LEFT);

  greenSlider = new GSlider(controlsWindow, 30, 265, 180, 20, 10);
  greenSlider.setLimits(128, 0, 255);
  greenSlider.setShowValue(true);
  greenSlider.setNumberFormat(G4P.INTEGER, 0);
  greenSlider.setShowTicks(true);
  greenSlider.setNbrTicks(5);
  greenSlider.setEasing(6.5);
  greenSlider.setOpaque(true);
  greenSlider.setTextOrientation(G4P.ORIENT_LEFT);

  blueSlider = new GSlider(controlsWindow, 30, 290, 180, 20, 10);
  blueSlider.setLimits(128, 0, 255);
  blueSlider.setShowValue(true);
  blueSlider.setNumberFormat(G4P.INTEGER, 0);
  blueSlider.setShowTicks(true);
  blueSlider.setNbrTicks(5);
  blueSlider.setEasing(6.5);
  blueSlider.setOpaque(true);
  blueSlider.setTextOrientation(G4P.ORIENT_LEFT);

  setColorButton = new GButton(controlsWindow, 220, 275, 120, 30);
  setColorButton.setText("Set Pen Color");
  setColorButton.addEventHandler(this, "handleSetPenColor");

  GLabel eraserSizeLabel = new GLabel(controlsWindow, 10, 320, 100, 20);
  eraserSizeLabel.setText("Eraser Size:");
  eraserSizeLabel.setOpaque(false);

  eraserSizeSlider = new GSlider(controlsWindow, 110, 320, 100, 20, 10);
  eraserSizeSlider.setLimits(20, 1, 100);
  eraserSizeSlider.setShowValue(true);
  eraserSizeSlider.setNumberFormat(G4P.INTEGER, 0);
  eraserSizeSlider.setShowTicks(true);
  eraserSizeSlider.setNbrTicks(5);
  eraserSizeSlider.setEasing(6.5);
  eraserSizeSlider.setOpaque(true);
  eraserSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);

  eraserButton = new GButton(controlsWindow, 220, 320, 120, 30);
  eraserButton.setText("Eraser");
  eraserButton.addEventHandler(this, "handleEraser");
  
  // Add Save Canvas button
  saveButton = new GButton(controlsWindow, 220, 360, 120, 30);
  saveButton.setText("Save Canvas");
  saveButton.addEventHandler(this, "handleSaveCanvas");
}

synchronized public void drawControlsWindow(PApplet appc, GWinData data) {
  appc.background(230);
  appc.noStroke();

  int cols = 8;
  int buttonSize = 25;
  int padding = 5;
  int startX = 10;
  int startY = 10;

  int buttonX = startX;
  int buttonY = startY;
  
  color[] paletteColors = canvas.getColors().getPaletteColors();

  for (int i = 0; i < paletteColors.length; i++) {
    appc.fill(paletteColors[i]);
    appc.rect(buttonX, buttonY, buttonSize, buttonSize);
    buttonX += buttonSize + padding;
    if ((i + 1) % cols == 0) {
      buttonX = startX;
      buttonY += buttonSize + padding;
    }
  }

  if (appc.mousePressed &&
      appc.mouseX > startX && appc.mouseX < (startX + cols * (buttonSize + padding)) &&
      appc.mouseY > startY && appc.mouseY < (startY + (paletteColors.length / cols + 1) * (buttonSize + padding))) {
    int x = (appc.mouseX - startX) / (buttonSize + padding);
    int y = (appc.mouseY - startY) / (buttonSize + padding);
    int index = y * cols + x;
    canvas.getColors().setPenColorFromPalette(index);
  }

  int r = redSlider.getValueI();
  int g = greenSlider.getValueI();
  int b = blueSlider.getValueI();
  color previewColor = color(r, g, b);

  appc.stroke(0);
  appc.strokeWeight(1);
  appc.fill(previewColor);
  appc.rect(220, 240, 120, 30);
  appc.fill(0);
  appc.text("Preview", 255, 235);

  canvas.setEraserSize(eraserSizeSlider.getValueI());
}

public void handleSetPenColor(GButton button, GEvent event) {
  if (button == setColorButton && event == GEvent.CLICKED) {
    canvas.getColors().setPenColor(
      redSlider.getValueI(),
      greenSlider.getValueI(),
      blueSlider.getValueI()
    );
    canvas.setEraserActive(false);
  }
}

public void handleEraser(GButton button, GEvent event) {
  if (button == eraserButton && event == GEvent.CLICKED) {
    canvas.setEraserActive(true);
  }
}

public void handleSaveCanvas(GButton button, GEvent event) {
  if (button == saveButton && event == GEvent.CLICKED) {
    canvas.save(null);
  }
}
