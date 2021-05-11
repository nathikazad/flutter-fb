class FirebasePath {
  static String job(String uid, String jobId) => 'jobs/$uid/$jobId';
  static String jobs(String uid) => 'jobs/$uid';
  static String entry(String uid, String entryId) => 'entries/$uid/$entryId';
  static String entries(String uid) => 'entries/$uid';
}
