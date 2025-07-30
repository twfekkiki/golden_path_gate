import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/user.dart';
import 'package:golden_path_gate_admin_portal/pages/users/widget/user_card.dart';
import 'package:provider/provider.dart';

import 'get_users_list_provider.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final GetUsersListProvider getCustomersListProvider = GetUsersListProvider();


  @override
  void initState() {
    getCustomersListProvider.getUsersList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetUsersListProvider>.value(
      value: getCustomersListProvider,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
          body: Consumer<GetUsersListProvider>(
            builder: (context,snapshot,child) {
              if(snapshot.users == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<PortalUser> users = snapshot.users!;
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context).trans("userList"),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                     context.go('/user-list/create');
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // if(_showFilter)
                        //   Padding(
                        //     padding: const EdgeInsets.only(
                        //         top: 12
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Expanded(child: FilterCustomers()),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context,constrains) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16
                              ),
                              child: Row(
                                children: [
                                  _getHeader("UID"),
                                  _getHeader(AppLocalizations.of(context).trans("username")),
                                  _getHeader(AppLocalizations.of(context).trans("role")),
                                  SizedBox(width: 80,height: 50,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.all(16),
                                itemBuilder: (context,index){
                                  return UserCard(
                                    user: users[index],
                                    onDelete: () {  },
                                    onEdit: () {  },
                                  );},
                                itemCount: users.length,
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider(
                                    height: 24,
                                    color: Theme.of(context).dividerColor.withAlpha(100),
                                    thickness: 0.8,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
              );
            }
          )
      ),
    );
  }

  _getHeader(String label){
    return Expanded(
        child: SelectableText(
          label,
          style: Theme.of(context).textTheme.headlineSmall!
              .copyWith(
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
}
