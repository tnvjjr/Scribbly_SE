class Shape {
  PVector coords;
  PVector coord2, coord3;
  color rgb;
  float borderWidth;
  color borderColor;
  float radius;
  float width, height;
  String type;

  Shape(float x, float y, color colour, float bw, color bc, String type) {
    this.coords = new PVector(x, y);
    this.rgb = colour;
    this.borderWidth = bw;
    this.borderColor = bc;
    this.type = type;
  }

  void setRadius(float r) {
    this.radius = r;
  }

  void setRectangleDimensions(float w, float h) {
    this.width = w;
    this.height = h;
  }

  void setTriangleCoordinates(float x2, float y2, float x3, float y3) {
    this.coord2 = new PVector(x2, y2);
    this.coord3 = new PVector(x3, y3);
  }

  void draw(PGraphics pg) {
    PGraphics target = (pg != null) ? pg : g;
    target.pushStyle();
    target.stroke(borderColor);
    target.strokeWeight(borderWidth);
    target.fill(rgb);

    switch (type) {
      case "Circle":
        target.ellipse(coords.x, coords.y, radius * 2, radius * 2);
        break;
      case "Rectangle":
        target.rect(coords.x, coords.y, width, height);
        break;
      case "Triangle":
        target.triangle(coords.x, coords.y, coord2.x, coord2.y, coord3.x, coord3.y);
        break;
    }

    target.popStyle();
  }

  boolean contains(float x, float y) {
    if (type.equals("Circle")) {
      return PVector.dist(coords, new PVector(x, y)) <= radius;
    } 
    else if (type.equals("Rectangle")) {
      return x >= coords.x && x <= coords.x + width && y >= coords.y && y <= coords.y + height;
    } 
    else if (type.equals("Triangle")) {
      return (PVector.dist(coord2, new PVector(x, y)) < 10) || 
             (PVector.dist(coord3, new PVector(x, y)) < 10);
    }
    return false;
  }

  int getVertexIndex(float x, float y) {
    if (type.equals("Circle")) {
      if (PVector.dist(new PVector(coords.x + radius, coords.y), new PVector(x, y)) < 10) {
        return 0;
      }
    } 
    else if (type.equals("Rectangle")) {
      if (PVector.dist(new PVector(coords.x + width, coords.y + height), new PVector(x, y)) < 10) {
        return 0;
      }
    } 
    else if (type.equals("Triangle")) {
      if (PVector.dist(coord2, new PVector(x, y)) < 10) return 1;
      if (PVector.dist(coord3, new PVector(x, y)) < 10) return 2;
    }
    return -1;
  }

  void adjustVertex(int index, float x, float y) {
    if (type.equals("Circle") && index == 0) {
      radius = max(5, PVector.dist(coords, new PVector(x, y)));
    } 
    else if (type.equals("Rectangle") && index == 0) {
      width = max(5, x - coords.x);
      height = max(5, y - coords.y);
    } 
    else if (type.equals("Triangle")) {
      if (index == 1) coord2.set(x, y);
      if (index == 2) coord3.set(x, y);
    }
  }
}
