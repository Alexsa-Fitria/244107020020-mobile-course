import 'package:flutter_test/flutter_test.dart';
import 'package:ai_challenge_comments/data/models/comment.dart';

void main() {
  group('Comment Model Test', () {
    test('fromJson dengan field lengkap', () {
      final json = {
        'postId': 1,
        'id': 1,
        'name': 'Test Name',
        'email': 'test@example.com',
        'body': 'Test Body',
      };
      final comment = Comment.fromJson(json);
      expect(comment.postId, 1);
      expect(comment.name, 'Test Name');
    });

    test('fromJson dengan field hilang (null safety test)', () {
      final json = <String, dynamic>{};
      final comment = Comment.fromJson(json);
      expect(comment.postId, 0);
      expect(comment.id, 0);
      expect(comment.name, '');
      expect(comment.email, '');
      expect(comment.body, '');
    });
  });
}