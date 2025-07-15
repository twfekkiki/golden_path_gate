import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/widget/customer_card.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/widget/filter_shipments.dart';
import 'package:provider/provider.dart';

import 'get_customers_list_provider.dart';

class SelectCustomerView extends StatefulWidget {

  static show(BuildContext context){
    return showDialog(context: context, builder: (context){
      return SelectCustomerView();
    });
  }

  const SelectCustomerView({super.key});

  @override
  State<SelectCustomerView> createState() => _SelectCustomerViewState();
}

class _SelectCustomerViewState extends State<SelectCustomerView> {

  final GetCustomersListProvider getCustomersListProvider = GetCustomersListProvider();

  @override
  void initState() {
    getCustomersListProvider.getCustomersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius)
      ),
      child: SizedBox(
        width: 500,
        child: ChangeNotifierProvider<GetCustomersListProvider>.value(
            value: getCustomersListProvider,
            child: Consumer<GetCustomersListProvider>(
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
                                      fontSize: 20,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(width: 12,),
                                Expanded(
                                    child: FilterItem(
                                      onSubmit: (key , value ) {
                                        getCustomersListProvider.getCustomersList(searchKey: value);
                                      },
                                      title: 'Search',
                                      type: 'text-field',
                                      filterKey: 'customerName',
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Expanded(
                        child: LayoutBuilder(
                            builder: (context,constrains) {
                              int rowChildCount = 4;
                              // print(constrains.maxWidth);
                              if(constrains.maxWidth < 820){
                                rowChildCount = 3;
                              }
                              if(constrains.maxWidth < 620){
                                rowChildCount = 2;
                              }
                              if(constrains.maxWidth < 420){
                                rowChildCount = 1;
                              }

                              return ListView.separated(
                                padding: EdgeInsets.all(16),
                                separatorBuilder: (context,index){
                                  return const SizedBox(height: 8,);
                                },
                                itemBuilder: (context,index){
                                  return InkWell(
                                      onTap: (){
                                        Navigator.of(context).pop(customers[index]);
                                      },
                                      child: CustomerCard(customer: customers[index],));
                                },
                                itemCount: customers.length,
                              );
                            }
                        ),
                      ),
                    ],
                  );
                }
            )
        ),
      ),
    );
  }
}
