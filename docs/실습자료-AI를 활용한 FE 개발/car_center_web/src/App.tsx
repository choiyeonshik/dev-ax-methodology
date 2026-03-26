import { useState } from "react";
import { Header } from "./components/Header";
import { HeroSection } from "./components/HeroSection";
import { ServicesSection } from "./components/ServicesSection";
import { TestimonialsSection } from "./components/TestimonialsSection";
import { Footer } from "./components/Footer";
import { ServiceStatusDetail } from "./components/ServiceStatusDetail";
import { ServiceBooking } from "./components/ServiceBooking";
import { DateTimeSelection } from "./components/DateTimeSelection";
import { VehicleInfo } from "./components/VehicleInfo";
import { FinalConfirmation } from "./components/FinalConfirmation";
import { BookingManagement } from "./components/BookingManagement";
import { ServiceHistory } from "./components/ServiceHistory";
import { Login } from "./components/Login";
import { SignUp } from "./components/SignUp";

interface SelectedService {
  id: string;
  name: string;
  price: number;
  duration: string;
}

interface Vehicle {
  id: string;
  licensePlate: string;
  brand: string;
  model: string;
  year: number;
  mileage: number;
  fuelType: string;
}

interface BookingData {
  services: SelectedService[];
  dateTime: { date: string; time: string };
  vehicle: Vehicle;
}

interface UserInfo {
  email: string;
  name: string;
  phone: string;
  userType: 'customer' | 'admin' | 'center-manager';
}

type PageType = 'home' | 'status' | 'booking' | 'datetime' | 'vehicle' | 'final' | 'booking-management' | 'service-history' | 'login' | 'signup';

export default function App() {
  const [currentPage, setCurrentPage] = useState<PageType>('home');
  const [bookingData, setBookingData] = useState<Partial<BookingData>>({});
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userInfo, setUserInfo] = useState<UserInfo | null>(null);

  // 로그인이 필요한 페이지들에 대한 접근 제어
  const showStatusPage = () => {
    if (!isLoggedIn) {
      setCurrentPage('login');
      return;
    }
    setCurrentPage('status');
  };

  const showBookingPage = () => setCurrentPage('booking');

  const showBookingManagementPage = () => {
    if (!isLoggedIn) {
      setCurrentPage('login');
      return;
    }
    setCurrentPage('booking-management');
  };

  const showServiceHistoryPage = () => {
    if (!isLoggedIn) {
      setCurrentPage('login');
      return;
    }
    setCurrentPage('service-history');
  };

  const showLoginPage = () => setCurrentPage('login');
  const showSignUpPage = () => setCurrentPage('signup');
  
  const showDateTimePage = (services: SelectedService[]) => {
    setBookingData(prev => ({ ...prev, services }));
    setCurrentPage('datetime');
  };
  
  const showVehiclePage = (dateTime: { date: string; time: string }) => {
    setBookingData(prev => ({ ...prev, dateTime }));
    setCurrentPage('vehicle');
  };
  
  const showFinalPage = (vehicle: Vehicle) => {
    setBookingData(prev => ({ ...prev, vehicle }));
    setCurrentPage('final');
  };
  
  const showHomePage = () => {
    setCurrentPage('home');
    setBookingData({});
  };
  
  const goBackToBooking = () => setCurrentPage('booking');
  const goBackToDateTime = () => setCurrentPage('datetime');
  const goBackToVehicle = () => setCurrentPage('vehicle');

  const handleFinalConfirmation = () => {
    // In a real app, this would make an API call to create the booking
    alert('예약이 완료되었습니다! 예약 확인 메시지를 발송해드렸습니다.');
    showHomePage();
  };

  const handleLogin = (email: string, password: string) => {
    // Mock login validation
    const mockUsers = [
      { email: 'customer@demo.com', password: 'demo123', name: '홍길동', phone: '010-1234-5678', userType: 'customer' as const },
      { email: 'admin@demo.com', password: 'demo123', name: '관리자', phone: '010-9876-5432', userType: 'admin' as const },
      { email: 'manager@demo.com', password: 'demo123', name: '센터매니저', phone: '010-5678-1234', userType: 'center-manager' as const }
    ];

    const user = mockUsers.find(u => u.email === email && u.password === password);
    
    if (user) {
      setIsLoggedIn(true);
      setUserInfo({
        email: user.email,
        name: user.name,
        phone: user.phone,
        userType: user.userType
      });
      alert(`${user.name}님, 환영합니다!`);
      showHomePage();
    } else {
      alert('이메일 또는 비밀번호가 올바르지 않습니다.');
    }
  };

  const handleSignUp = (userData: any) => {
    // Mock signup process
    setIsLoggedIn(true);
    setUserInfo({
      email: userData.email,
      name: userData.name,
      phone: userData.phone,
      userType: userData.userType
    });
    alert(`${userData.name}님, 회원가입이 완료되었습니다! 환영합니다.`);
    showHomePage();
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
    setUserInfo(null);
    setBookingData({});
    alert('로그아웃되었습니다.');
    showHomePage();
  };

  // Auth pages - 별도 레이아웃 유지
  if (currentPage === 'login') {
    return (
      <Login 
        onShowSignUp={showSignUpPage}
        onLogin={handleLogin}
        onLogoClick={showHomePage}
      />
    );
  }

  if (currentPage === 'signup') {
    return (
      <SignUp 
        onShowLogin={showLoginPage}
        onSignUp={handleSignUp}
        onLogoClick={showHomePage}
      />
    );
  }

  // 모든 서브페이지에 Header ���함
  if (currentPage === 'status') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <ServiceStatusDetail />
      </div>
    );
  }

  if (currentPage === 'booking') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <ServiceBooking 
          onNext={showDateTimePage}
        />
      </div>
    );
  }

  if (currentPage === 'datetime') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <DateTimeSelection 
          selectedServices={bookingData.services || []}
          onBack={goBackToBooking}
          onNext={showVehiclePage}
        />
      </div>
    );
  }

  if (currentPage === 'vehicle') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <VehicleInfo 
          selectedServices={bookingData.services || []}
          selectedDateTime={bookingData.dateTime || { date: '', time: '' }}
          onBack={goBackToDateTime}
          onNext={showFinalPage}
        />
      </div>
    );
  }

  if (currentPage === 'final') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <FinalConfirmation 
          selectedServices={bookingData.services || []}
          selectedDateTime={bookingData.dateTime || { date: '', time: '' }}
          selectedVehicle={bookingData.vehicle!}
          onBack={goBackToVehicle}
          onConfirm={handleFinalConfirmation}
        />
      </div>
    );
  }

  if (currentPage === 'booking-management') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <BookingManagement />
      </div>
    );
  }

  if (currentPage === 'service-history') {
    return (
      <div className="min-h-screen bg-white">
        <Header 
          onStatusClick={showStatusPage} 
          onBookingClick={showBookingPage}
          onBookingManagementClick={showBookingManagementPage}
          onServiceHistoryClick={showServiceHistoryPage}
          onLoginClick={showLoginPage}
          onSignUpClick={showSignUpPage}
          onLogoClick={showHomePage}
          isLoggedIn={isLoggedIn}
          userInfo={userInfo}
          onLogout={handleLogout}
        />
        <ServiceHistory />
      </div>
    );
  }

  // 홈페이지
  return (
    <div className="min-h-screen bg-white">
      <Header 
        onStatusClick={showStatusPage} 
        onBookingClick={showBookingPage}
        onBookingManagementClick={showBookingManagementPage}
        onServiceHistoryClick={showServiceHistoryPage}
        onLoginClick={showLoginPage}
        onSignUpClick={showSignUpPage}
        onLogoClick={showHomePage}
        isLoggedIn={isLoggedIn}
        userInfo={userInfo}
        onLogout={handleLogout}
      />
      <main>
        <HeroSection onStatusClick={showStatusPage} onBookingClick={showBookingPage} />
        <ServicesSection onStatusClick={showStatusPage} onBookingClick={showBookingPage} onServiceHistoryClick={showServiceHistoryPage} />
        <TestimonialsSection />
      </main>
      <Footer />
    </div>
  );
}