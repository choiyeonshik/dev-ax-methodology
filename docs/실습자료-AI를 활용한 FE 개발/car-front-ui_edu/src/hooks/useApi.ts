/**
 * API 호출 커스텀 훅
 */
import { useState, useCallback } from "react";
import { apiService } from "../services/apiService";
import type { IApiResponse } from "../types";

interface IUseApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

interface IUseApiReturn<T> extends IUseApiState<T> {
  execute: (...args: any[]) => Promise<void>;
  reset: () => void;
}

export const useApi = <T>(
  apiCall: (...args: any[]) => Promise<IApiResponse<T>>
): IUseApiReturn<T> => {
  const [state, setState] = useState<IUseApiState<T>>({
    data: null,
    loading: false,
    error: null,
  });

  const execute = useCallback(
    async (...args: any[]) => {
      setState({ data: null, loading: true, error: null });

      try {
        const response = await apiCall(...args);
        setState({ data: response.data, loading: false, error: null });
      } catch (error) {
        setState({
          data: null,
          loading: false,
          error:
            error instanceof Error
              ? error.message
              : "알 수 없는 오류가 발생했습니다.",
        });
      }
    },
    [apiCall]
  );

  const reset = useCallback(() => {
    setState({ data: null, loading: false, error: null });
  }, []);

  return {
    ...state,
    execute,
    reset,
  };
};
