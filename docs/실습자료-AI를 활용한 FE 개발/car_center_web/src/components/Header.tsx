import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "./ui/dropdown-menu";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Car, Menu, X, User, LogOut, ChevronDown } from "lucide-react";
import { useState } from "react";

interface HeaderProps {
  onStatusClick?: () => void;
  onBookingClick?: () => void;
  onBookingManagementClick?: () => void;
  onServiceHistoryClick?: () => void;
  onLoginClick?: () => void;
  onSignUpClick?: () => void;
  onLogoClick?: () => void;
  isLoggedIn?: boolean;
  userInfo?: { name: string; userType: string; email?: string; };
  onLogout?: () => void;
}

export function Header({ 
  onStatusClick, 
  onBookingClick, 
  onBookingManagementClick, 
  onServiceHistoryClick,
  onLoginClick,
  onSignUpClick,
  onLogoClick,
  isLoggedIn = false,
  userInfo,
  onLogout
}: HeaderProps) {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <header className="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex items-center space-16">
            <button 
              onClick={onLogoClick}
              className="flex items-center space-8 hover:opacity-80 transition-opacity"
            >
              <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <Car className="w-6 h-6 text-white" />
              </div>
              <span className="font-bold text-xl text-primary">CarCare</span>
            </button>
          </div>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center space-x-8">
            <a href="#" className="text-gray-700 hover:text-primary transition-colors">
              서비스 소개
            </a>
            <button 
              onClick={onBookingClick}
              className="text-gray-700 hover:text-primary transition-colors"
            >
              예약하기
            </button>
            <button 
              onClick={onStatusClick}
              className="text-gray-700 hover:text-primary transition-colors"
            >
              실시간 현황 확인
            </button>
            <button 
              onClick={onBookingManagementClick}
              className="text-gray-700 hover:text-primary transition-colors"
            >
              예약 관리
            </button>
            <button 
              onClick={onServiceHistoryClick}
              className="text-gray-700 hover:text-primary transition-colors"
            >
              정비 이력
            </button>
          </nav>

          {/* Desktop CTA */}
          <div className="hidden md:flex items-center space-x-4">
            {isLoggedIn && userInfo ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" className="flex items-center space-x-2 p-2 hover:bg-gray-50">
                    <Avatar className="w-8 h-8">
                      <AvatarFallback className="bg-primary/10 text-primary text-sm">
                        {userInfo.name.charAt(0)}
                      </AvatarFallback>
                    </Avatar>
                    <span className="font-medium text-gray-900">{userInfo.name}</span>
                    <ChevronDown className="w-4 h-4 text-gray-500" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-56">
                  <DropdownMenuLabel className="flex flex-col">
                    <span className="font-medium">{userInfo.name}</span>
                    {userInfo.email && <span className="text-sm text-gray-500">{userInfo.email}</span>}
                  </DropdownMenuLabel>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem disabled className="flex items-center gap-2">
                    <Badge variant="outline" className="text-xs">
                      {userInfo.userType === 'admin' ? '관리자' : 
                       userInfo.userType === 'center-manager' ? '센터매니저' : '고객'}
                    </Badge>
                    <span className="text-sm text-gray-600">
                      {userInfo.userType === 'admin' ? '시스템 관리' : 
                       userInfo.userType === 'center-manager' ? '센터 운영 관리' : '서비스 이용'}
                    </span>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem 
                    onClick={onLogout}
                    className="flex items-center gap-2 text-red-600 focus:text-red-600"
                  >
                    <LogOut className="w-4 h-4" />
                    로그아웃
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <>
                <Button 
                  variant="outline" 
                  className="btn-height"
                  onClick={onLoginClick}
                >
                  로그인
                </Button>
                <Button 
                  className="btn-height bg-secondary hover:bg-secondary/90 text-white"
                  onClick={onSignUpClick}
                >
                  회원가입
                </Button>
              </>
            )}
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setIsMenuOpen(!isMenuOpen)}
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </Button>
          </div>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <div className="md:hidden py-4 border-t border-gray-200">
            <div className="flex flex-col space-y-4">
              <a href="#" className="text-gray-700 hover:text-primary transition-colors px-4 py-2">
                서비스 소개
              </a>
              <button 
                onClick={onBookingClick}
                className="text-gray-700 hover:text-primary transition-colors px-4 py-2 text-left w-full"
              >
                예약하기
              </button>
              <button 
                onClick={onStatusClick}
                className="text-gray-700 hover:text-primary transition-colors px-4 py-2 text-left w-full"
              >
                실시간 현황 확인
              </button>
              <button 
                onClick={onBookingManagementClick}
                className="text-gray-700 hover:text-primary transition-colors px-4 py-2 text-left w-full"
              >
                예약 관리
              </button>
              <button 
                onClick={onServiceHistoryClick}
                className="text-gray-700 hover:text-primary transition-colors px-4 py-2 text-left w-full"
              >
                정비 이력
              </button>
              <div className="flex flex-col space-y-2 px-4 pt-4 border-t border-gray-200">
                {isLoggedIn && userInfo ? (
                  <div className="space-y-3">
                    <div className="flex items-center space-x-3 px-2 py-2 bg-gray-50 rounded-lg">
                      <Avatar className="w-10 h-10">
                        <AvatarFallback className="bg-primary/10 text-primary">
                          {userInfo.name.charAt(0)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <div className="font-medium text-gray-900">{userInfo.name}</div>
                        {userInfo.email && <div className="text-sm text-gray-500">{userInfo.email}</div>}
                        <Badge variant="outline" className="text-xs mt-1">
                          {userInfo.userType === 'admin' ? '관리자' : 
                           userInfo.userType === 'center-manager' ? '센터매니저' : '고객'}
                        </Badge>
                      </div>
                    </div>
                    <Button 
                      variant="outline" 
                      className="btn-height w-full text-red-600 border-red-200 hover:bg-red-50"
                      onClick={onLogout}
                    >
                      <LogOut className="w-4 h-4 mr-2" />
                      로그아웃
                    </Button>
                  </div>
                ) : (
                  <>
                    <Button 
                      variant="outline" 
                      className="btn-height"
                      onClick={onLoginClick}
                    >
                      로그인
                    </Button>
                    <Button 
                      className="btn-height bg-secondary hover:bg-secondary/90 text-white"
                      onClick={onSignUpClick}
                    >
                      회원가입
                    </Button>
                  </>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </header>
  );
}