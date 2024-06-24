import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController textController;

  const Header({super.key, required this.textController});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text('Nutone API'),
        actions: <Widget> [SearchBar(
            controller: textController,
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search)
            )
          ]
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}