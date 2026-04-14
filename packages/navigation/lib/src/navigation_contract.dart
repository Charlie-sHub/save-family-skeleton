import 'package:go_router/go_router.dart';

abstract class NavigationContract {
  void setRouter(GoRouter router);
  void go(String path);
  void push(String path);
  void pop();
}

class NavigationContractImpl implements NavigationContract {
  GoRouter? _router;

  @override
  void setRouter(GoRouter router) {
    _router = router;
  }

  @override
  void go(String path) {
    _router?.go(path);
  }

  @override
  void push(String path) {
    _router?.push(path);
  }

  @override
  void pop() {
    _router?.pop();
  }
}
