import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Checkbox } from "./ui/checkbox";
import { 
  Eye,
  EyeOff,
  Mail,
  Lock,
  User,
  Phone,
  Car,
  AlertCircle,
  CheckCircle2,
  Users
} from "lucide-react";

interface SignUpProps {
  onShowLogin: () => void;
  onSignUp: (userData: any) => void;
  onLogoClick?: () => void;
}

export function SignUp({ onShowLogin, onSignUp, onLogoClick }: SignUpProps) {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    name: '',
    phone: '',
    userType: 'customer'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [agreements, setAgreements] = useState({
    terms: false,
    privacy: false,
    marketing: false
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isLoading, setIsLoading] = useState(false);

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    // 이메일 검증
    if (!formData.email) {
      newErrors.email = '이메일을 입력해주세요';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = '올바른 이메일 형식을 입력해주세요';
    }

    // 비밀번호 검증
    if (!formData.password) {
      newErrors.password = '비밀번호를 입력해주세요';
    } else if (formData.password.length < 8) {
      newErrors.password = '비밀번호는 8자 이상이어야 합니다';
    } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(formData.password)) {
      newErrors.password = '영문 대소문자와 숫자를 포함해주세요';
    }

    // 비밀번호 확인
    if (!formData.confirmPassword) {
      newErrors.confirmPassword = '비밀번호 확인을 입력해주세요';
    } else if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = '비밀번호가 일치하지 않습니다';
    }

    // 이름 검증
    if (!formData.name) {
      newErrors.name = '이름을 입력해주세요';
    } else if (formData.name.length < 2) {
      newErrors.name = '이름은 2자 이상이어야 합니다';
    }

    // 전화번호 검증
    if (!formData.phone) {
      newErrors.phone = '전화번호를 입력해주세요';
    } else if (!/^010-\d{4}-\d{4}$/.test(formData.phone)) {
      newErrors.phone = '올바른 전화번호 형식을 입력해주세요 (010-1234-5678)';
    }

    // 약관 동의
    if (!agreements.terms) {
      newErrors.terms = '서비스 이용약관에 동의해주세요';
    }
    if (!agreements.privacy) {
      newErrors.privacy = '개인정보 처리방침에 동의해주세요';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;
    
    setIsLoading(true);
    
    // Mock signup delay
    setTimeout(() => {
      setIsLoading(false);
      onSignUp({
        ...formData,
        agreements
      });
    }, 1500);
  };

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const handlePhoneChange = (value: string) => {
    // Auto-format phone number
    const numbers = value.replace(/[^\d]/g, '');
    let formatted = numbers;
    
    if (numbers.length >= 3) {
      formatted = numbers.slice(0, 3) + '-';
      if (numbers.length >= 7) {
        formatted += numbers.slice(3, 7) + '-' + numbers.slice(7, 11);
      } else {
        formatted += numbers.slice(3);
      }
    }
    
    handleInputChange('phone', formatted);
  };

  const getPasswordStrength = (password: string) => {
    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[^a-zA-Z\d]/.test(password)) strength++;
    
    return strength;
  };

  const passwordStrength = getPasswordStrength(formData.password);
  const strengthLabels = ['매우 약함', '약함', '보통', '강함', '매우 강함'];
  const strengthColors = ['bg-error', 'bg-warning', 'bg-warning', 'bg-success', 'bg-success'];



  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-white to-secondary/5">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <button 
            onClick={onLogoClick}
            className="flex items-center gap-2 hover:opacity-80 transition-opacity"
          >
            <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
              <Car className="w-5 h-5 text-white" />
            </div>
            <span className="font-bold text-lg text-primary">CarCare</span>
          </button>
        </div>
      </div>

      <div className="flex items-center justify-center px-4 py-8">
        <div className="w-full max-w-md">
          <Card className="card-shadow border-0 bg-white/90 backdrop-blur">
            <CardHeader className="text-center pb-6">
              <div className="w-16 h-16 bg-gradient-to-br from-secondary to-secondary/80 rounded-xl flex items-center justify-center mx-auto mb-4">
                <Users className="w-8 h-8 text-white" />
              </div>
              <CardTitle className="text-2xl text-gray-900">회원가입</CardTitle>
              <p className="text-gray-600 mt-2">CarCare 서비스에 가입하여 편리한 정비 서비스를 이용하세요</p>
            </CardHeader>
            
            <CardContent className="space-y-6">
              <form onSubmit={handleSubmit} className="space-y-4">
                {/* User Type */}
                <div className="space-y-3">
                  <Label>사용자 유형</Label>
                  <div className="grid grid-cols-3 gap-2">
                    <button
                      type="button"
                      onClick={() => handleInputChange('userType', 'customer')}
                      className={`p-3 border-2 rounded-lg transition-all duration-200 text-center ${
                        formData.userType === 'customer'
                          ? 'border-primary bg-primary/5 text-primary font-medium' 
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50 text-gray-700'
                      }`}
                    >
                      고객
                    </button>
                    <button
                      type="button"
                      onClick={() => handleInputChange('userType', 'center-manager')}
                      className={`p-3 border-2 rounded-lg transition-all duration-200 text-center ${
                        formData.userType === 'center-manager'
                          ? 'border-primary bg-primary/5 text-primary font-medium' 
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50 text-gray-700'
                      }`}
                    >
                      센터매니저
                    </button>
                    <button
                      type="button"
                      onClick={() => handleInputChange('userType', 'admin')}
                      className={`p-3 border-2 rounded-lg transition-all duration-200 text-center ${
                        formData.userType === 'admin'
                          ? 'border-primary bg-primary/5 text-primary font-medium' 
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50 text-gray-700'
                      }`}
                    >
                      관리자
                    </button>
                  </div>
                </div>

                {/* Email */}
                <div className="space-y-2">
                  <Label htmlFor="email">이메일 <span className="text-error">*</span></Label>
                  <div className="relative">
                    <Mail className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                    <Input
                      id="email"
                      type="email"
                      placeholder="example@email.com"
                      value={formData.email}
                      onChange={(e) => handleInputChange('email', e.target.value)}
                      className={`pl-10 ${errors.email ? 'border-error focus:ring-error' : ''}`}
                    />
                  </div>
                  {errors.email && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      {errors.email}
                    </div>
                  )}
                </div>

                {/* Password */}
                <div className="space-y-2">
                  <Label htmlFor="password">비밀번호 <span className="text-error">*</span></Label>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                    <Input
                      id="password"
                      type={showPassword ? 'text' : 'password'}
                      placeholder="8자 이상의 영문, 숫자 조합"
                      value={formData.password}
                      onChange={(e) => handleInputChange('password', e.target.value)}
                      className={`pl-10 pr-10 ${errors.password ? 'border-error focus:ring-error' : ''}`}
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                    >
                      {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                  {formData.password && (
                    <div className="space-y-2">
                      <div className="flex items-center gap-2">
                        <div className="flex-1 h-1 bg-gray-200 rounded-full overflow-hidden">
                          <div 
                            className={`h-full transition-all duration-300 ${strengthColors[passwordStrength - 1] || 'bg-gray-200'}`}
                            style={{ width: `${(passwordStrength / 5) * 100}%` }}
                          ></div>
                        </div>
                        <span className="text-xs text-gray-600">
                          {strengthLabels[passwordStrength - 1] || '입력하세요'}
                        </span>
                      </div>
                    </div>
                  )}
                  {errors.password && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      {errors.password}
                    </div>
                  )}
                </div>

                {/* Confirm Password */}
                <div className="space-y-2">
                  <Label htmlFor="confirmPassword">비밀번호 확인 <span className="text-error">*</span></Label>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                    <Input
                      id="confirmPassword"
                      type={showConfirmPassword ? 'text' : 'password'}
                      placeholder="비밀번호를 다시 입력하세요"
                      value={formData.confirmPassword}
                      onChange={(e) => handleInputChange('confirmPassword', e.target.value)}
                      className={`pl-10 pr-10 ${errors.confirmPassword ? 'border-error focus:ring-error' : 
                        formData.confirmPassword && formData.password === formData.confirmPassword ? 'border-success focus:ring-success' : ''}`}
                    />
                    <button
                      type="button"
                      onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                    >
                      {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                  {formData.confirmPassword && formData.password === formData.confirmPassword && (
                    <div className="flex items-center gap-2 text-sm text-success">
                      <CheckCircle2 className="w-4 h-4" />
                      비밀번호가 일치합니다
                    </div>
                  )}
                  {errors.confirmPassword && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      {errors.confirmPassword}
                    </div>
                  )}
                </div>

                {/* Name */}
                <div className="space-y-2">
                  <Label htmlFor="name">이름 <span className="text-error">*</span></Label>
                  <div className="relative">
                    <User className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                    <Input
                      id="name"
                      type="text"
                      placeholder="홍길동"
                      value={formData.name}
                      onChange={(e) => handleInputChange('name', e.target.value)}
                      className={`pl-10 ${errors.name ? 'border-error focus:ring-error' : ''}`}
                    />
                  </div>
                  {errors.name && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      {errors.name}
                    </div>
                  )}
                </div>

                {/* Phone */}
                <div className="space-y-2">
                  <Label htmlFor="phone">전화번호 <span className="text-error">*</span></Label>
                  <div className="relative">
                    <Phone className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                    <Input
                      id="phone"
                      type="tel"
                      placeholder="010-1234-5678"
                      value={formData.phone}
                      onChange={(e) => handlePhoneChange(e.target.value)}
                      maxLength={13}
                      className={`pl-10 ${errors.phone ? 'border-error focus:ring-error' : ''}`}
                    />
                  </div>
                  {errors.phone && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      {errors.phone}
                    </div>
                  )}
                </div>

                {/* Agreements */}
                <div className="space-y-3">
                  <Label>약관 동의</Label>
                  <div className="space-y-3">
                    <div className="flex items-start space-x-3">
                      <Checkbox 
                        id="terms"
                        checked={agreements.terms}
                        onCheckedChange={(checked) => {
                          setAgreements(prev => ({ ...prev, terms: checked as boolean }));
                          if (errors.terms) setErrors(prev => ({ ...prev, terms: '' }));
                        }}
                      />
                      <Label htmlFor="terms" className="text-sm leading-6 cursor-pointer">
                        <span className="text-error">*</span> 서비스 이용약관에 동의합니다. 
                        <button type="button" className="text-primary underline ml-1">자세히 보기</button>
                      </Label>
                    </div>
                    <div className="flex items-start space-x-3">
                      <Checkbox 
                        id="privacy"
                        checked={agreements.privacy}
                        onCheckedChange={(checked) => {
                          setAgreements(prev => ({ ...prev, privacy: checked as boolean }));
                          if (errors.privacy) setErrors(prev => ({ ...prev, privacy: '' }));
                        }}
                      />
                      <Label htmlFor="privacy" className="text-sm leading-6 cursor-pointer">
                        <span className="text-error">*</span> 개인정보 처리방침에 동의합니다. 
                        <button type="button" className="text-primary underline ml-1">자세히 보기</button>
                      </Label>
                    </div>
                    <div className="flex items-start space-x-3">
                      <Checkbox 
                        id="marketing"
                        checked={agreements.marketing}
                        onCheckedChange={(checked) => setAgreements(prev => ({ ...prev, marketing: checked as boolean }))}
                      />
                      <Label htmlFor="marketing" className="text-sm leading-6 cursor-pointer">
                        마케팅 정보 수신에 동의합니다. (선택)
                      </Label>
                    </div>
                  </div>
                  {(errors.terms || errors.privacy) && (
                    <div className="flex items-center gap-2 text-sm text-error">
                      <AlertCircle className="w-4 h-4" />
                      필수 약관에 동의해주세요
                    </div>
                  )}
                </div>

                {/* Sign Up Button */}
                <Button 
                  type="submit" 
                  className="w-full btn-height bg-gradient-to-r from-secondary to-secondary/90 hover:from-secondary/90 hover:to-secondary text-white"
                  disabled={isLoading}
                >
                  {isLoading ? (
                    <div className="flex items-center gap-2">
                      <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                      회원가입 중...
                    </div>
                  ) : (
                    '회원가입'
                  )}
                </Button>
              </form>

              {/* Login Link */}
              <div className="text-center pt-4 border-t border-gray-200">
                <p className="text-gray-600">
                  이미 계정이 있으신가요?{' '}
                  <button 
                    onClick={onShowLogin}
                    className="text-primary hover:text-primary/80 font-medium underline"
                  >
                    로그인
                  </button>
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}