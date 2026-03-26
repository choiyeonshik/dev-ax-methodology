/**
 * 인증 상태 관리 스토어
 */
import { create } from "zustand";
import type { IUser } from "../types";

interface IAuthState {
  user: IUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  token: string | null;
}

interface IAuthActions {
  setUser: (user: IUser | null) => void;
  setToken: (token: string | null) => void;
  setLoading: (loading: boolean) => void;
  login: (user: IUser, token: string) => void;
  logout: () => void;
}

type IAuthStore = IAuthState & IAuthActions;

export const useAuthStore = create<IAuthStore>((set) => ({
  // 상태
  user: null,
  isAuthenticated: false,
  isLoading: false,
  token: null,

  // 액션
  setUser: (user) => set({ user, isAuthenticated: !!user }),
  setToken: (token) => set({ token }),
  setLoading: (isLoading) => set({ isLoading }),

  login: (user, token) =>
    set({
      user,
      token,
      isAuthenticated: true,
      isLoading: false,
    }),

  logout: () =>
    set({
      user: null,
      token: null,
      isAuthenticated: false,
      isLoading: false,
    }),
}));
