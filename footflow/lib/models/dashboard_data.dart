class DashboardData {
  final int newCount;
  final int inProductionCount;
  final int completedCount;
  final int deliveredCount;

  DashboardData({
    required this.newCount,
    required this.inProductionCount,
    required this.completedCount,
    required this.deliveredCount,
  });

  // Método de conversão de JSON (útil se o backend retornar um objeto com estas estatísticas)
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      newCount: json['new'] as int,
      inProductionCount: json['in_production'] as int,
      completedCount: json['completed'] as int,
      deliveredCount: json['delivered'] as int,
    );
  }
}