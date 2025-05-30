GWindow controlsWindow;
GSlider redSlider, greenSlider, blueSlider, penSizeSlider;
GButton setColorButton;
GButton saveButton;
GTextField filenameField;
GSlider eraserSizeSlider;
GDropList toolDropList;

// sets up the GUI control window
public void createGUI() {
  controlsWindow = GWindow.getWindow(this, "Paint Controls", 0, 0, 360, 450, JAVA2D);
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "drawControlsWindow");

  // tool selection dropdown
  toolDropList = new GDropList(controlsWindow, 10, 180, 150, 120);
  toolDropList.setItems(new String[] {"Pen", "Eraser", "Rectangle", "Circle", "Triangle"}, 0);
  toolDropList.addEventHandler(this, "handleToolSelect");

  // pen size slider
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

  // rgb sliders
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

  // color apply button
  setColorButton = new GButton(controlsWindow, 220, 275, 120, 30);
  setColorButton.setText("Set Color");
  setColorButton.addEventHandler(this, "handleSetPenColor");

  // eraser size slider
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

  // filename text field
  GLabel filenameLabel = new GLabel(controlsWindow, 10, 360, 100, 20);
  filenameLabel.setText("Filename:");
  filenameLabel.setOpaque(false);
  
  filenameField = new GTextField(controlsWindow, 10, 380, 340, 25);
  filenameField.setPromptText("Enter filename (without .png)");

  // save button
  saveButton = new GButton(controlsWindow, 10, 410, 340, 30);
  saveButton.setText("Save Canvas");
  saveButton.addEventHandler(this, "handleSaveCanvas");
}

// draws GUI content including palette and preview
synchronized public void drawControlsWindow(PApplet appc, GWinData data) {
  appc.background(230);
  appc.noStroke();

  // draw color palette buttons
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

  // handle color selection click
  if (appc.mousePressed && appc.mouseX > startX && appc.mouseX < (startX + cols * (buttonSize + padding)) &&  appc.mouseY > startY && appc.mouseY < (startY + (paletteColors.length / cols + 1) * (buttonSize + padding))) {
    int x = (appc.mouseX - startX) / (buttonSize + padding);
    int y = (appc.mouseY - startY) / (buttonSize + padding);
    int index = y * cols + x;
    canvas.getColors().setPenColorFromPalette(index);
  }

  // draw preview box for custom RGB
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

// applies custom RGB color to pen
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

// saves canvas to file
public void handleSaveCanvas(GButton button, GEvent event) {
  if (button == saveButton && event == GEvent.CLICKED) {
    String filename = filenameField.getText();
    if (filename != null && !filename.trim().isEmpty()) {
      canvas.save(filename);
      filenameField.setText(""); // Clear the field after saving
    } else {
      canvas.save(null);
    }
  }
}

// handles tool selection from dropdown
public void handleToolSelect(GDropList list, GEvent event) {
  if (event == GEvent.SELECTED) {
    String selected = list.getSelectedText();
    
    if (selected.equals("Pen")) {
      canvas.setEraserActive(false);
      canvas.setCurrentTool("Pen");
    }
    else if (selected.equals("Eraser")) {
      canvas.setEraserActive(true);
      canvas.setCurrentTool("Eraser");
    }
    else if (selected.equals("Rectangle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Rectangle");
      canvas.setCurrentTool("Shape");
    }
    else if (selected.equals("Circle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Circle");
      canvas.setCurrentTool("Shape");
    }
    else if (selected.equals("Triangle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Triangle");
      canvas.setCurrentTool("Shape");
    }
  }
}
