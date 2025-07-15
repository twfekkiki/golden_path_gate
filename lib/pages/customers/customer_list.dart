import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/widget/customer_card.dart';
import 'package:provider/provider.dart';

import 'get_customers_list_provider.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {

  bool _showFilter = false;

  final GetCustomersListProvider getCustomersListProvider = GetCustomersListProvider();


  @override
  void initState() {
    getCustomersListProvider.getCustomersList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetCustomersListProvider>.value(
      value: getCustomersListProvider,
      child: Scaffold(
          body: Consumer<GetCustomersListProvider>(
            builder: (context,snapshot,child) {
              if(snapshot.customers == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Customer> customers = snapshot.customers!;
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
                              "Customers List",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.primary,
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
                                     context.go('/customers-list/create');
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),

                                  ),
                                ),
                                const SizedBox(width: 12,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _showFilter = !_showFilter;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.filter_alt_outlined,
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
                        int rowChildCount = 4;
                        print(constrains.maxWidth);
                        if(constrains.maxWidth < kLargeSize){
                          rowChildCount = 3;
                        }
                        if(constrains.maxWidth < kMidSize){
                          rowChildCount = 2;
                        }
                        if(constrains.maxWidth < kSmallSize){
                          rowChildCount = 1;
                        }

                        return GridView.builder(
                          padding: EdgeInsets.all(16),
                          itemBuilder: (context,index){
                            return CustomerCard(customer: customers[index],);
                            },
                          itemCount: customers.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: rowChildCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2
                          ),
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
}
