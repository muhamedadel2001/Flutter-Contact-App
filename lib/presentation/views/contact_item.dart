import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_contact/business_logic/app_cubit.dart';
import 'package:simple_contact/presentation/styles/colors.dart';
import 'package:simple_contact/presentation/views/update_contact_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final Map contactModel;
  const ContactItem({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
     // key: Key(contactModel['id'].toString()),
      key: UniqueKey(),
      onDismissed: (direction) async {
        await AppCubit.get(context).deleteContact(id: contactModel['id']);
        Fluttertoast.showToast(
            msg: "Contact deleted !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      child: InkWell(
        onTap: (){
          Fluttertoast.showToast(
              msg: "Long touch:Update contact \nSwipe:Delete contact\nDouble tap:call contact from tel",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightPurple,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        onDoubleTap: () async{
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: contactModel['phoneNumber'],
          );
          await launchUrl(launchUri);
        },
        onLongPress: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => UpdateContactDialog(
                    contactModel: contactModel,
                  ));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.sp),
              gradient: const LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [lightPurple, Colors.black, lightPurple])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 2.w),
                      child: Text(
                        '${contactModel['name']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${contactModel['phoneNumber']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: contactModel['type'] == 'favourite',
                replacement: IconButton(
                    onPressed: () => AppCubit.get(context).addOrRemoveFavourite(
                        type: 'favourite', id: contactModel['id']),
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                    )),
                child: IconButton(
                    onPressed: () => AppCubit.get(context).addOrRemoveFavourite(
                        type: 'all', id: contactModel['id']),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
