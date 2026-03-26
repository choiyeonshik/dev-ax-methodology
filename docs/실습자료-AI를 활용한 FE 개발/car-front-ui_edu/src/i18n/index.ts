/**
 * 다국어 설정
 */
import i18n from "i18next";
import { initReactI18next } from "react-i18next";

// 다국어 리소스
const resources = {
  ko: {
    translation: {
      // 공통
      common: {
        loading: "로딩 중...",
        error: "오류가 발생했습니다.",
        success: "성공했습니다.",
        cancel: "취소",
        confirm: "확인",
        save: "저장",
        delete: "삭제",
        edit: "수정",
        add: "추가",
        search: "검색",
        close: "닫기",
      },
      // 인증
      auth: {
        login: "로그인",
        logout: "로그아웃",
        email: "이메일",
        password: "비밀번호",
        loginSuccess: "로그인 성공",
        loginFailed: "로그인 실패",
        logoutSuccess: "로그아웃 성공",
      },
      // 네비게이션
      navigation: {
        home: "홈",
        dashboard: "대시보드",
        users: "사용자 관리",
        settings: "설정",
      },
    },
  },
  en: {
    translation: {
      // Common
      common: {
        loading: "Loading...",
        error: "An error occurred.",
        success: "Success.",
        cancel: "Cancel",
        confirm: "Confirm",
        save: "Save",
        delete: "Delete",
        edit: "Edit",
        add: "Add",
        search: "Search",
        close: "Close",
      },
      // Authentication
      auth: {
        login: "Login",
        logout: "Logout",
        email: "Email",
        password: "Password",
        loginSuccess: "Login successful",
        loginFailed: "Login failed",
        logoutSuccess: "Logout successful",
      },
      // Navigation
      navigation: {
        home: "Home",
        dashboard: "Dashboard",
        users: "User Management",
        settings: "Settings",
      },
    },
  },
};

i18n.use(initReactI18next).init({
  resources,
  lng: "ko", // 기본 언어
  fallbackLng: "ko",
  interpolation: {
    escapeValue: false, // React는 이미 XSS를 방지하므로 false
  },
});

export default i18n;
