import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/user.dart';

class UserCard extends StatefulWidget {
  final PortalUser user;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const UserCard({super.key, required this.user, required this.onDelete, required this.onEdit});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getLabel(widget.user.uid),
        _getLabel(widget.user.username),
        _getLabel(widget.user.role.name.toUpperCase()),
        Center(
          child: IconButton(
            onPressed: widget.onDelete,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.disabled_by_default_outlined,
              size: 30,
              color: Colors.red,
            ),
          ),
        ),
        Center(
          child: IconButton(
            onPressed: widget.onEdit,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.edit,
              size: 30,
              color: Colors.grey,
            ),
          ),
        )

      ],
    );
  }

  _getLabel(String label){
    return Expanded(
        child: SelectableText(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        )
    );
  }
}
