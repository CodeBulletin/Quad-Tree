void setup(){
}

class Quad_Tree {
  Rectangle boundary;
  int capacity;
  ArrayList<Point> points;
  Quad_Tree northeast, northwest, southwest, southeast;
  boolean sub_divided = false;
  Quad_Tree(Rectangle _boundary, int n) {
    boundary = _boundary;
    capacity = n;
    points = new ArrayList<Point>();
  }
  void subdivide() {
    Rectangle NE = new Rectangle(boundary.x + boundary.w/2, boundary.y - boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle NW = new Rectangle(boundary.x - boundary.w/2, boundary.y - boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle SW = new Rectangle(boundary.x - boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle SE = new Rectangle(boundary.x + boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2);
    northeast = new Quad_Tree(NE, capacity);
    northwest = new Quad_Tree(NW, capacity);
    southwest = new Quad_Tree(SW, capacity);
    southeast = new Quad_Tree(SE, capacity);
    sub_divided = true;
  }
  void insert(Point P) {
    if (!boundary.contains(P)) {
      return;
    }
    if (points.size() < capacity) {
      points.add(P);
    } else {
      if (!sub_divided) {
        subdivide();
      }
      northeast.insert(P);
      northwest.insert(P);
      southwest.insert(P);
      southeast.insert(P);
    }
  }
  void show() {
    rect(boundary.x, boundary.y, boundary.w*2, boundary.h*2);
    if (sub_divided) {
      northeast.show();
      northwest.show();
      southwest.show();
      southeast.show();
    }
    for(Point P: points){
      point(P.x, P.y);
    }
  }
  ArrayList<Point> query(Circle range, ArrayList<Point> found){
    if(found == null){
      found = new ArrayList<Point>();
    }
    if(!boundary.intersect(range)){
      return null;
    } else {
      for(Point P : points){
        if(range.contains(P)){
          found.add(P);
        }
      }
      if(sub_divided){
        northeast.query(range, found);
        northwest.query(range, found);
        southwest.query(range, found);
        southeast.query(range, found);
      }
    }
    return found;
  }
}

class Point{
  float x, y;
  Object o;
  Point(float _x, float _y, Object _o){
    x = _x;
    y = _y;
    o = _o;
  }
}

class Rectangle{
  float x, y, w, h;
  Rectangle(float _x, float _y, float _w, float _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  boolean contains(Point P){
    return P.x <= x + w && P.x >= x - w && P.y <= y + h && P.y >= y - h;
  }
  boolean intersect(Circle C){
    return x-C.x <= w + C.d/2 && y-C.y <= h + C.d/2; 
  }
}

class Circle{
  float x, y, d;
  Circle(float _x, float _y, float _d){
    x = _x;
    y = _y;
    d = _d;
  }
  boolean contains(Point P){
    return dist(x, y, P.x, P.y) < d/2;
  }
}
