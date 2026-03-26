import { Car, Phone, Mail, MapPin, Clock, Facebook, Instagram, Youtube } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Main Footer Content */}
        <div className="py-16 grid lg:grid-cols-4 md:grid-cols-2 gap-8">
          {/* Company Info */}
          <div className="space-y-6">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <Car className="w-6 h-6 text-white" />
              </div>
              <span className="font-bold text-xl">CarCare</span>
            </div>
            <p className="text-gray-400 leading-relaxed">
              신뢰할 수 있는 차량 정비 서비스로 고객의 안전한 운행을 책임집니다. 투명하고 전문적인 서비스를 제공합니다.
            </p>
            <div className="flex space-x-4">
              <div className="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center cursor-pointer transition-colors">
                <Facebook className="w-5 h-5" />
              </div>
              <div className="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center cursor-pointer transition-colors">
                <Instagram className="w-5 h-5" />
              </div>
              <div className="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center cursor-pointer transition-colors">
                <Youtube className="w-5 h-5" />
              </div>
            </div>
          </div>

          {/* Quick Links */}
          <div className="space-y-6">
            <h4 className="font-semibold text-lg">빠른 메뉴</h4>
            <ul className="space-y-3">
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">서비스 소개</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">정비 예약</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">실시간 현황 확인</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">견적 조회</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">정비 이력</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">고객센터</a></li>
            </ul>
          </div>

          {/* Services */}
          <div className="space-y-6">
            <h4 className="font-semibold text-lg">주요 서비스</h4>
            <ul className="space-y-3">
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">엔진오일 교체</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">브레이크 점검</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">타이어 교체</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">배터리 점검</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">종합점검</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors">긴급출동 서비스</a></li>
            </ul>
          </div>

          {/* Contact Info */}
          <div className="space-y-6">
            <h4 className="font-semibold text-lg">연락처</h4>
            <div className="space-y-4">
              <div className="flex items-start space-x-3">
                <Phone className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <div className="font-medium">고객센터</div>
                  <div className="text-gray-400">1588-1234</div>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <Mail className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <div className="font-medium">이메일</div>
                  <div className="text-gray-400">support@carcare.co.kr</div>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <MapPin className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <div className="font-medium">본사 주소</div>
                  <div className="text-gray-400">서울시 강남구 테헤란로 123<br />카케어빌딩 5층</div>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <Clock className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <div className="font-medium">운영시간</div>
                  <div className="text-gray-400">
                    평일: 09:00 - 18:00<br />
                    토요일: 09:00 - 15:00<br />
                    <span className="text-sm">일요일 및 공휴일 휴무</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Bottom Footer */}
        <div className="py-8 border-t border-gray-800">
          <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
            <div className="text-center md:text-left">
              <p className="text-gray-400">
                © 2024 CarCare. All rights reserved.
              </p>
            </div>
            
            <div className="flex flex-wrap justify-center md:justify-end gap-6 text-sm">
              <a href="#" className="text-gray-400 hover:text-white transition-colors">개인정보처리방침</a>
              <a href="#" className="text-gray-400 hover:text-white transition-colors">이용약관</a>
              <a href="#" className="text-gray-400 hover:text-white transition-colors">사업자정보확인</a>
              <a href="#" className="text-gray-400 hover:text-white transition-colors">고객센터</a>
            </div>
          </div>
          
          <div className="mt-4 pt-4 border-t border-gray-800 text-xs text-gray-500 text-center md:text-left">
            <p>
              사업자등록번호: 123-45-67890 | 대표: 홍길동 | 통신판매업신고: 2024-서울강남-1234<br />
              주소: 서울시 강남구 테헤란로 123, 카케어빌딩 5층 | 개인정보보호책임자: 김정비 (privacy@carcare.co.kr)
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}