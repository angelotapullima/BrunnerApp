import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/data_user_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = ProviderBloc.user(context);
    userBloc.obtenerUser();
    return StreamBuilder<UserModel>(
      stream: userBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setHeight(80),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/img/icon_brunner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setHeight(80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: '${snapshot.data!.userImage}',
                    //imageUrl: '',
                    placeholder: (context, url) => const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/img/icon_brunner.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Text(
                snapshot.data!.personName.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.017,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Text(
                snapshot.data!.roleName.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.017,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
