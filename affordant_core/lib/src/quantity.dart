/// This class should use int as underlying representation for convertions and
/// easier display purpose
class Quantity<Unit extends Enum> {
  final double value;
  final Unit unit;

  const Quantity({required this.value, required this.unit});
}

final e = Error();
