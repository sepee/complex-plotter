
PVector cexp(PVector z, PVector alpha, float branch)
{
  if (z.mag() == 0)
    return z;


  int k = round((branch - z.heading()) / (2 * pi));

  float Arg_phi_z = z.heading() + 2 * pi * k;

  PVector w = new PVector(log(sqrt(z.x * z.x + z.y * z.y)), Arg_phi_z);
  w = new PVector(w.x * alpha.x - w.y * alpha.y, w.x * alpha.y + w.y * alpha.x);

  return new PVector(pow(e, w.x) * cos(w.y), pow(e, w.x) * sin(w.y));
}

PVector cexp(PVector z, int n)
{
  return cexp(z, new PVector(n, 0), 0);
}

PVector clog(PVector z, float branch)
{
  //Arg_branch(z) = Arg_{-\pi}(z) + 2k\pi
  int k = round((branch - z.heading() + pi) / (2 * pi));

  return new PVector(log(z.mag()), z.heading() + (2 * k * pi));
}
PVector cmult(PVector a, PVector b)
{
  //returns a * b
  return new PVector(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}
PVector cadd(PVector a, PVector b)
{
  //returns a + b
  return new PVector(a.x + b.x, a.y + b.y);
}
PVector cdiv(PVector a, PVector b)
{
  //returns a/b
  return cmult(a, cexp(b, new PVector(-1,0), 0));
}


PVector moebius(PVector z, PVector a, PVector b, PVector c, PVector d)
{
  //returns (az + b)/(cz + d)
  
  return cdiv(cadd(cmult(a, z), b), cadd(cmult(c, z), d));
}

PVector csinh(PVector z)
{
return PVector.mult(cadd(cexp(new PVector(e,0), z, 0.0f),PVector.mult( cexp(new PVector(e,0), PVector.mult(z,-1.0f), 0.0f),-1)), 0.5f);
}

PVector ccosh(PVector z)
{
return PVector.mult(cadd(cexp(new PVector(e,0), z, 0.0f), cexp(new PVector(e,0), PVector.mult(z,-1.0f), 0.0f)), 0.5f);
}

PVector csin(PVector z)
{
return PVector.mult(cadd(cexp(new PVector(e,0), cmult(z,new PVector(0,1)), 0.0f),PVector.mult( cexp(new PVector(e,0), PVector.mult(cmult(z,new PVector(0,1)),-1.0f), 0.0f),-1)), 0.5f);
}

PVector ccos(PVector z)
{
return PVector.mult(cadd(cexp(new PVector(e,0), cmult(z,new PVector(0,1)), 0.0f), cexp(new PVector(e,0), PVector.mult(cmult(z,new PVector(0,1)),-1.0f), 0.0f)), 0.5f);
}


/*
REDUNDANT CODE:

PVector complexPosPrinciple(PVector z, float alpha, float branch)
{

  float Arg_z = z.heading() + 2 * pi * branch;

  PVector w = new PVector(log(sqrt(z.x * z.x + z.y * z.y)), Arg_z);
  w = PVector.mult(w, alpha);

  return new PVector(pow(e, w.x) * cos(w.y), pow(e, w.x) * sin(w.y));
}


*/
