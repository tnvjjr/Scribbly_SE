GWindow controlsWindow;
color[] paletteColors;
GSlider redSlider, greenSlider, blueSlider, penSizeSlider;
GButton setColorButton;
GButton eraserButton;
GSlider eraserSizeSlider;
color penColor;
int eraserStrokeSize = 20;
boolean isEraserActive = false;

public void createGUI() {
  controlsWindow = GWindow.getWindow(this, "Paint Controls", 0, 0, 360, 380, JAVA2D);
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "drawControlsWindow");

  paletteColors = new color[] {
    #000000, #222034, #323c39, #3f3f74, #306082, #5b6ee1, #639bff, #5fcde4,
    #4b692f, #37946e, #6abe30, #99e550, #8f974a,
    #595652, #696a6a, #847e87, #9badb7, #cbdbfc,
    #663931, #45283c, #8f563b, #df7126, #d9a066, #eec39a,
    #fbf236, #d95763, #d77bba, #76428a, #ac3232, #8a6f30,
    #ffffff
  };

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

  penColor = color(128, 128, 128);
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
    if (index >= 0 && index < paletteColors.length) {
      penColor = paletteColors[index];
    }
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

  if (isEraserActive) {
    eraserStrokeSize = eraserSizeSlider.getValueI();
    appc.noStroke();
    appc.fill(230);
    if (appc.mousePressed) {
      appc.ellipse(appc.mouseX, appc.mouseY, eraserStrokeSize, eraserStrokeSize);
    }
  }
}

public void handleSetPenColor(GButton button, GEvent event) {
  if (button == setColorButton) {
    penColor = color(redSlider.getValueI(), greenSlider.getValueI(), blueSlider.getValueI());
    isEraserActive = false;
  }
}

public void handleEraser(GButton button, GEvent event) {
  if (button == eraserButton) {
    isEraserActive = true;
    penColor = color(255, 255, 255);
  }
}

public int getEraserSize() {
  return eraserSizeSlider.getValueI();
}
