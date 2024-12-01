import 'dart:math';

// Reynolds sayısını hesaplayan fonksiyon
double calculateReynoldsNumber(double flowVelocity, double pipeDiameter, double kinematicViscosity) {
  return (flowVelocity * pipeDiameter) / kinematicViscosity;
}

// Laminer akış için sürtünme katsayısı hesaplayan fonksiyon
double calculateLaminarFrictionCoefficient(double reynoldsNumber) {
  return 64 / reynoldsNumber;
}

// Türbülanslı akış için sürtünme katsayısı hesaplayan fonksiyon (Colebrook-White denklemi)
double calculateTurbulentFrictionCoefficient(double reynoldsNumber, double materialCoefficient, double pipeDiameter) {
  double relativeRoughness = materialCoefficient / pipeDiameter;

  double colebrook(double frictionFactor) {
    return -2.0 * log((relativeRoughness / 3.7) + (2.51 / (reynoldsNumber * sqrt(frictionFactor))));
  }

  // Newton-Raphson iterasyonu
  double frictionFactor = 0.02; // İlk tahmin
  for (int i = 0; i < 10; i++) {
    frictionFactor = 1 / pow(colebrook(frictionFactor), 2);
  }

  return frictionFactor;
}

// Sürtünme katsayısını hesaplayan ana fonksiyon
double calculateFrictionCoefficient(double flowVelocity, double pipeDiameter, double kinematicViscosity, double materialCoefficient) {
  double reynoldsNumber = calculateReynoldsNumber(flowVelocity, pipeDiameter, kinematicViscosity);

  if (reynoldsNumber < 2300) {
    return calculateLaminarFrictionCoefficient(reynoldsNumber);
  } else {
    return calculateTurbulentFrictionCoefficient(reynoldsNumber, materialCoefficient, pipeDiameter);
  }
}

 Calculate() {
  // Parametreler
  double flowVelocity = 2.0; // m/s (örneğin)
  double pipeDiameter = 0.05; // m
  double kinematicViscosity = 1e-6; // m²/s (içme suyu için yaklaşık)
  double materialCoefficient = 0.0001; // Borunun malzeme katsayısı (örneğin)

  // Sürtünme katsayısını hesaplama
  double frictionCoefficient = calculateFrictionCoefficient(flowVelocity, pipeDiameter, kinematicViscosity, materialCoefficient);

  print("Sürtünme Katsayısı: ${frictionCoefficient.toStringAsFixed(4)}");
}
