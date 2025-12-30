
// import 'package:flutter/material.dart';
// import 'package:mono/constants/app_color.dart';

// import 'package:mono/models/category_model/category_model.dart';
// import 'package:mono/screens/widgets/popup_card.dart';

// import '../../database/categories_DB/category_db.dart';


// class AddTodoButton extends StatelessWidget {
//  final int selectedindex;
//   const AddTodoButton({Key? key,required this.selectedindex}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: GestureDetector(
//         onTap: () {
          
//           print(selectedindex);
//           if(selectedindex==1){
//             print("income");
//             }else{
//               print("expense");
//             }
//           Navigator.of(context).push(HeroDialogRoute(builder: (context) {
//             return  _AddTodoPopupCard();
//           }));
//         },
//         child: Hero(
//           tag: 'heroAdd',
         
//           child: Material(
//             color: mainHexcolor,
//             elevation: 2,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//             child: const Icon(
//               Icons.add_rounded,
//               size: 56,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// class _AddTodoPopupCard extends StatelessWidget {

//    _AddTodoPopupCard({Key? key}) : super(key: key);
//   final categorycontrol=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Hero(
//           tag: 'heroAdd',
         
//           child: Material(
//             color: mainHexcolor,
//             elevation: 2,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // const TextField(
//                     //   decoration: InputDecoration(
//                     //     hintText: 'Add categories',
//                     //     border: InputBorder.none,
//                     //   ),
//                     //   cursorColor: Colors.white,
//                     // ),
//                    const Text("New Categories",style: TextStyle(
//                      color: Color.fromARGB(255, 225, 218, 218),
//                      fontSize: 17,
//                      fontWeight: FontWeight.bold
//                    ),),
//                     const Divider(
//                       color: Colors.white,
//                       thickness: 0.5,
//                     ),
//                      TextField(
//                       controller: categorycontrol,
//                       decoration: const InputDecoration(
//                         hintText: 'Add category',
//                         border: InputBorder.none,
//                       ),
//                       cursorColor: Colors.white,
//                       maxLines: 5,
//                     ),
//                     const Divider(
//                       color: Colors.white,
//                       thickness: 0.2,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                       final _name = categorycontrol.text;
//                       if(_name.isEmpty){
//                         return;
//                       }
             
//                   final  _catego= CategoryModel(
//                     id: DateTime.now().microsecondsSinceEpoch.toString(), 
//                      type: CategoryType.expense, 
//                     name: _name);
//                             CategoryDB().insertCategory(_catego);
//                             Navigator.of(context).pop();
//                       },
//                       child: const Text('Add',style: TextStyle(
//                         color: Colors.white
//                       ),),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }