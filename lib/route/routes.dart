import 'package:get/get.dart';
import 'package:table_now_store/binding/notice/save_notice_binding.dart';
import 'package:table_now_store/binding/store/basic_binding.dart';
import 'package:table_now_store/binding/store/delete_store_binding.dart';
import 'package:table_now_store/binding/store/holidays_binding.dart';
import 'package:table_now_store/binding/store/hours_binding.dart';
import 'package:table_now_store/binding/store/inside_binding.dart';
import 'package:table_now_store/binding/store/main_binding.dart';
import 'package:table_now_store/binding/store/menu_binding.dart';
import 'package:table_now_store/binding/user/change_pw_binding.dart';
import 'package:table_now_store/binding/user/find_binding.dart';
import 'package:table_now_store/binding/user/join_binding.dart';
import 'package:table_now_store/binding/user/login_binding.dart';
import 'package:table_now_store/ui/image_page.dart';
import 'package:table_now_store/ui/join/agreement/agreement_page.dart';
import 'package:table_now_store/ui/join/agreement/privacy_policy_page.dart';
import 'package:table_now_store/ui/join/agreement/terms_conditions_page.dart';
import 'package:table_now_store/ui/join/auth/auth_page.dart';
import 'package:table_now_store/ui/join/auth/iamport_page.dart';
import 'package:table_now_store/ui/join/join_page.dart';
import 'package:table_now_store/ui/join/join_success_page.dart';
import 'package:table_now_store/ui/login/find/find_id/find_id_page.dart';
import 'package:table_now_store/ui/login/find/find_id/find_id_result_page.dart';
import 'package:table_now_store/ui/login/find/find_page.dart';
import 'package:table_now_store/ui/login/find/find_pw/find_pw_fail_page.dart';
import 'package:table_now_store/ui/login/find/find_pw/find_pw_page.dart';
import 'package:table_now_store/ui/login/find/find_pw/reset_pw_page.dart';
import 'package:table_now_store/ui/login/login_page.dart';
import 'package:table_now_store/ui/main_page.dart';
import 'package:table_now_store/ui/manage/manage_page.dart';
import 'package:table_now_store/ui/manage/notice/update_notice_page.dart';
import 'package:table_now_store/ui/manage/notice/write_notice_page.dart';
import 'package:table_now_store/ui/manage/store_info/basic_info_page.dart';
import 'package:table_now_store/ui/manage/store_info/delete_store_page.dart';
import 'package:table_now_store/ui/manage/store_info/holidays_info_page.dart';
import 'package:table_now_store/ui/manage/store_info/hours_info_page.dart';
import 'package:table_now_store/ui/manage/store_info/inside_info_page.dart';
import 'package:table_now_store/ui/manage/store_info/menu_info_page.dart';
import 'package:table_now_store/ui/manage/today/change_today_page.dart';

abstract class Routes {
  /* 로그인 & 회원찾기 */
  static const login = '/login';
  static const find = '/find';
  static const findId = '/find_id';
  static const findIdResult = '/find_id_result';
  static const findPw = '/find_pw';
  static const findPwFail = '/find_pw_fail';
  static const resetPw = '/reset_pw';

  /* 회원가입 */
  static const agreement = '/agreement';
  static const termsConditions = '/terms_conditions';
  static const privacyPolicy = '/privacy_policy';
  static const auth = '/auth';
  static const iamport = '/iamport';
  static const join = '/join';
  static const joinSuccess = '/join_success';

  /* 메인화면 */
  static const main = '/main';

  /* 이미지 */
  static const image = '/image';

  /* 매장관리 */
  static const manage = '/manage';
  static const changeToday = '/change_today';
  static const hoursInfo = '/hours_info';
  static const holidaysInfo = '/holidays_info';
  static const menuInfo = '/menu_info';
  static const insideInfo = '/inside_info';
  static const basicInfo = '/basic_info';
  static const deleteStore = '/delete_store';

  /* 매장알림 */
  static const writeNotice = '/write_notice';
  static const updateNotice = '/update_notice';
}

class Pages {
  static final routes = [
    /* 로그인 & 회원찾기 */
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.find,
      page: () => FindPage(),
      binding: FindBinding(),
    ),
    GetPage(
      name: Routes.findId,
      page: () => FindIdPage(),
      binding: FindBinding(),
    ),
    GetPage(
      name: Routes.findIdResult,
      page: () => FindIdResultPage(),
    ),
    GetPage(
      name: Routes.findPw,
      page: () => FindPwPage(),
      binding: FindBinding(),
    ),
    GetPage(
      name: Routes.findPwFail,
      page: () => FindPwFailPage(),
    ),
    GetPage(
      name: Routes.resetPw,
      page: () => ResetPwPage(),
      binding: ChangePwBinding(),
    ),
    /* 회원가입 */
    GetPage(
      name: Routes.agreement,
      page: () => const AgreementPage(),
      binding: JoinBinding(),
    ),
    GetPage(
      name: Routes.termsConditions,
      page: () => TermsConditionsPage(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => PrivacyPolicyPage(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => AuthPage(),
    ),
    GetPage(
      name: Routes.iamport,
      page: () => IamportPage(),
    ),
    GetPage(
      name: Routes.join,
      page: () => JoinPage(),
      binding: JoinBinding(),
    ),
    GetPage(
      name: Routes.joinSuccess,
      page: () => const JoinSuccessPage(),
    ),
    /* 메인화면 */
    GetPage(
      name: Routes.main,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
    /* 이미지 */
    GetPage(
      name: Routes.image,
      page: () => const ImagePage(),
    ),
    /* 매장관리 */
    GetPage(
      name: Routes.manage,
      page: () => ManagePage(),
    ),
    GetPage(
      name: Routes.changeToday,
      page: () => ChangeTodayPage(),
    ),
    GetPage(
      name: Routes.hoursInfo,
      page: () => HoursInfoPage(),
      binding: HoursBinding(),
    ),
    GetPage(
      name: Routes.holidaysInfo,
      page: () => HolidaysInfoPage(),
      binding: HolidaysBinding(),
    ),
    GetPage(
      name: Routes.menuInfo,
      page: () => MenuInfoPage(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: Routes.insideInfo,
      page: () => InsideInfoPage(),
      binding: InsideBinding(),
    ),
    GetPage(
      name: Routes.basicInfo,
      page: () => BasicInfoPage(),
      binding: BasicBinding(),
    ),
    GetPage(
      name: Routes.deleteStore,
      page: () => DeleteStorePage(),
      binding: DeleteStoreBinding(),
    ),
    /* 매장알림 */
    GetPage(
      name: Routes.writeNotice,
      page: () => WriteNoticePage(),
      binding: SaveNoticeBinding(),
    ),
    GetPage(
      name: Routes.updateNotice,
      page: () => UpdateNoticePage(),
      binding: SaveNoticeBinding(),
    ),
  ];
}
