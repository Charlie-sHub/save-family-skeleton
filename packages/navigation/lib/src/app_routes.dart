abstract final class AppRoutes {
  static const String home = '/home';
  static const String activity = '/activity';

  static const String savingsGoalsList = '/children/:childId/savings-goals';
  static const String createSavingsGoal =
      '/children/:childId/savings-goals/new';
  static const String savingsGoalDetail =
      '/children/:childId/savings-goals/:goalId';

  static String savingsGoalsListPath(String childId) =>
      '/children/$childId/savings-goals';

  static String createSavingsGoalPath(String childId) =>
      '${savingsGoalsListPath(childId)}/new';

  static String savingsGoalDetailPath(String childId, String goalId) =>
      '${savingsGoalsListPath(childId)}/$goalId';
}
