PVector moebius(PVector z, PVector a, PVector b, PVector c, PVector d)
{
  PVector num = cadd(cmult(a, z), b);
  PVector den = cadd(cmult(c, z), d);

  return cmult(num, cexp(den, new PVector(-1, 0), 0));
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
