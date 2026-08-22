class FloodStatus {
  final String state;
  final String status;
  final String updatedAt;

  FloodStatus({
    required this.state,
    required this.status,
    required this.updatedAt,
  });

  factory FloodStatus.fromMap(Map<String, dynamic> data) {
    return FloodStatus(
      state: data['state'] ?? '',
      status: data['status'] ?? 'unknown',
      updatedAt: data['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'state': state, 'status': status, 'updatedAt': updatedAt};
  }
}
