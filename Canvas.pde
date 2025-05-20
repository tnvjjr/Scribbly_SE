class Canvas {
  PGraphics canvas;

  int strokeSize;
  boolean isEraserActive;
  int eraserStrokeSize;
  Colors colors;

  String currentShape;
  Shape currentShapeInstance;
  boolean isDrawing;
  PVector startPoint;
  Shape selectedShape;

  int vertexIndex = -1;
  boolean isDragging = false;

  ArrayList<Shape> finalizedShapes = new ArrayList<Shape>();

  // initialize canvas settings
  Canvas(int width, int height) {
    canvas = createGraphics(width, height);
    strokeSize = 3;
    eraserStrokeSize = 20;
    isEraserActive = false;
    colors = new Colors();
    currentShape = "Rectangle";
    isDrawing = false;
    selectedShape = null;
    clear();
  }

  // runs each frame to update canvas
  void draw() {
    canvas.beginDraw();
    canvas.background(255);

    // draw all saved shapes
    for (Shape s : finalizedShapes) {
      s.draw(canvas);
    }

    // draw current shape in progress
    if (currentShapeInstance != null) {
      currentShapeInstance.draw(canvas);
    }

    // draw selected shape and its handles
    if (selectedShape != null) {
      selectedShape.draw(canvas);
      drawVertices(selectedShape);
    }

    // draw while mouse is pressed
    if (mousePressed && mouseY > 0) {
      if (isEraserActive) {
        canvas.noStroke();
        canvas.fill(255);
        canvas.ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
      } else {
        if (!isDrawing) {
          startPoint = new PVector(mouseX, mouseY);
          isDrawing = true;
        }

        PVector currentPoint = new PVector(mouseX, mouseY);
        float distance = PVector.dist(startPoint, currentPoint);

        currentShapeInstance = new Shape(startPoint.x, startPoint.y, colors.getPenColor(), strokeSize, colors.getPenColor(), currentShape);

        // shape setup logic
        switch (currentShape) {
          case "Circle":
            currentShapeInstance.setRadius(distance);
            break;
          case "Rectangle":
            float topLeftX = min(startPoint.x, currentPoint.x);
            float topLeftY = min(startPoint.y, currentPoint.y);
            float rectWidth = abs(currentPoint.x - startPoint.x);
            float rectHeight = abs(currentPoint.y - startPoint.y);
            currentShapeInstance.coords.set(topLeftX, topLeftY);
            currentShapeInstance.setRectangleDimensions(rectWidth, rectHeight);
            break;
          case "Triangle":
            float halfSize = distance;
            currentShapeInstance.setTriangleCoordinates(
              startPoint.x - halfSize, startPoint.y + halfSize,
              startPoint.x + halfSize, startPoint.y + halfSize
            );
            break;
        }

        drawShapePreview(currentShapeInstance);
      }
    } else if (isDrawing) {
      if (currentShapeInstance != null) {
        finalizedShapes.add(currentShapeInstance);
      }
      isDrawing = false;
      currentShapeInstance = null;
    }

    canvas.endDraw();
    image(canvas, 0, 0);

    if (isEraserActive) {
      drawEraserPreview();
    }
  }

  // shows eraser cursor on screen
  void drawEraserPreview() {
    pushStyle();
    stroke(100);
    strokeWeight(1);
    noFill();
    ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
    popStyle();
  }

  // shows shape preview on screen
  void drawShapePreview(Shape shape) {
    pushStyle();
    shape.draw(null);
    popStyle();
  }

  // draws shape vertices for editing
  void drawVertices(Shape shape) {
    pushStyle();
    fill(0, 255, 0);
    noStroke();

    if (shape.type.equals("Circle")) {
      ellipse(shape.coords.x + shape.radius, shape.coords.y, 10, 10);
    } 
    else if (shape.type.equals("Rectangle")) {
      rect(shape.coords.x + shape.width, shape.coords.y + shape.height, 10, 10);
    } 
    else if (shape.type.equals("Triangle")) {
      ellipse(shape.coord2.x, shape.coord2.y, 10, 10);
      ellipse(shape.coord3.x, shape.coord3.y, 10, 10);
    }

    popStyle();
  }

  // handles mouse down for editing
  void mousePressed(float x, float y) {
    vertexIndex = -1;
    isDragging = false;

    if (selectedShape != null) {
      vertexIndex = selectedShape.getVertexIndex(x, y);
      if (vertexIndex != -1) {
        isDragging = true;
        return;
      }
    }

    if (currentShapeInstance != null && currentShapeInstance.contains(x, y)) {
      selectedShape = currentShapeInstance;
    }
  }

  // handles dragging vertices
  void mouseDragged(float x, float y) {
    if (isDragging && selectedShape != null) {
      selectedShape.adjustVertex(vertexIndex, x, y);
    }
  }

  // resets drag state
  void mouseReleased() {
    isDragging = false;
    vertexIndex = -1;
  }

  // updates current shape type
  void setShape(String shape) {
    currentShape = shape;
  }

  // updates stroke size globally
  void setStrokeSize(int size) {
    strokeSize = size;
    if (selectedShape != null) {
      selectedShape.borderWidth = size;
    }
  }

  // updates eraser size
  void setEraserSize(int size) {
    eraserStrokeSize = size;
  }

  // updates color of selected shape
  void setColor(color col) {
    if (selectedShape != null) {
      selectedShape.rgb = col;
    }
  }

  // clears canvas and shape list
  void clear() {
    finalizedShapes.clear();
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }

  // saves canvas as png file
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

  // gets color manager
  Colors getColors() {
    return colors;
  }

  // turns eraser mode on/off
  void setEraserActive(boolean active) {
    isEraserActive = active;
  }
}
