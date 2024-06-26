class vec4
{
  float x, y, z, w;

  vec4()
  {
    x = 0;
    y = 0;
    z = 0;
    w = 0;
  }

  vec4(float _x, float _y, float _z, float _w)
  {
    x = _x;
    y = _y;
    z = _z;
    w = _w;
  }
}

PImage domainColouringImg;

float angleA = 2.0;
float angleB = 3.0;
float angleC = 0.0;
float angleD = -1.6;


static float e = 2.71828;
static float pi = 3.14159;
static float twopi = 3.14159 * 2.0f;

float domXMin = -1*pi;
float domXMax = 1*pi;
float domYMin = -1 * pi;
float domYMax = 1 * pi;

int gridsize = 72;

float time = 0;

float rangeScale = 0.0f;
float domainScale = 1.0f;
float domYScale = 1.0f;

float p = 0; // for use in functions as a dynamically editable parameter. Change it's value with Q,P keys

int branchCount = 2;

float magThresh = 1.0f; // for continuity checks

boolean domain_polar = false;


void setup()
{
  size(1800, 900);
  textSize(20);


  domainColouringImg = new PImage(height, height);

  renderDomainColouring();
}

void DisplayText()
{
  text("domain scale : " + str(domainScale), 5, 40);
  text("range scale : " + str(rangeScale), 5, 20);

  text("p : " + str(p), 5, 70);
}

void draw()
{
  colorMode(HSB, 1);
  time += 0.01f;
  noStroke();
  fill(0, 0, 0.5);
  rect(0, 0, height, height);

  angleA = 0;//float(mouseX - height/2) / height * 12 + PI / 2;
  angleB = float(mouseX - height/2) / height * 12 + PI/2;
  angleC = float(mouseY - height/2) / height * 12;
  angleD = PI/2;//float(mouseY - height/2) / height * 12;

  for (int i = 0; i < branchCount; i++)
    drawComplexGraph(float(i) * 2 * pi);


  drawDomainColouring();
  drawQuadrentMarkers();
  drawAxes();

  DisplayText();
}

color xColor = color(255, 123, 0);
color yColor = color(255, 255, 0);
color zColor = color(0, 123, 255);
color wColor = color(0, 255, 255);


void drawAxes()
{
  colorMode(RGB, 255);

  PVector originScreenSpace = proj42(new vec4(0, 0, 0, 0), angleA, angleB, angleC, angleD);
  PVector xScreenSpace = proj42(new vec4(1, 0, 0, 0), angleA, angleB, angleC, angleD);
  PVector yScreenSpace = proj42(new vec4(0, 1, 0, 0), angleA, angleB, angleC, angleD);
  PVector zScreenSpace = proj42(new vec4(0, 0, 1, 0), angleA, angleB, angleC, angleD);
  PVector wScreenSpace = proj42(new vec4(0, 0, 0, 1), angleA, angleB, angleC, angleD);

  strokeWeight(2);

  stroke(xColor);
  fill  (xColor);
  line(originScreenSpace.x, originScreenSpace.y, xScreenSpace.x, xScreenSpace.y);
  if (domainScale > 0) text("Re(z)", xScreenSpace.x, xScreenSpace.y);

  stroke(yColor);
  fill  (yColor);
  line(originScreenSpace.x, originScreenSpace.y, yScreenSpace.x, yScreenSpace.y);
  if (domainScale > 0) text("Im(z)", yScreenSpace.x, yScreenSpace.y);

  stroke(zColor);
  fill  (zColor);
  line(originScreenSpace.x, originScreenSpace.y, zScreenSpace.x, zScreenSpace.y);
  if (rangeScale > 0) text("Re(f(z))", zScreenSpace.x, zScreenSpace.y);

  stroke(wColor);
  fill  (wColor);
  line(originScreenSpace.x, originScreenSpace.y, wScreenSpace.x, wScreenSpace.y);
  if (rangeScale > 0) text("Im(f(z))", wScreenSpace.x, wScreenSpace.y);

  stroke(255);
  fill(255);
  strokeWeight(1);
  circle(originScreenSpace.x, originScreenSpace.y, 10);

  // Axis labels:
}


void keyPressed()
{
  if (key == '+' || key == '=')
    rangeScale += 0.025;
  if (key == '-' )
    rangeScale -= 0.025;

  if (key == ']')
    domYScale += 0.025;
  if (key == '[' )
    domYScale -= 0.025;

  if (key == '0')
    domainScale += 0.025;
  if (key == '9' )
    domainScale -= 0.025;


  if (key=='p')
    p += 0.025;
  if (key=='q')
    p -= 0.025;

  rangeScale = max(rangeScale, 0);
  domainScale = max(domainScale, 0);

  //p = max(min(1, p), 0);
  //rangeScale = min(1,rangeScale);
  //domainScale = 1 - rangeScale;
}

PVector complexFunc(float x, float y, float branch )
{
  PVector z = new PVector(x, y);

  //return cadd(cexp(cadd(new PVector(1, 0), cmult(new PVector(1, 0), cexp(z, 2))), new PVector(0.5, 0), branch + p * pi * 2),
  //  cexp(cadd(new PVector(1, 0), cmult(new PVector(-1, 0), cexp(z, 2))), new PVector(0.5, 0), branch/2 + p * pi * 2));
  //return cdiv(z, cexp(csin(z), 2));

  //return cdiv(csin(z), z);
  //return cmult(ccos(cmult(z, new PVector(pi,0))),cexp(csin(cmult(z, new PVector(pi,0))), new PVector(-1,0),0));

  //return cexp(z, branch);
  // return cexp(z, new PVector(0.5, 0), branch);
  //return cexp(new PVector(e, 0), z, branch);

  //if(true) return cadd(clog(z, -time) , clog(z, -time));
  // return complexPosPrinciple(new PVector(x, y), 0.5, branch); // return id

  // return complexPosPrinciple(new PVector(x * x - y * y + 1, 2 * x * y), 0.5, branch); // return id
  //return new PVector(log(z.mag()), z.heading() + 2 * pi * branch);// Log(z)

  //return complexPosPrinciple(z, 0.5, branch);

  // actual homework function:
  //if(true)return complexPosPrinciple(complexPosPrinciple(z, 2, 0).add(new PVector(1, 0)), 1.0/2.0, branch); // return id

  // return cexp(cadd(cmult(z,z), new PVector(1,0)), new PVector(0.5, 0), branch);
  // homework answer!!!:
  return cexp(new PVector(e, 0), cmult(new PVector(0.5f, 0), cadd(clog(cadd(z, new PVector(0, 1)), pi/2 + (-p)*pi), clog(cadd(z, new PVector(0, -1)), pi/2))), 0);

  //  PVector z2p1 = cmult(z,z).add(new PVector(1,0));

  //if(true)
  //  return cexp(new PVector(e,0), z, branch);
  //  return cexp(new PVector(e,0), new PVector(0.5 * log(z2p1.mag()), 0.5 * z2p1.heading()), branch);
  //return cexp(z, new PVector(-0.5,0.0), branch);
}


vec4 surfaceParam(float s, float t, float branch)
{

  PVector output = complexFunc(s, t, branch);
  return new vec4(s, t, output.x, output.y);
  //return new vec4(cos(s), sin(s), cos(t), sin(t));

  //PVector z = new PVector(s,t);
  //return new vec4(csinh(z).x, csinh(z).y, csin(z).x, csin(z).y);
  // hopf fibration
  //float nu = time % (pi);
  //return new vec4(cos(s) * sin(nu), sin(s) * sin(nu), cos(t) * cos(nu), sin(t) * cos(nu));
}


PVector invStereoToScreen(PVector z, float a, float b, float c, float d)
{
  float X = z.x;
  float Y = z.y;
  float X2 = X * X;
  float Y2 = Y * Y;
  float DEN = (1 + X2 + Y2);

  PVector rangeStereoSphereCoords = new PVector(
    2.0f * X / DEN,
    2.0f * Y / DEN,
    (DEN - 2.0f) / DEN
    );

  PVector rangeScreenSpace = new PVector(
    rangeStereoSphereCoords.x * cos(c) -  rangeStereoSphereCoords.y * sin(c),
    rangeStereoSphereCoords.x * sin(c) +  rangeStereoSphereCoords.y * cos(c) - 1.0 * rangeStereoSphereCoords.z
    );

  return rangeScreenSpace;
}

PVector proj42(vec4 world, float a, float b, float c, float d)
{

  PVector domainScreenSpace = new PVector(
    cos(a) * world.x * domainScale - cos(b) * world.y * domainScale * domYScale,
    sin(a) * world.x * domainScale - sin(b) * world.y * domainScale * domYScale
    );


  PVector rangeScreenSpace = new PVector(
    cos(c) * world.z * rangeScale - cos(d) * world.w * rangeScale,
    sin(c) * world.z * rangeScale - sin(d) * world.w * rangeScale
    );


  /*
  PVector screen = PVector.mult(
   cmult(
   cmult(
   new PVector(world.x + b , world.y ),
   new PVector(1, 0)),
   cexp(
   cadd(
   new PVector(world.z, world.w),
   new PVector(c, 0)),
   new PVector(-1, 0), 0)),
   domainScale);
   */


  /*

   float X = world.z;
   float Y = world.w;
   float X2 = X * X;
   float Y2 = Y * Y;
   float DEN = (1 + X2 + Y2);
   
   PVector rangeStereoSphereCoords = new PVector(
   2.0f * X / DEN,
   2.0f * Y / DEN,
   (DEN - 2.0f) / DEN
   );
   
   PVector rangeScreenSpace = new PVector(
   rangeStereoSphereCoords.x * cos(c) -  rangeStereoSphereCoords.y * sin(c),
   rangeStereoSphereCoords.x * sin(c) +  rangeStereoSphereCoords.y * cos(c) - 1.0 * rangeStereoSphereCoords.z
   );
   */

  // PVector rangeScreenSpace = PVector.mult(invStereoToScreen(new PVector(world.z, world.w), a,b,c,d), rangeScale);
  // domainScreenSpace = PVector.mult(invStereoToScreen(new PVector(world.x, world.y), c,d,b,a), domainScale);

  PVector screen = PVector.add(domainScreenSpace, rangeScreenSpace);

  screen = PVector.mult(screen, height / 12);
  return PVector.add(screen, new PVector(height/2, height/2));
}

color complexToColor(PVector z)
{
  float zmag = z.mag();
  return color(z.heading() / (2 * pi) + 0.5, 1/zmag, zmag);
}

void renderDomainColouring()
{
  colorMode(HSB, 1, 1, 1);
  for (int x = 0; x < height; x++)
  {
    for (int y = 0; y < height; y++)
    {
      float xWorld = float(x)/height * (domXMax - domXMin) + domXMin;
      float yWorld = -(float(y)/height * (domYMax - domYMin) + domYMin);
      PVector output = complexFunc(xWorld, yWorld, 0.0);

      color col = complexToColor(output);

      domainColouringImg.set(x, y, col);
    }
  }
}

void drawDomainColouring()
{
  image(domainColouringImg, height, 0);

  strokeWeight(2);

  PVector originScreenSpace = new PVector(height + height/2, height/2);
  PVector xScreenSpace =  new PVector(height + height/2 + (height / (domXMax - domXMin)), height/2);
  PVector yScreenSpace =  new PVector(height + height/2, height/2 - (height / (domXMax - domXMin)));
  textSize(20);

  stroke(xColor);
  fill  (xColor);
  line(originScreenSpace.x, originScreenSpace.y, xScreenSpace.x, xScreenSpace.y);
  text("Re(z)", xScreenSpace.x, xScreenSpace.y);

  stroke(yColor);
  fill  (yColor);
  line(originScreenSpace.x, originScreenSpace.y, yScreenSpace.x, yScreenSpace.y);
  text("Im(z)", yScreenSpace.x, yScreenSpace.y);

  fill(0, 0, 1);
  noStroke();
  //strokeWeight(1);
  textSize(15);

  for (int x = -5; x < 5; x++)
  {
    circle(originScreenSpace.x + (height / (domXMax - domXMin)) * x, originScreenSpace.y, 4);
    circle(originScreenSpace.x, originScreenSpace.y - (height / (domXMax - domXMin)) * x, 4);

    text(str(x), originScreenSpace.x + (height / (domXMax - domXMin)) * x, originScreenSpace.y + 25);
    text(str(x) + "i", originScreenSpace.x - 20, originScreenSpace.y - (height / (domXMax - domXMin)) * x + 4);
  }
}

void drawComplexGraph(float branch )
{
  strokeWeight(1);

  vec4[][] points = new vec4[gridsize][gridsize];

  float radiusX = (domXMax - domXMin) / 2;
  float radiusY = (domYMax - domYMin) / 2;
  float xMid = (domXMax + domXMin) / 2;
  float yMid = (domYMax + domYMin) / 2;

  for (int x = 0; x < gridsize; x++)
    for (int y = 0; y < gridsize; y++)
    {
      float xWorld, yWorld;

      if (domain_polar)
      {
        float theta = float(x) / float(gridsize) * twopi;
        float r = float(y) / float(gridsize);

        xWorld = xMid + cos(theta) * radiusX * r;
        yWorld = yMid + sin(theta) * radiusY * r;
      } else
      {
        xWorld = float(x) / float(gridsize) * (domXMax - domXMin) + domXMin;
        yWorld = float(y) / float(gridsize) * (domYMax - domYMin) + domYMin;
      }

      points[x][y] = surfaceParam(xWorld, yWorld, branch);
    }

  int xMax = gridsize - 1;
  if (domain_polar)
    xMax = gridsize;

  for (int x = 0; x < xMax; x++)
    for (int y = 0; y < gridsize - 1; y++)
    {
      PVector[] coords = new PVector[4];
      coords[0] = proj42(points[x][y], angleA, angleB, angleC, angleD);
      coords[1] = proj42(points[(x + 1) % gridsize][y], angleA, angleB, angleC, angleD);
      coords[2] = proj42(points[x][y + 1], angleA, angleB, angleC, angleD);
      coords[3] = proj42(points[x][y], angleA, angleB, angleC, angleD);

      PVector image = new PVector(points[x][y].z, points[x][y].w);
      colorMode(HSB, 1, 1, 1);

      stroke(color(image.heading()/ (2 * pi) + 0.5, 0.5, image.mag()));
      strokeWeight(1);

      if (y == gridsize/2)
      {
        strokeWeight(2);
        stroke(1, 0, 1);
      }

      // continuity checks
      if (new PVector(points[x][y].z - points[(x + 1) % gridsize][y].z, points[x][y].w - points[(x + 1) % gridsize][y].w).mag() < magThresh)
        line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);

      stroke(color(image.heading()/ (2 * pi) + 0.5, 0.5, image.mag()));
      strokeWeight(1);

      if (x == gridsize/2)
      {
        strokeWeight(2);
        stroke(1, 0, 1);
      }

      if (new PVector(points[x][y].z - points[x][y + 1].z, points[x][y].w - points[x][y + 1].w).mag() < magThresh)
        line(coords[0].x, coords[0].y, coords[2].x, coords[2].y);
    }

  for (int x = 0; x < gridsize - 1; x++)
  {
    stroke(complexToColor(new PVector(points[x][gridsize - 1].z, points[x][gridsize - 1].w)));
    //stroke(color(new PVector(points[x][gridsize - 1].z, points[x][gridsize - 1].w).heading()/ (2 * pi) + 0.5, 0.5, 1));

    //stroke(200, 0, 200);
    PVector[] coords = new PVector[4];
    coords[0] = proj42(points[x][gridsize - 1], angleA, angleB, angleC, angleD);
    coords[1] = proj42(points[x + 1][gridsize - 1], angleA, angleB, angleC, angleD);

    if (new PVector(points[x][gridsize - 1].z - points[x + 1][gridsize - 1].z, points[x][gridsize - 1].w - points[x + 1][gridsize - 1].w).mag() < magThresh)
      line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);
  }
  for (int y = 0; y < gridsize - 1; y++)
  {
    stroke(complexToColor(new PVector(points[gridsize - 1][y].z, points[gridsize - 1][y].w)));
    //stroke(color(new PVector(points[gridsize - 1][y].z, points[gridsize - 1][y].w).heading()/ (2 * pi) + 0.5, 0.5, 1));

    //stroke(200, 200, 0);
    PVector[] coords = new PVector[4];
    coords[0] = proj42(points[gridsize - 1][y], angleA, angleB, angleC, angleD);
    coords[1] = proj42(points[gridsize - 1][y + 1], angleA, angleB, angleC, angleD);

    if (new PVector(points[gridsize - 1][y].z - points[gridsize - 1][y + 1].z, points[gridsize - 1][y].w - points[gridsize - 1][y + 1].w).mag() < magThresh)
      line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);
  }

  // domain plane:
  stroke(0, 0, 1, 0.25);
  strokeWeight(1);

  float planeGridSize = 10;

  for (int x = 0; x < planeGridSize; x++)
    for (int y = 0; y < planeGridSize; y++)
    {
      float xWorld = float(x) / planeGridSize * (domXMax - domXMin) + domXMin;
      float yWorld = float(y) / planeGridSize * (domYMax - domYMin) + domYMin;

      float xWorld1 = float(x + 1) / planeGridSize * (domXMax - domXMin) + domXMin;
      float yWorld1 = float(y + 1) / planeGridSize * (domYMax - domYMin) + domYMin;
      PVector[] coords = new PVector[4];

      // range
      vec4 p0 = new vec4(0, 0, xWorld, yWorld);
      vec4 p1 = new vec4(0, 0, xWorld1, yWorld);
      vec4 p2 = new vec4(0, 0, xWorld, yWorld1);

      coords[0] = proj42(p0, angleA, angleB, angleC, angleD);
      coords[1] = proj42(p1, angleA, angleB, angleC, angleD);
      coords[2] = proj42(p2, angleA, angleB, angleC, angleD);

      line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);
      line(coords[0].x, coords[0].y, coords[2].x, coords[2].y);

      // domain
      p0 = new vec4(xWorld, yWorld, 0, 0);
      p1 = new vec4(xWorld1, yWorld, 0, 0);
      p2 = new vec4(xWorld, yWorld1, 0, 0);

      coords[0] = proj42(p0, angleA, angleB, angleC, angleD);
      coords[1] = proj42(p1, angleA, angleB, angleC, angleD);
      coords[2] = proj42(p2, angleA, angleB, angleC, angleD);

      line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);
      line(coords[0].x, coords[0].y, coords[2].x, coords[2].y);

      // vertical
      PVector output = complexFunc(xWorld, yWorld, branch);

      p0 = new vec4(xWorld, yWorld, 0, 0);
      p1 = new vec4(xWorld, yWorld, output.x, output.y);

      coords[0] = proj42(p0, angleA, angleB, angleC, angleD);
      coords[1] = proj42(p1, angleA, angleB, angleC, angleD);

      //line(coords[0].x, coords[0].y, coords[1].x, coords[1].y);
    }
}

void drawQuadrentMarkers()
{
  colorMode(HSB, 1);
  fill(0, 0, 1);

  PVector[] markerDomainPositions = {new PVector(1, 1), new PVector(-1, 1), new PVector(-1, -1), new PVector(1, -1)};
  String[] markers = {"A", "B", "C", "D"};
  for (int i = 0; i < 4; i++)
  {
    PVector output = complexFunc(markerDomainPositions[i].x, markerDomainPositions[i].y, 0);
    vec4 graphPoint = new vec4(markerDomainPositions[i].x, markerDomainPositions[i].y, output.x, output.y);
    PVector screenPoint = proj42(graphPoint, angleA, angleB, angleC, angleD);
    text(markers[i], screenPoint.x, screenPoint.y);

    // points on the domain colouring
    float xWorld = (markerDomainPositions[i].x - domXMin) / (domXMax - domXMin) * height;
    float yWorld = (markerDomainPositions[i].y - domYMin) / (domYMax - domYMin) * height;
    text(markers[i], xWorld + height, yWorld);
  }
}
