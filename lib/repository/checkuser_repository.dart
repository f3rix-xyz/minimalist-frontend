import 'package:flutter/cupertino.dart';
import 'package:minimalist/repository/fetchuser_repository.dart';

Future<String> checkUser(BuildContext context) async {
  try {
    final user = await fetchuserRepository(context: context);
    if (user != null && user.subscriptionValidTill.isAfter(DateTime.now())) {
      return "home";
    } else if (user != null &&
        user.subscriptionValidTill.isBefore(DateTime.now())) {
      return "subscription";
    }
  } catch (e) {
    return "login";
  }
  // Adding a return statement to handle all code paths
  return "login";
}
