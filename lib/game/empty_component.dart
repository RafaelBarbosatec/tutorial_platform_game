import 'package:bonfire/bonfire.dart';

class EmptyComponent extends GameComponent{

  @override
  void onMount() {
    super.onMount();
    removeFromParent();
  }

}