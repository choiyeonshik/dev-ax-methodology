/**
 * 인증 관련 API 서비스
 */
import { apiService } from "./apiService";
import type {
  ILoginRequest,
  ILoginResponse,
  IRegisterRequest,
  IRegisterResponse,
  IRefreshTokenRequest,
  IRefreshTokenResponse,
  IChangePasswordRequest,
  IResetPasswordRequest,
  IPasswordResetResponse,
  IVerifyEmailRequest,
  IEmailVerificationResponse,
  ILogoutResponse,
  ISuccessResponse,
} from "../types/auth";

class AuthService {
  private readonly baseUrl = "/auth";

  /**
   * 로그인
   */
  async login(loginData: ILoginRequest): Promise<ILoginResponse> {
    try {
      const response = await apiService.post<ILoginResponse>(
        `${this.baseUrl}/login`,
        loginData
      );
      console.log(response);

      // 로그인 API는 예외적으로 바로 응답 데이터가 리턴됨
      const loginResponse = response.data || response;

      // accessToken이 있으면 localStorage에 저장
      if (loginResponse.accessToken) {
        localStorage.setItem("token", loginResponse.accessToken);
      }

      return loginResponse;
    } catch (error) {
      console.error("로그인 실패:", error);
      throw error;
    }
  }

  /**
   * 회원가입
   */
  async register(registerData: IRegisterRequest): Promise<IRegisterResponse> {
    try {
      const response = await apiService.post<IRegisterResponse>(
        `${this.baseUrl}/register`,
        registerData
      );
      return response.data;
    } catch (error) {
      console.error("회원가입 실패:", error);
      throw error;
    }
  }

  /**
   * 로그아웃
   */
  async logout(): Promise<ILogoutResponse> {
    try {
      const response = await apiService.post<ILogoutResponse>(
        `${this.baseUrl}/logout`
      );

      // 로그아웃 시 토큰 제거
      localStorage.removeItem("token");

      return response.data;
    } catch (error) {
      console.error("로그아웃 실패:", error);
      // 에러가 발생해도 토큰은 제거
      localStorage.removeItem("token");
      throw error;
    }
  }

  /**
   * 토큰 갱신
   */
  async refreshToken(
    refreshTokenData: IRefreshTokenRequest
  ): Promise<IRefreshTokenResponse> {
    try {
      const response = await apiService.post<IRefreshTokenResponse>(
        `${this.baseUrl}/refresh`,
        refreshTokenData
      );

      // 새로운 accessToken이 있으면 localStorage에 저장
      if (response.data?.accessToken) {
        localStorage.setItem("token", response.data.accessToken);
      }

      return response.data;
    } catch (error) {
      console.error("토큰 갱신 실패:", error);
      throw error;
    }
  }

  /**
   * 비밀번호 변경
   */
  async changePassword(
    passwordData: IChangePasswordRequest
  ): Promise<ISuccessResponse> {
    try {
      const response = await apiService.put<ISuccessResponse>(
        `${this.baseUrl}/change-password`,
        passwordData
      );
      return response.data;
    } catch (error) {
      console.error("비밀번호 변경 실패:", error);
      throw error;
    }
  }

  /**
   * 비밀번호 재설정 요청
   */
  async resetPassword(
    resetData: IResetPasswordRequest
  ): Promise<IPasswordResetResponse> {
    try {
      const response = await apiService.post<IPasswordResetResponse>(
        `${this.baseUrl}/reset-password`,
        resetData
      );
      return response.data;
    } catch (error) {
      console.error("비밀번호 재설정 요청 실패:", error);
      throw error;
    }
  }

  /**
   * 이메일 인증
   */
  async verifyEmail(
    verifyData: IVerifyEmailRequest
  ): Promise<IEmailVerificationResponse> {
    try {
      const response = await apiService.post<IEmailVerificationResponse>(
        `${this.baseUrl}/verify-email`,
        verifyData
      );
      return response.data;
    } catch (error) {
      console.error("이메일 인증 실패:", error);
      throw error;
    }
  }

  /**
   * 현재 저장된 토큰 가져오기
   */
  getToken(): string | null {
    return localStorage.getItem("token");
  }

  /**
   * 토큰 존재 여부 확인
   */
  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  /**
   * 토큰 제거
   */
  clearToken(): void {
    localStorage.removeItem("token");
  }
}

export const authService = new AuthService();
