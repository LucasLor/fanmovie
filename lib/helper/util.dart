/// Transforma rating de 10 estrelas para 4 estrelas.
double convertStars(double rating){
  return double.parse( (rating / 2).toStringAsPrecision(2));
}