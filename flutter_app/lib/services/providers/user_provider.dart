import 'package:flutter/widgets.dart';
import 'package:matrimony_app/services/functions/user_management/userManagementApi.dart';
import 'package:matrimony_app/utils/ui_helpers.dart';

class UserProvider extends ChangeNotifier{
  final UserApiService _userApiService = UserApiService();
  List<Map<String, dynamic>>? _users;
  List<Map<String, dynamic>>? _favUsers;
  bool _isLoading = false;

  List<Map<String, dynamic>>? get users => _users;
  List<Map<String, dynamic>>? get favUsers => _favUsers;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers({required BuildContext context, bool forceRefresh = false}) async {
    if(_users!=null && !forceRefresh) return;
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();  // Defer update until next frame
    });

    try{
      _users = await _userApiService.getUsers(context);
    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();

  }

  Future<void> fetchFavouriteUsers({required BuildContext context, bool forceRefresh = false}) async {
    if(_favUsers!=null && !forceRefresh) return;
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();  // Defer update until next frame
    });

    try{
    _favUsers = await _userApiService.getFavouriteUsers(context);
    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();

  }

  Future<void> toggleFavourite({required BuildContext context , required String userId}) async {
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();  // Defer update until next frame
    });

    try{
      await _userApiService.toggleFavourite(userId: userId, context: context);

      _users = null;
      _favUsers = null;

      await fetchUsers(context: context ,forceRefresh: true);
      await fetchFavouriteUsers(context: context, forceRefresh: true);
    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUser({required BuildContext context , required String userId}) async {
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();  // Defer update until next frame
    });

    try{
      await _userApiService.deleteUser(userId: userId, context: context);

      _users = null;
      _favUsers = null;

      await fetchUsers(context: context ,forceRefresh: true);
      await fetchFavouriteUsers(context: context, forceRefresh: true);

    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser({required BuildContext context , required Map<String, dynamic> user}) async {
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();  // Defer update until next frame
    });

    try{
      //TODO:

      await _userApiService.addUser(user: user, context: context);

      _users = null;
      _favUsers = null;

      await fetchUsers(context: context ,forceRefresh: true);
      await fetchFavouriteUsers(context: context, forceRefresh: true);

    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser({required BuildContext context , required Map<String, dynamic> user}) async {
    _isLoading = true;

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    try{

      await _userApiService.updateUser(user: user, context: context);

      _users = null;
      _favUsers = null;

      await fetchUsers(context: context ,forceRefresh: true);
      await fetchFavouriteUsers(context: context, forceRefresh: true);

    }catch(error){
      handleErrors(context, error.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

}