/**
 * 인증 관련 타입 정의
 */

/**
 * 로그인 요청 데이터
 */
export interface ILoginRequest {
  email: string;
  password: string;
}

/**
 * 사용자 정보
 */
export interface IUserInfo {
  id: number;
  userUuid: string;
  email: string;
  name: string;
  phone: string;
  role: string;
  isActive: boolean;
  emailVerified: boolean;
  lastLoginAt: string;
  createdAt: string;
}

/**
 * 로그인 응답 데이터
 */
export interface ILoginResponse {
  accessToken: string;
  refreshToken: string;
  tokenType: string;
  expiresIn: number;
  user: IUserInfo;
  loginTime: string;
}

/**
 * 회원가입 요청 데이터
 */
export interface IRegisterRequest {
  email: string;
  password: string;
  name: string;
  phone: string;
}

/**
 * 회원가입 응답 데이터
 */
export interface IRegisterResponse {
  message: string;
  user: IUserInfo;
  emailVerificationRequired: boolean;
  registeredAt: string;
}

/**
 * 토큰 갱신 요청 데이터
 */
export interface IRefreshTokenRequest {
  refreshToken: string;
}

/**
 * 토큰 갱신 응답 데이터
 */
export interface IRefreshTokenResponse {
  accessToken: string;
  refreshToken: string;
  tokenType: string;
  expiresIn: number;
  refreshedAt: string;
}

/**
 * 비밀번호 변경 요청 데이터
 */
export interface IChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
}

/**
 * 비밀번호 재설정 요청 데이터
 */
export interface IResetPasswordRequest {
  email: string;
}

/**
 * 비밀번호 재설정 응답 데이터
 */
export interface IPasswordResetResponse {
  message: string;
  email: string;
  requestedAt: string;
}

/**
 * 이메일 인증 요청 데이터
 */
export interface IVerifyEmailRequest {
  email: string;
  verificationCode: string;
}

/**
 * 이메일 인증 응답 데이터
 */
export interface IEmailVerificationResponse {
  message: string;
  verified: boolean;
  email: string;
  verifiedAt: string;
}

/**
 * 로그아웃 응답 데이터
 */
export interface ILogoutResponse {
  message: string;
  logoutTime: string;
}

/**
 * 일반 성공 응답 데이터
 */
export interface ISuccessResponse {
  message: string;
  timestamp: string;
}
