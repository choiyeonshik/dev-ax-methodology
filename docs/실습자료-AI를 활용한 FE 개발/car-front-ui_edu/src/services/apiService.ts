/**
 * 기본 API 서비스
 */
import axios from "axios";
import type { AxiosInstance, AxiosRequestConfig, AxiosResponse } from "axios";
import type { IApiResponse } from "../types";

const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || "http://localhost:8080/api/v1";

class ApiService {
  private axiosInstance: AxiosInstance;

  constructor(baseURL: string = API_BASE_URL) {
    this.axiosInstance = axios.create({
      baseURL,
      timeout: 10000,
      headers: {
        "Content-Type": "application/json",
      },
    });

    // 요청 인터셉터 설정
    this.axiosInstance.interceptors.request.use(
      (config) => {
        // 토큰이 있으면 Authorization 헤더 추가
        const token = localStorage.getItem("token");
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => {
        return Promise.reject(error);
      }
    );

    // 응답 인터셉터 설정
    this.axiosInstance.interceptors.response.use(
      (response: AxiosResponse) => {
        return response;
      },
      (error) => {
        console.error("API 요청 오류:", error);
        return Promise.reject(error);
      }
    );
  }

  /**
   * HTTP 요청 처리
   */
  private async request<T>(
    config: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    try {
      const response: AxiosResponse<IApiResponse<T>> = await this.axiosInstance(
        config
      );
      return response.data;
    } catch (error) {
      if (axios.isAxiosError(error)) {
        const message =
          error.response?.data?.message || error.message || "API 요청 실패";
        throw new Error(message);
      }
      throw error;
    }
  }

  /**
   * GET 요청
   */
  async get<T>(
    endpoint: string,
    config?: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    return this.request<T>({
      method: "GET",
      url: endpoint,
      ...config,
    });
  }

  /**
   * POST 요청
   */
  async post<T>(
    endpoint: string,
    data?: unknown,
    config?: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    return this.request<T>({
      method: "POST",
      url: endpoint,
      data,
      ...config,
    });
  }

  /**
   * PUT 요청
   */
  async put<T>(
    endpoint: string,
    data?: unknown,
    config?: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    return this.request<T>({
      method: "PUT",
      url: endpoint,
      data,
      ...config,
    });
  }

  /**
   * DELETE 요청
   */
  async delete<T>(
    endpoint: string,
    config?: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    return this.request<T>({
      method: "DELETE",
      url: endpoint,
      ...config,
    });
  }

  /**
   * PATCH 요청
   */
  async patch<T>(
    endpoint: string,
    data?: unknown,
    config?: AxiosRequestConfig
  ): Promise<IApiResponse<T>> {
    return this.request<T>({
      method: "PATCH",
      url: endpoint,
      data,
      ...config,
    });
  }
}

export const apiService = new ApiService();
