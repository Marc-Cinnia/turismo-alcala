class RoutePointRef {
  const RoutePointRef({
    required this.targetId,
    required this.targetType,
    required this.targetUuid,
    required this.url,
  });

  final int targetId;
  final String targetType;
  final String targetUuid;
  final String url;
}

