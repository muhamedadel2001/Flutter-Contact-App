import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_contact/presentation/styles/colors.dart';
import 'package:simple_contact/presentation/widgets/default_form_field.dart';
import 'package:simple_contact/presentation/widgets/phone_form_field.dart';
import 'package:sizer/sizer.dart';
import '../../../business_logic/app_cubit.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late AppCubit cubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namedController = TextEditingController();
  final TextEditingController _phonedController = TextEditingController();
  CountryCode myCountryCode = CountryCode(name: 'EG', dialCode: '+20');


  @override
  void didChangeDependencies() {
    cubit = AppCubit.get(context);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppInsertContactsState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: blackHome,
            centerTitle: true,
            elevation: 10,
            title: Text(
              cubit.texts[cubit.currentIndex],
              style: TextStyle(
                color: lightPurple,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    blackHome,
                    Colors.black87,
                    blackHome,
                  ],
                )),
              ),
              BlocBuilder<AppCubit, AppState>(
                builder: (BuildContext context, state) {
                  if(state is AppLoadingGetContactsState||state is AppLoadingGetContactsFavouriteState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: darkBlue,

                      ),
                    );
                  }
                  else{
                    return cubit.screens[cubit.currentIndex];
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isBottomSheetShown) {
                  if (_formKey.currentState!.validate()) {
                    await cubit.insertToAccount(
                      codeLength: myCountryCode.dialCode!.length,

                        name: _namedController.text,
                        phoneNumber:
                            '${myCountryCode.dialCode}${_phonedController.text}');
                    print(myCountryCode.dialCode!.length);


                    _namedController.text = '';
                    _phonedController.text = '';
                  }
                } else {
                  _scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Wrap(
                          children: [
                            Container(
                              color: blackHome,
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 2.w, vertical: 2.h),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 2.h),
                                      child: DefaultFormField(
                                        controller: _namedController,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "name can't be empty";
                                          }
                                          return null;
                                        },
                                        textColor: lightPurple,
                                        prefixIcon: const Icon(
                                          Icons.title,
                                          color: lightPurple,
                                        ),
                                        hintText: 'Contact Name',
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                          color: lightPurple,
                                        )),
                                      ),
                                    ),
                                    DefaultPhoneFormField(
                                      controller: _phonedController,
                                      textColor: lightPurple,
                                      labelText: 'Contact phone number',
                                      labelColor: Colors.grey,
                                      labelSize: 12.sp,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: lightPurple,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Phone number can't be empty";
                                        }
                                        return null;
                                      },
                                      onChange: (value) {
                                        myCountryCode = value;


                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .closed
                      .then(
                        (value) => cubit.changeBottomSheetState(
                            isShown: false, icon: Icons.person_add),
                      );
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              backgroundColor: blackHome,
              child: Icon(
                cubit.floatingActionButton,
                color: Colors.grey,
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: blackHome,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: lightPurple,
                unselectedItemColor: Colors.grey,
                elevation: 0,
                currentIndex: cubit.currentIndex,
                onTap: (index) => cubit.changeIndex(index),
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.contacts), label: cubit.texts[0]),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.favorite), label: cubit.texts[1]),
                ]),
          ),
        );
      },
    );
  }
}
