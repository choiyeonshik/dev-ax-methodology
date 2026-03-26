import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Checkbox } from "./ui/checkbox";
import { RadioGroup, RadioGroupItem } from "./ui/radio-group";
import { Separator } from "./ui/separator";
import { 
  ArrowLeft,
  Car,
  Calendar,
  Clock,
  CreditCard,
  Smartphone,
  Building,
  Tag,
  CheckCircle,
  Shield,
  FileText,
  Gift
} from "lucide-react";

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

interface FinalConfirmationProps {
  selectedServices: SelectedService[];
  selectedDateTime: {
    date: string;
    time: string;
  };
  selectedVehicle: Vehicle;
  onBack: () => void;
  onConfirm: () => void;
}

export function FinalConfirmation({ 
  selectedServices, 
  selectedDateTime, 
  selectedVehicle, 
  onBack, 
  onConfirm 
}: FinalConfirmationProps) {
  const [couponCode, setCouponCode] = useState('');
  const [appliedCoupon, setAppliedCoupon] = useState<{ code: string; discount: number } | null>(null);
  const [paymentMethod, setPaymentMethod] = useState('card');
  const [agreements, setAgreements] = useState({
    privacy: false,
    terms: false,
    marketing: false
  });

  const mockCoupons = [
    { code: 'FIRST10', discount: 10000, description: '신규고객 10% 할인' },
    { code: 'WELCOME5', discount: 5000, description: '웰컴 쿠폰 5,000원 할인' }
  ];

  const getSubtotal = () => {
    return selectedServices.reduce((total, service) => total + service.price, 0);
  };

  const getDiscount = () => {
    return appliedCoupon?.discount || 0;
  };

  const getFinalTotal = () => {
    return getSubtotal() - getDiscount();
  };

  const getTotalDuration = () => {
    const totalMinutes = selectedServices.reduce((total, service) => {
      const duration = service.duration;
      const minutes = duration.includes("시간") 
        ? parseInt(duration) * 60 + (parseInt(duration.split("시간")[1]) || 0)
        : parseInt(duration);
      return total + minutes;
    }, 0);

    if (totalMinutes >= 60) {
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      return minutes > 0 ? `${hours}시간 ${minutes}분` : `${hours}시간`;
    }
    return `${totalMinutes}분`;
  };

  const applyCoupon = () => {
    const coupon = mockCoupons.find(c => c.code === couponCode.toUpperCase());
    if (coupon) {
      setAppliedCoupon(coupon);
      setCouponCode('');
    } else {
      alert('유효하지 않은 쿠폰 코드입니다.');
    }
  };

  const removeCoupon = () => {
    setAppliedCoupon(null);
  };

  const isFormValid = () => {
    return agreements.privacy && agreements.terms;
  };

  const getPaymentIcon = (method: string) => {
    switch (method) {
      case 'card': return <CreditCard className="w-4 h-4" />;
      case 'mobile': return <Smartphone className="w-4 h-4" />;
      case 'bank': return <Building className="w-4 h-4" />;
      default: return <CreditCard className="w-4 h-4" />;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center gap-4 mb-6">
            <Button variant="ghost" size="sm" onClick={onBack}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              이전 단계
            </Button>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">최종 확인</h1>
              <p className="text-gray-600 mt-1">예약 내용을 확인하고 결제를 진행하세요</p>
            </div>
          </div>

          {/* Progress Steps */}
          <div className="bg-gradient-to-r from-blue-50 to-orange-50 rounded-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="text-sm font-medium text-gray-600">예약 진행 단계</div>
              <div className="text-sm text-secondary font-medium">4/4 단계</div>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-secondary rounded-full flex items-center justify-center text-white font-medium text-sm">
                4
              </div>
              <div className="text-sm font-medium text-secondary">최종 확인</div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Booking Summary */}
            <Card className="card-shadow border-0">
              <CardHeader className="bg-gradient-to-r from-primary/5 to-secondary/5">
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary" />
                  예약 요약서
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                {/* Services */}
                <div>
                  <h4 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                    <CheckCircle className="w-4 h-4 text-success" />
                    선택된 서비스
                  </h4>
                  <div className="space-y-3">
                    {selectedServices.map(service => (
                      <div key={service.id} className="flex justify-between items-center p-4 bg-gray-50 rounded-lg">
                        <div>
                          <div className="font-medium text-gray-900">{service.name}</div>
                          <div className="text-sm text-gray-500">{service.duration}</div>
                        </div>
                        <div className="font-bold text-primary">
                          {service.price.toLocaleString()}원
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                <Separator />

                {/* Date & Time */}
                <div>
                  <h4 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                    <Calendar className="w-4 h-4 text-primary" />
                    예약 일시
                  </h4>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <div className="text-sm text-gray-600">날짜</div>
                        <div className="font-medium text-gray-900">{selectedDateTime.date}</div>
                      </div>
                      <div>
                        <div className="text-sm text-gray-600">시간</div>
                        <div className="font-medium text-gray-900">{selectedDateTime.time}</div>
                      </div>
                    </div>
                    <div className="mt-3 pt-3 border-t border-blue-200">
                      <div className="text-sm text-gray-600">예상 소요 시간</div>
                      <div className="font-medium text-primary">{getTotalDuration()}</div>
                    </div>
                  </div>
                </div>

                <Separator />

                {/* Vehicle */}
                <div>
                  <h4 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                    <Car className="w-4 h-4 text-primary" />
                    차량 정보
                  </h4>
                  <div className="p-4 bg-gray-50 rounded-lg">
                    <div className="flex items-center gap-4">
                      <div className="p-3 bg-primary/10 rounded-lg">
                        <Car className="w-6 h-6 text-primary" />
                      </div>
                      <div>
                        <div className="font-bold text-lg text-gray-900">{selectedVehicle.licensePlate}</div>
                        <div className="text-gray-600">
                          {selectedVehicle.brand} {selectedVehicle.model} ({selectedVehicle.year}년)
                        </div>
                        <div className="text-sm text-gray-500">
                          주행거리: {selectedVehicle.mileage.toLocaleString()}km · 연료: {selectedVehicle.fuelType}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Coupon Section */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Gift className="w-5 h-5 text-secondary" />
                  할인 쿠폰
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {!appliedCoupon ? (
                  <div className="flex gap-3">
                    <Input
                      placeholder="쿠폰 코드를 입력하세요"
                      value={couponCode}
                      onChange={(e) => setCouponCode(e.target.value)}
                      className="flex-1"
                    />
                    <Button 
                      variant="outline" 
                      onClick={applyCoupon}
                      disabled={!couponCode.trim()}
                    >
                      적용
                    </Button>
                  </div>
                ) : (
                  <div className="p-4 bg-success/10 border border-success/20 rounded-lg">
                    <div className="flex items-center justify-between">
                      <div>
                        <div className="font-medium text-success">{appliedCoupon.code}</div>
                        <div className="text-sm text-gray-600">
                          {mockCoupons.find(c => c.code === appliedCoupon.code)?.description}
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-success">-{appliedCoupon.discount.toLocaleString()}원</span>
                        <Button 
                          variant="ghost" 
                          size="sm" 
                          onClick={removeCoupon}
                          className="text-gray-500 hover:text-gray-700"
                        >
                          제거
                        </Button>
                      </div>
                    </div>
                  </div>
                )}
                
                <div className="text-xs text-gray-500">
                  <p>💡 사용 가능한 쿠폰: FIRST10 (신규고객), WELCOME5 (웰컴쿠폰)</p>
                </div>
              </CardContent>
            </Card>

            {/* Payment Method */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CreditCard className="w-5 h-5 text-primary" />
                  결제 방법
                </CardTitle>
              </CardHeader>
              <CardContent>
                <RadioGroup value={paymentMethod} onValueChange={setPaymentMethod}>
                  <div className="space-y-3">
                    <div className="flex items-center space-x-3 p-3 border rounded-lg hover:bg-gray-50">
                      <RadioGroupItem value="card" id="card" />
                      <Label htmlFor="card" className="flex items-center gap-2 cursor-pointer flex-1">
                        <CreditCard className="w-4 h-4" />
                        신용카드 / 체크카드
                      </Label>
                    </div>
                    <div className="flex items-center space-x-3 p-3 border rounded-lg hover:bg-gray-50">
                      <RadioGroupItem value="mobile" id="mobile" />
                      <Label htmlFor="mobile" className="flex items-center gap-2 cursor-pointer flex-1">
                        <Smartphone className="w-4 h-4" />
                        휴대폰 결제
                      </Label>
                    </div>
                    <div className="flex items-center space-x-3 p-3 border rounded-lg hover:bg-gray-50">
                      <RadioGroupItem value="bank" id="bank" />
                      <Label htmlFor="bank" className="flex items-center gap-2 cursor-pointer flex-1">
                        <Building className="w-4 h-4" />
                        계좌이체
                      </Label>
                    </div>
                  </div>
                </RadioGroup>
              </CardContent>
            </Card>

            {/* Agreements */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="w-5 h-5 text-primary" />
                  약관 동의
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-3">
                  <div className="flex items-start space-x-3">
                    <Checkbox 
                      id="privacy"
                      checked={agreements.privacy}
                      onCheckedChange={(checked) => 
                        setAgreements(prev => ({ ...prev, privacy: checked as boolean }))
                      }
                    />
                    <Label htmlFor="privacy" className="text-sm leading-6 cursor-pointer">
                      <span className="text-red-500">*</span> 개인정보 수집 및 이용에 동의합니다. 
                      <button className="text-primary underline ml-1">자세히 보기</button>
                    </Label>
                  </div>
                  <div className="flex items-start space-x-3">
                    <Checkbox 
                      id="terms"
                      checked={agreements.terms}
                      onCheckedChange={(checked) => 
                        setAgreements(prev => ({ ...prev, terms: checked as boolean }))
                      }
                    />
                    <Label htmlFor="terms" className="text-sm leading-6 cursor-pointer">
                      <span className="text-red-500">*</span> 서비스 이용약관에 동의합니다. 
                      <button className="text-primary underline ml-1">자세히 보기</button>
                    </Label>
                  </div>
                  <div className="flex items-start space-x-3">
                    <Checkbox 
                      id="marketing"
                      checked={agreements.marketing}
                      onCheckedChange={(checked) => 
                        setAgreements(prev => ({ ...prev, marketing: checked as boolean }))
                      }
                    />
                    <Label htmlFor="marketing" className="text-sm leading-6 cursor-pointer">
                      마케팅 정보 수신에 동의합니다. (선택)
                      <button className="text-primary underline ml-1">자세히 보기</button>
                    </Label>
                  </div>
                </div>
                <div className="text-xs text-gray-500 mt-4">
                  <span className="text-red-500">*</span> 필수 동의 항목
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Price Summary Sidebar */}
          <div className="space-y-6">
            <Card className="card-shadow border-0 sticky top-6">
              <CardHeader className="bg-gradient-to-r from-primary/5 to-secondary/5">
                <CardTitle>결제 정보</CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-4">
                <div className="space-y-3">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">서비스 금액</span>
                    <span className="font-medium">{getSubtotal().toLocaleString()}원</span>
                  </div>
                  {appliedCoupon && (
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">쿠폰 할인</span>
                      <span className="font-medium text-success">-{getDiscount().toLocaleString()}원</span>
                    </div>
                  )}
                  <Separator />
                  <div className="flex justify-between">
                    <span className="font-semibold text-gray-900">총 결제 금액</span>
                    <span className="text-xl font-bold text-primary">
                      {getFinalTotal().toLocaleString()}원
                    </span>
                  </div>
                </div>

                <div className="pt-4 border-t">
                  <div className="flex items-center gap-2 mb-4">
                    {getPaymentIcon(paymentMethod)}
                    <span className="text-sm text-gray-600">
                      {paymentMethod === 'card' ? '신용카드 결제' :
                       paymentMethod === 'mobile' ? '휴대폰 결제' : '계좌이체'}
                    </span>
                  </div>
                  
                  <Button 
                    className="w-full btn-height text-white font-bold bg-gradient-to-r from-secondary to-orange-400 hover:from-secondary/90 hover:to-orange-400/90 shadow-lg hover:shadow-xl transition-all duration-200"
                    onClick={onConfirm}
                    disabled={!isFormValid()}
                  >
                    {getFinalTotal().toLocaleString()}원 결제하기
                  </Button>
                </div>
              </CardContent>
            </Card>

            {/* Security Notice */}
            <Card className="bg-green-50 border-green-200">
              <CardContent className="p-4">
                <div className="text-sm text-green-800">
                  <div className="flex items-center gap-2 mb-2">
                    <Shield className="w-4 h-4" />
                    <p className="font-medium">안전한 결제</p>
                  </div>
                  <ul className="space-y-1 text-green-700">
                    <li>• SSL 보안 결제 시스템</li>
                    <li>• 개인정보 암호화 처리</li>
                    <li>• 24시간 보안 모니터링</li>
                  </ul>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}