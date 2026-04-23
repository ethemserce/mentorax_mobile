class StreakMilestones {
  static const List<int> values = [3, 7, 14, 30, 60, 100];

  static bool isMilestone(int streakDays) {
    return values.contains(streakDays);
  }

  static String getTitle(int streakDays) {
    switch (streakDays) {
      case 3:
        return '3-Day Streak!';
      case 7:
        return '1-Week Streak!';
      case 14:
        return '2-Week Streak!';
      case 30:
        return '30-Day Streak!';
      case 60:
        return '60-Day Streak!';
      case 100:
        return '100-Day Streak!';
      default:
        return 'Streak Milestone!';
    }
  }

  static String getMessage(int streakDays) {
    switch (streakDays) {
      case 3:
        return 'Great start. You are building momentum.';
      case 7:
        return 'Amazing. One full week of consistency.';
      case 14:
        return 'Excellent work. Your habit is getting stronger.';
      case 30:
        return 'Outstanding. A full month of consistency.';
      case 60:
        return 'Incredible discipline. Keep going strong.';
      case 100:
        return 'Legendary consistency. This is a huge achievement.';
      default:
        return 'You reached a new milestone. Keep going!';
    }
  }
}