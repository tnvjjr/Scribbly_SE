class Colors {
  color[] paletteColors;
  color penColor;
  
  Colors() {
    paletteColors = new color[] {
      #000000, #222034, #323c39, #3f3f74, #306082, #5b6ee1, #639bff, #5fcde4,
      #4b692f, #37946e, #6abe30, #99e550, #8f974a,
      #595652, #696a6a, #847e87, #9badb7, #cbdbfc,
      #663931, #45283c, #8f563b, #df7126, #d9a066, #eec39a,
      #fbf236, #d95763, #d77bba, #76428a, #ac3232, #8a6f30,
      #ffffff
    };
    penColor = color(0); // Start with black
  }
  
  void setPenColor(int r, int g, int b) {
    penColor = color(r, g, b);
  }
  
  color getPenColor() {
    return penColor;
  }
  
  color[] getPaletteColors() {
    return paletteColors;
  }
  
  void setPenColorFromPalette(int index) {
    if (index >= 0 && index < paletteColors.length) {
      penColor = paletteColors[index];
    }
  }
}
