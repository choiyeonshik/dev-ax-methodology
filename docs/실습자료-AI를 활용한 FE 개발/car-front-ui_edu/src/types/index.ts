/**
 * 기본 타입 정의
 */

// Auth 타입들 export
export * from "./auth";


// 사용자 인터페이스
export interface IUser {
  id: string;
  name: string;
  email: string;
  role: string;
  createdAt: Date;
  updatedAt: Date;
}

// API 응답 인터페이스
export interface IApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  timestamp?: string;
  errorCode?: string;
  errorDetails?: string;
}

// 페이지네이션 인터페이스
export interface IPagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

// 페이지네이션된 응답 인터페이스
export interface IPaginatedResponse<T> extends IApiResponse<T[]> {
  pagination: IPagination;
}

// 라우트 인터페이스
export interface IRoute {
  path: string;
  element: React.ComponentType;
  children?: IRoute[];
  requireAuth?: boolean;
  roles?: string[];
}
