import 'package:get/get.dart';
import 'package:table_now_store/binding/notice/save_notice_binding.dart';
import 'package:table_now_store/binding/store/basic_binding.dart';
import 'package:table_now_store/binding/store/delete_store_binding.dart';
import 'package:table_now_store/binding/store/holidays_binding.dart';
import 'package:table_now_store/binding/store/hours_binding.dart';
import 'package:table_now_store/binding/store/inside_binding.dart';
import 'package:table_now_store/binding/store/main_binding.dart';
import 'package:table_now_store/binding/store/menu_binding.dart';
import 'package:table_now_store/binding/user/change_email_binding.dart';
import 'package:table_now_store/binding/user/change_pw_binding.dart';
import 'package:table_now_store/binding/user/find_binding.dart';
import 'package:table_now_store/binding/user/join_binding.dart';
import 'package:table_now_store/binding/user/login_binding.dart';
import 'package:table_now_store/binding/user/withdrawal_binding.dart';
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
import 'package:table_now_store/ui/mypage/app_notice/app_notice_page.dart';
import 'package:table_now_store/ui/mypage/customer_service/customer_service_page.dart';
import 'package:table_now_store/ui/mypage/customer_service/faq_page.dart';
import 'package:table_now_store/ui/mypage/extra/extra_page.dart';
import 'package:table_now_store/ui/mypage/extra/license_page.dart';
import 'package:table_now_store/ui/mypage/help/help_page.dart';
import 'package:table_now_store/ui/mypage/policy/location_terms_page.dart';
import 'package:table_now_store/ui/mypage/policy/policy_page.dart';
import 'package:table_now_store/ui/mypage/policy/privacy_policy_page2.dart';
import 'package:table_now_store/ui/mypage/policy/terms_conditions_page2.dart';
import 'package:table_now_store/ui/mypage/profile/change_email_page.dart';
import 'package:table_now_store/ui/mypage/profile/change_phone_page.dart';
import 'package:table_now_store/ui/mypage/profile/change_pw_page.dart';
import 'package:table_now_store/ui/mypage/profile/profile_page.dart';
import 'package:table_now_store/ui/mypage/profile/withdrawal_page.dart';
import 'package:table_now_store/ui/register/check_registered_page.dart';
import 'package:table_now_store/ui/register/criteria_page.dart';
import 'package:table_now_store/ui/register/enter_basic_page.dart';
import 'package:table_now_store/ui/register/enter_holidays_page.dart';
import 'package:table_now_store/ui/register/enter_hours_page.dart';
import 'package:table_now_store/ui/register/enter_inside_page.dart';
import 'package:table_now_store/ui/register/enter_menu_page.dart';

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

  /* 매장등록 */
  static const checkRegistered = '/check_registered';
  static const criteria = '/criteria';
  static const enterBasic = '/enter_basic';
  static const enterInside = '/enter_inside';
  static const enterMenu = '/enter_menu';
  static const enterHolidays = '/enter_holidays';
  static const enterHours = '/enter_hours';

  /* 내정보 */
  static const profile = '/profile';
  static const changePw = '/change_pw';
  static const changePhone = '/change_phone';
  static const changeEmail = '/change_email';
  static const withdrawal = '/withdrawal';
  static const appNotice = '/app_notice';
  static const help = '/help';
  static const customerService = '/customer_service';
  static const faq = '/faq';
  static const policy = '/policy';
  static const termsConditions2 = '/terms_conditions2';
  static const privacyPolicy2 = '/privacy_policy2';
  static const locationTerms = '/location_terms';
  static const extra = '/extra';
  static const license = '/license';
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
      page: () => const AuthPage(),
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
    /* 매장등록 */
    GetPage(
      name: Routes.checkRegistered,
      page: () => CheckRegisteredPage(),
      binding: BasicBinding(),
    ),
    GetPage(
      name: Routes.criteria,
      page: () => const CriteriaPage(),
    ),
    GetPage(
      name: Routes.enterBasic,
      page: () => EnterBasicPage(),
      binding: BasicBinding(),
    ),
    GetPage(
      name: Routes.enterInside,
      page: () => EnterInsidePage(),
      binding: InsideBinding(),
    ),
    GetPage(
      name: Routes.enterMenu,
      page: () => EnterMenuPage(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: Routes.enterHolidays,
      page: () => EnterHolidaysPage(),
      binding: HolidaysBinding(),
    ),
    GetPage(
      name: Routes.enterHours,
      page: () => EnterHoursPage(),
      binding: HoursBinding(),
    ),
    /* 내정보 */
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.changePw,
      page: () => ChangePwPage(),
      binding: ChangePwBinding(),
    ),
    GetPage(
      name: Routes.changePhone,
      page: () => ChangePhonePage(),
      // binding: ChangePhoneBinding(),
    ),
    GetPage(
      name: Routes.changeEmail,
      page: () => ChangeEmailPage(),
      binding: ChangeEmailBinding(),
    ),
    GetPage(
      name: Routes.withdrawal,
      page: () => WithdrawalPage(),
      binding: WithdrawalBinding(),
    ),
    GetPage(
      name: Routes.appNotice,
      page: () => const AppNoticePage(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpPage(),
    ),
    GetPage(
      name: Routes.customerService,
      page: () => const CustomerServicePage(),
    ),
    GetPage(
      name: Routes.faq,
      page: () => const FAQPage(),
    ),
    GetPage(
      name: Routes.policy,
      page: () => const PolicyPage(),
    ),
    GetPage(
      name: Routes.termsConditions2,
      page: () => const TermsConditionsPage2(),
    ),
    GetPage(
      name: Routes.privacyPolicy2,
      page: () => const PrivacyPolicyPage2(),
    ),
    GetPage(
      name: Routes.locationTerms,
      page: () => const LocationTermsPage(),
    ),
    GetPage(
      name: Routes.extra,
      page: () => const ExtraPage(),
    ),
    GetPage(
      name: Routes.license,
      page: () => const LicensePage(),
    ),
  ];
}
