import 'dart:io';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/settings/settings_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  File? _image;
  User? _user;
  String expiry = '';
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData().then((user) {
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    });

    _secureStorage.read(key: 'tokenExpiry').then((value) {
      if (value != null) {
        // print('Token EXPIRY DATE: $value');
        setState(() {
          expiry = value;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isUserLoggedIn = Provider.of<UserProvider>(context).isLoggedIn;
    });
  }

  Future<User?> _fetchUserData() async {
    return Provider.of<UserProvider>(
      context,
      listen: false,
    ).fetchUser();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _editProfileImage();
    }
  }

  void _editProfileImage() async {
    if (_image == null || _user == null) return;
    // String fileName = _image!.path.split('/').last;
    // print('FILE NAME ---_> $fileName');
    try {
      CustomResponse response = await Helpers.sendFileRequest(
        context,
        'changeAvatar',
        file: _image!,
        fields: {
          'userId': _user!.id.toString(),
        },
        requireToken: true,
      );

      if (response.statusCode == 200 && response.data['user'] != null) {
        User updatedUser = User.fromJson(response.data['user']);
        // String userJson = json.encode(updatedUser.toJson());
        // print('successgul fresponsse response USER`1`: -> $userJson');
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).updateUser(updatedUser);

        setState(() {
          _user = updatedUser;
        });
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      // print('Error updating profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: const MainAppBar(
        showBackBtn: true,
      ),
      children: [
        const SizedBox(height: 30),
        if (_user != null) ...[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _user != null &&
                      _user?.avatarUrl != null &&
                      _user!.avatarUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(_user!.avatarUrl!),
                    )
                  : Container(
                      width: 160, // Match the size of the CircleAvatar
                      height: 160,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(Style.borderLight),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/icons/profil-arany.svg',
                          // Make sure the SVG fills the container, if necessary
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
              Positioned(
                right: -20,
                bottom: 40,
                child: FloatingActionButton(
                  backgroundColor: const Color(Style.primaryDark),
                  mini: true,
                  onPressed: _pickImage,
                  child: const Icon(
                    Icons.edit,
                    color: Color(Style.white),
                  ),
                ),
              ),
            ],
          ),
          Text(_user != null
              ? _user?.avatarUrl ?? 'Nincs avatar url'
              : 'Nincs user se'),
          const SizedBox(height: 10),
          if (_user != null)
            Text(
              _user!.username.toUpperCase(),
              style: Style.primaryDarkText,
            ),
          const SizedBox(height: 30),
          const SettingsList(),
        ] else
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
