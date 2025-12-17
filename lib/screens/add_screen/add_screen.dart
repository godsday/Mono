import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono/constants/colors/app_color.dart';
import 'package:mono/constants/utils/app_textstyle.dart';
import 'package:mono/constants/utils/extension/app_extension.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/add_screen/decoration_functions.dart';
import 'package:mono/screens/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/screens/widgets/add_clipper.dart';
import 'package:mono/database/categories_DB/category_db.dart';
import 'package:mono/models/category_model/category_model.dart';


class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<dynamic> transcationType = [];
  List<dynamic> categorieslist = [];
  List<dynamic> categories = [];
  String? selectedValue;
  String? transctiontypeid;
  String? categoryid;
  final amountcontrol = TextEditingController();
  final notescontrol = TextEditingController();

  DateTime selectedDate = DateTime.now();

  final _formkey = GlobalKey<FormState>();

  // Helper method to get a valid category for the dropdown
  String? _getValidCategory(AppState provider) {
    // If no category is selected, return null to show the hint
    if (provider.categorySelected == null || provider.categorySelected!.isEmpty) {
      return null;
    }
    
    return provider.categorySelected;
  }

  // Method to show dialog for adding custom categories
  void _showAddCategoryDialog(BuildContext context, AppState provider) async {
    final categoryNameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Custom Category',
            style: AppTextStyles.montserrat18w600.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a name for your new category',
                style: AppTextStyles.poppins16w400.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 1.h),
              TextField(
                controller: categoryNameController,
                decoration: textfielddecor("Category name"),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.poppins16w400.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String categoryName = categoryNameController.text.trim();
                final data = categoryName.capitalizeFirstLetter().toString();
                print(data);
                if (categoryName.isEmpty) {
                  // Show error if category name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnak(context, message: "Category name cannot be empty")
                  );
                  return;
                }
                
                // Check if category already exists
                final allCategories = await CategoryDB.instance.getCategories();
                bool categoryExists = allCategories.any((category) => 
                  category.name.toLowerCase() == categoryName.toLowerCase() && 
                  ((provider.selectedType == "Income" && category.type == CategoryType.income) ||
                   (provider.selectedType == "Expense" && category.type == CategoryType.expense)));
                
                if (categoryExists) {
                  // Show error if category already exists
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnak(context, message: "Category '$categoryName' already exists")
                  );
                  return;
                }
                
                // Add to database
                final newCategory = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: provider.selectedType == "Income" ? CategoryType.income : CategoryType.expense,
                  name: categoryName.capitalizeFirstLetter()
                );
                
                await CategoryDB.instance.insertCategory(newCategory);
                
                // Select the newly added category
                provider.categorySelected = categoryName.capitalizeFirstLetter();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.mainHexcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.poppins16w400.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            
            clipBehavior: Clip.none,
            children: [
              SizedBox(height: 90.h),
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: Theme.of(context).dividerColor,
                  height: 40.h,
                ),
              ),
            
               
              Positioned(
                top: 5.h,
                left: 26.w,
                child: Text(
                  "Add Transcations",
                  style: AppTextStyles.montserrat18w600.copyWith(
                 color: Colors.white
                  ),
                ),
              ),
              Positioned(
                  top: 2.h,
                  left: 13.w,
                  child: Image(
                    width: 47.w,
                    image: AssetImage(
                      'assets/images/rings.png',
                    ),
                  )),
              Positioned(
                top: 16.h,
                left: 5.0.w,
                child: Container(
                  width: 90.0.w,
                  height: 75.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(255, 241, 234, 234)
                                .withOpacity(1),
                            blurRadius: 5)
                      ]),
                  child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transcation type',style: AppTextStyles.poppins16w400,),
                            SizedBox(
                              height: .5.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<AppState>(
                                builder: (context, provider, child) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Radio.adaptive(
                                          groupValue: provider.selectedType,
                                          value: "Expense",
                                          onChanged: (String? value) {
                                            provider.selectedType = value!;
                                            // Clear category selection when switching type
                                            provider.categorySelected = null;
                                          }),
                                      Text("Expense",style: AppTextStyles.poppins16w400.copyWith(
                                        color: Colors.blueGrey.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp
                                      ),),
                                      SizedBox(
                                        width: 20.sp,
                                      ),
                                      Radio.adaptive(
                                          groupValue: provider.selectedType,
                                          value: "Income",
                                          onChanged: (String? value) {
                                            provider.selectedType = value!;
                                            // Clear category selection when switching type
                                            provider.categorySelected = null;
                                          }),
                                      Text("Income",style: AppTextStyles.poppins16w400.copyWith(
                                        color: Colors.blueGrey.shade700, fontWeight: FontWeight.w600,fontSize: 16.sp
                                      ),),
                                    ]),
                              ),
                            ),
                        
                         
                            SizedBox(
                              height: 1.h,
                            ),
                            Text('Amount',style: AppTextStyles.poppins16w400,),
                            SizedBox(
                              height: .5.h,
                            ),
                            TextFormField(autovalidateMode: AutovalidateMode.onUnfocus,
                              autofocus: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return ' Enter a valid number';
                                }
                                return null;
                              },
                              controller: amountcontrol,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: textfielddecor("Enter Amount"),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text('Date',style: AppTextStyles.poppins16w400,),
                            SizedBox(
                              height: .5.h,
                            ),
                            Consumer<AppState>(
                              builder: (context, provider, child) =>
                                  InkWell(
                                onTap: () async {
                                  final date =
                                      await provider.pickDate(context);
                                  if (date == null) return;
                        
                                  provider.selectedDate = date;
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dialogBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                                    child: Row(
                                      children: [
                                         Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${provider.selectedDate.day} / ${provider.selectedDate.month} / ${provider.selectedDate.year}',
                                          style: AppTextStyles.montserrat18w600.copyWith(
                                            color: Colors.grey.shade700,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              
                           
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text('Categories',style: AppTextStyles.poppins16w400,),
                            SizedBox(
                              height: .5.h,
                            ),
                            Consumer<AppState>(
                              builder: (context, provider, child) =>
                                  FutureBuilder<List<CategoryModel>>(
                                    future: CategoryDB.instance.getCategories(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      
                                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return const Text('No categories available');
                                      }
                                      
                                      // Filter categories based on selected transaction type
                                      final categories = snapshot.data!
                                          .where((category) => 
                                              (provider.selectedType == "Income" && category.type == CategoryType.income) ||
                                              (provider.selectedType == "Expense" && category.type == CategoryType.expense))
                                          .toList();
                                      
                                      return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButton<String>(
                                                value: _getValidCategory(provider),
                                                icon: Icon(Icons.arrow_drop_down_sharp,size: 20.sp,),
                                                elevation: 0,
                                                underline: const SizedBox(),
                                                menuMaxHeight: 220.sp,
                                                iconEnabledColor: AppColor.mainHexcolor,
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                isExpanded: true,
                                                autofocus: true,
                                                hint: Text('Select Category',style: AppTextStyles.montserrat18w600.copyWith(
                                                    color: AppColor.textGrey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),),
                                                onChanged: (String? value) {
                                                  if (value != null) {
                                                    provider.categorySelected = value;
                                                  }
                                                },
                                                items: categories
                                                    .map<DropdownMenuItem<String>>(
                                                        (CategoryModel category) {
                                                    return DropdownMenuItem<String>(
                                                      value: category.name,
                                                      child: Text(category.name),
                                                    );
                                                  }).toList(),
                                               
                                              ),
                                            ),
                                            IconButton(
                                              style: ButtonStyle(
                                                elevation: WidgetStateProperty.all(3),
                                                backgroundColor: WidgetStateProperty.all(AppColor.mainHexcolor),
                                              ),
                                              icon: Icon(Icons.add, 
                                                color: Colors.white,),
                                              onPressed: () {
                                                _showAddCategoryDialog(context, provider);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                            ),
                        
                                   SizedBox(
                              height: 1.5.h,
                            ),
                            Text('Notes',style: AppTextStyles.poppins16w400,),
                            SizedBox(
                              height: .5.h,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              controller: notescontrol,
                              keyboardType: TextInputType.text,
                              decoration: textfielddecor('Enter Notes'),
                              maxLines: 2,
                            ),
                            SizedBox(height: 3.5.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Validate form before submitting
                                  if (_formkey.currentState!.validate()) {
                                    // Check if category is selected
                                    final provider = Provider.of<AppState>(context, listen: false);
                                    if (provider.categorySelected == null || provider.categorySelected!.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        customSnak(context, message: "Please select a category")
                                      );
                                      return;
                                    }
                                     
                                    Provider.of<AppState>(context, listen: false)
                                        .addtransbutton(context, amountcontrol, notescontrol);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Theme.of(context).primaryColorLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                                child: Text(
                                  'Record',
                                  style: AppTextStyles.poppins18w500White(context)?.copyWith(fontSize: 17.sp),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    amountcontrol.dispose();
    notescontrol.dispose();
    Provider.of<AppState>(context, listen: false).categorySelected = "";
    super.dispose();
  }
}